//
//  FLHttpRequest.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpRequest.h"
#import "FLAppInfo.h"
#import "FLCoreFoundation.h"
#import "FLReadStream.h"
#import "FLHttpMessage.h"
#import "FLGlobalNetworkActivityIndicator.h"
#import "FLDataSink.h"
#import "FLHttpRequestBody.h"
#import "FishLampAsync.h"
#import "FLTimer.h"
#import "FLReachableNetwork.h"
#import "FLHttpRequestByteCount.h"
#import "FLHttpResponse.h"
#import "FLNetworkErrors.h"
#import "FLRetryHandler.h"

#define FORCE_NO_SSL DEBUG

//#define kStreamReadChunkSize 1024

@interface FLHttpResponse ()
@property (readwrite, strong, nonatomic) FLHttpRequestByteCount* byteCount;
@end

@interface FLHttpRequest ()
@property (readwrite, strong, nonatomic) FLHttpResponse* previousResponse;
@property (readwrite, strong, nonatomic) FLHttpStream* httpStream;
@property (readwrite, strong) FLHttpRequestByteCount* byteCount;
- (void) finishRequestWithResult:(FLPromisedResult) result;
@end

@implementation FLHttpRequest

@synthesize requestBody = _requestBody;
@synthesize requestHeaders = _requestHeaders;
@synthesize httpRequestAuthenticator = _httpRequestAuthenticator;
@synthesize disableAuthenticator = _disableAuthenticator;
@synthesize inputSink = _inputSink;
@synthesize httpStream = _httpStream;
@synthesize previousResponse = _previousResponse;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize streamSecurity = _streamSecurity;
@synthesize byteCount = _byteCount;
@synthesize retryHandler = _retryHandler;

#if TRACE
static int s_counter = 0;
#endif

- (id) init {
    return [self initWithRequestURL:nil httpMethod:nil];
}
-(id) initWithRequestURL:(NSURL*) url httpMethod:(NSString*) httpMethod {

    FLAssertNotNil(url);

    if((self = [super init])) {
        self.timeoutInterval = FLHttpRequestDefaultTimeoutInterval;
    
        _requestHeaders = [[FLHttpRequestHeaders alloc] init];
        _requestBody = [[FLHttpRequestBody alloc] initWithHeaders:_requestHeaders];
        
        self.requestHeaders.requestURL = url;
        self.requestHeaders.httpMethod = httpMethod;
        
        if(FLStringIsEmpty(httpMethod)) {
            self.requestHeaders.httpMethod= @"GET";
        }
        else {
            self.requestHeaders.httpMethod = httpMethod;
        }
    }

    FLTrace(@"%d created %@ http request: %@", ++s_counter, self.requestHeaders.httpMethod, [url absoluteString]);
    return self;
}

- (void) releaseResponseData {
    self.previousResponse = nil;
    self.httpStream.delegate = nil;
    self.httpStream = nil;
}

#if FL_MRC
- (void) dealloc {
    FLTrace(@"%d dealloc http request: %@", --s_counter, self.requestHeaders.requestURL);
    [_byteCount release];
    [_asyncQueueForStream release];
    [_previousResponse release];
    [_httpStream release];
    [_inputSink release];
    [_httpRequestAuthenticator release];
    [_requestHeaders release];
    [_requestBody release];
    [_retryHandler release];
    [super dealloc];
}
#endif

+ (id) httpRequestWithURL:(NSURL*) url httpMethod:(NSString*) httpMethod {
    return FLAutorelease([[[self class] alloc] initWithRequestURL:url httpMethod:httpMethod]);
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { %@ }", [super description], self.requestHeaders.requestURL];
//    [desc appendString:[self.requestHeaders description]];
//    [desc appendString:[self.requestBody description]];
//    return desc;
}

