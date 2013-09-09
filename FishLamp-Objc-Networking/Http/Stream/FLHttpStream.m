//
//  FLHttpStream.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpStream.h"
#import "FLNetworkStream_Internal.h"

@interface FLHttpStream ()
@property (readonly, strong, nonatomic) FLHttpMessage* responseHeaders;
@property (readonly, strong, nonatomic) FLHttpMessage* requestHeaders;
@end

@implementation FLHttpStream
@synthesize responseHeaders = _responseHeaders;
@synthesize requestHeaders = _requestHeaders;

- (id) init {
    return [self initWithHttpMessage:nil withBodyStream:nil streamSecurity:FLNetworkStreamSecurityNone inputSink:nil];
}

//- (id) initWithHttpMessage:(FLHttpMessage*) request {
//    return [self initWithHttpMessage:request withBodyStream:nil streamSecurity:FLNetworkStreamSecurityNone];
//}

- (id) initWithHttpMessage:(FLHttpMessage*) request 
            withBodyStream:(NSInputStream*) bodyStream             
            streamSecurity:(FLNetworkStreamSecurity) security
                 inputSink:(id<FLInputSink>) inputSink {

    FLAssertNotNil(request);
    FLAssertNotNil(inputSink);

    self = [super initWithStreamSecurity:security inputSink:inputSink];
    if(self ) {
        _requestHeaders = FLRetain(request);
        _bodyStream = FLRetain(bodyStream);
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_requestHeaders release];
    [_bodyStream release];
    [_responseHeaders release];
    [super dealloc];
}
#endif

- (void) openStream {
    FLReleaseWithNil(_responseHeaders);
    [super openStream];
}

- (CFReadStreamRef) allocReadStreamRef {
    if(_bodyStream) {
        return CFReadStreamCreateForStreamedHTTPRequest(kCFAllocatorDefault, _requestHeaders.messageRef, FLBridge(CFReadStreamRef, _bodyStream));
    }
    
    return CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, _requestHeaders.messageRef);
}

+ (id) httpStream:(FLHttpMessage*) request 
   withBodyStream:(NSInputStream*) bodyStream
   streamSecurity:(FLNetworkStreamSecurity) security
   inputSink:(id<FLInputSink>) inputSink {
    
    return FLAutorelease([[[self class] alloc] initWithHttpMessage:request 
                                                    withBodyStream:bodyStream 
                                                    streamSecurity:security 
                                                         inputSink:inputSink]);
}            

- (BOOL) hasResponseHeaders {
    return _responseHeaders != nil;
}

- (FLHttpMessage*) readResponseHeaders {
    if(!_responseHeaders && self.streamRef) {
        CFHTTPMessageRef ref = (CFHTTPMessageRef)CFReadStreamCopyProperty(self.streamRef, kCFStreamPropertyHTTPResponseHeader);
        @try {
            if(ref && CFHTTPMessageIsHeaderComplete(ref)) {
                _responseHeaders = [[FLHttpMessage alloc] initWithHttpMessageRef:ref];
                [self didOpen];
            }
        }
        @finally {
            if(ref) {
                CFRelease(ref);
            }
        }
    }
    return _responseHeaders;
}

- (void) encounteredError:(NSError*) error {
    [self readResponseHeaders];
    [super encounteredError:error];
}

- (void) encounteredEnd {
    [self readResponseHeaders];
    [super encounteredEnd];
}

- (void) encounteredBytesAvailable {
    [self readResponseHeaders];
    [super encounteredBytesAvailable];
}

- (unsigned long) bytesWritten {
    if(self.streamRef) {
        NSNumber* number = FLAutorelease(FLBridgeTransfer(NSNumber*,
            CFReadStreamCopyProperty(self.streamRef, kCFStreamPropertyHTTPRequestBytesWrittenCount)));
        
        return number.unsignedLongValue;
    }
    return 0;
}

- (void) willCloseWithResponseData:(id<FLInputSink>) responseData {
    FLPerformSelector3(self.delegate, @selector(httpStream:willCloseWithResponseHeaders:responseData:), self, [self readResponseHeaders], responseData);
}

@end