- (void) openStreamWithURL:(NSURL*) url {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FLNetworkActivityStartedNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:FLNetworkActivitySenderKey]];
    });
    
    [self willOpen];
    [self.listeners notify:@selector(httpRequestWillOpen:) withObject:self];

    if(!self.inputSink) {
        self.inputSink = [FLDataSink dataSink];
    }
    
    if(![FLReachableNetwork instance].isReachable) {
        [self finishRequestWithResult:[NSError errorWithDomain:FLNetworkErrorDomain code:FLNetworkErrorCodeNoRouteToHost localizedDescription:NSLocalizedString(@"Network appears to be offline", nil) ]];
        return;
    }
    
    NSURL* finalURL = url;

#if FORCE_NO_SSL
    if(FLStringsAreEqual(url.scheme, @"https")) {
        NSString* secureURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"https:" withString:@"http:"];
        finalURL = [NSURL URLWithString:secureURL];
    }
    _streamSecurity = FLNetworkStreamSecurityNone;

#else
    if(_streamSecurity == FLNetworkStreamSecuritySSL) {
        
        if(FLStringsAreNotEqual(url.scheme, @"https")) {
            NSString* secureURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
            finalURL = [NSURL URLWithString:secureURL];
        }
    }
    else if(FLStringsAreEqual(url.scheme, @"https")) {
        _streamSecurity = FLNetworkStreamSecuritySSL;
    }
#endif
    
    FLHttpMessage* cfRequest = [FLHttpMessage httpMessageWithURL:finalURL 
                                                      httpMethod:self.requestHeaders.httpMethod];

    cfRequest.headers = self.requestHeaders.allHeaders;
    
    if(self.requestBody.bodyData) {
        cfRequest.bodyData = self.requestBody.bodyData;
    }
    
    self.httpStream  = [FLHttpStream httpStream:cfRequest 
                                 withBodyStream:self.requestBody.bodyStream 
                                 streamSecurity:_streamSecurity
                                      inputSink:self.inputSink];
    
    [self.httpStream openStreamWithDelegate:self];
}

- (void) openAuthenticatedStreamWithURL:(NSURL*) url {

//    id context = self.context;
//    if(!self.httpRequestAuthenticator && (context && [context respondsToSelector:@selector(httpRequestAuthenticator)])) {
//        self.httpRequestAuthenticator = [context httpRequestAuthenticator];
//    }

    if(self.httpRequestAuthenticator && !self.disableAuthenticator) {
        [self willAuthenticate];
        [self.listeners notify:@selector(httpRequestWillAuthenticate:) withObject:self];

        [self.httpRequestAuthenticator authenticateHttpRequest:self];

        [self didAuthenticate];
        [self.listeners notify:@selector(httpRequestDidAuthenticate:) withObject:self];
    }

    [self openStreamWithURL:url];
}


- (void) startOperation {
    self.byteCount = [FLHttpRequestByteCount httpRequestByteCount];
    [self openAuthenticatedStreamWithURL:self.requestHeaders.requestURL];
}

- (void) networkStreamDidOpen:(FLHttpStream*) networkStream {
    [self.listeners notify:@selector(httpRequestDidOpen:) withObject:self];
    [self.byteCount setStartTime];
}

- (void) networkStream:(FLHttpStream*) stream
          didReadBytes:(NSNumber*) amountRead {

    [self.byteCount incrementByteCount:amountRead];
    [self didReadBytes:amountRead];

    [self.listeners notify:@selector(httpRequest:didReadBytes:) withObject:self withObject:self.byteCount];
}

- (void) finishRequestWithResult:(FLPromisedResult) result {
    [self.byteCount setFinishTime];    
    
    [self releaseResponseData];
                
    [self setFinishedWithResult:result];
    [self.listeners notify:@selector(httpRequest:didCloseWithResult:) withObject:self withObject:result];
    
    [self.retryHandler resetRetryCount];

// TODO: move this?
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FLNetworkActivityStoppedNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:FLNetworkActivitySenderKey]];
    });
}

- (void) requestCancel {
    [super requestCancel];
    [self.httpStream terminateStream];
    [self finishRequestWithResult:[NSError cancelError]];
}

- (BOOL) tryRetry {
    return [self.retryHandler retryWithBlock:^{
        [self releaseResponseData];
        [self startOperation];
    }];
}

- (void) networkStream:(FLHttpStream*) readStream 
      encounteredError:(NSError*) error {
    [self.httpStream terminateStream];
    
    if( [error isCancelError] || self.wasCancelled || ![self tryRetry]) {       
        [self finishRequestWithResult:error];
    }
    
}

- (void) networkStreamDidClose:(FLHttpStream*) stream {

}

- (NSTimeInterval) networkStreamGetTimeoutInterval:(FLNetworkStream*) stream {
    return self.timeoutInterval;
}

- (void) httpStream:(FLHttpStream*) stream 
willCloseWithResponseHeaders:(FLHttpMessage*) responseHeaders 
       responseData:(id<FLInputSink>) responseData {
       
    FLHttpResponse* httpResponse = [FLHttpResponse httpResponse:[[self requestHeaders] requestURL]
                                                    headers:responseHeaders 
                                             redirectedFrom:self.previousResponse
                                                  inputSink:responseData];
    
    httpResponse.byteCount = self.byteCount;
    
    NSError* responseError = nil;
    @try {
        [self throwErrorIfResponseIsError:httpResponse];
        FLThrowIfError(httpResponse.error);
    }
    @catch(NSException* ex) {
        responseError = FLRetainWithAutorelease(ex.error);
    }
    
    if(responseData.isOpen) {
        [responseData closeSinkWithCommit:responseError == nil];
    }
    
    if(responseError) {
        [self finishRequestWithResult:responseError];
    }
    else {

        // FIXME: there was an issue here with progress getting fouled up on redirects.
        //    [self connectionGotTimerEvent];

        BOOL redirect = httpResponse.wantsRedirect;
        if(redirect) {
            NSURL* redirectURL = httpResponse.redirectURL;
            redirect = [self shouldRedirectToURL:redirectURL];

            if(redirect) {
                self.previousResponse = httpResponse;
                [self openAuthenticatedStreamWithURL:redirectURL];
            }
        }

        if(!redirect) {
            id finalResult = nil;
            @try {
                finalResult = [self convertResponseToPromisedResult:httpResponse];
            }
            @catch(NSException* ex) {
                finalResult = ex.error;
            }

            if(!finalResult) {
                finalResult =  httpResponse;
            }
    
            [self finishRequestWithResult:finalResult];
        }
    }
}
@end

@implementation FLHttpRequest (OptionalOverrides)

- (void) willOpen {
}

- (void) willAuthenticate {
}

- (void) didAuthenticate {
}

- (void) didReadBytes:(NSNumber*) amount {
}

- (void) throwErrorIfResponseIsError:(FLHttpResponse*) httpResponse {
}

- (id) convertResponseToPromisedResult:(FLHttpResponse*) httpResponse {
    return httpResponse;
}

- (BOOL) shouldRedirectToURL:(NSURL*) url {
    return YES;
}
@end




//- (void) wasIdleForTimeInterval:(NSTimeInterval) timeInterval {

// TODO: ("MF: fix http implementation");

//    if([self.implementation respondsToSelector:@selector(httpConnection:sentBytes:totalSentBytes:totalBytesExpectedToSend:)])
//    {
//        unsigned long long bytesSent = _inputStream.bytesSent;
//        if(bytesSent > self.totalBytesSent)
//        {
//            self.lastBytesSent =  bytesSent - self.totalBytesSent;
//            self.totalBytesSent = bytesSent;
//
//#if TRACE
//            FLLog(@"bytes this time: %qu, total bytes sent: %qu, expected to send: %qu",  
//                self.lastBytesSent,
//                self.totalBytesSent, 
//                [[_requestQueue lastObject] postLength]);
//#endif
//            [self.implementation httpConnection:self 
//                sentBytes:self.lastBytesSent 
//                totalSentBytes:self.totalBytesSent 
//                totalBytesExpectedToSend:[[_requestQueue lastObject] postLength]];
//       }
//    }
// }




