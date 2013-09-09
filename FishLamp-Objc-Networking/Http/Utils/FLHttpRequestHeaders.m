//
//  FLHttpRequestHeaders.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpRequestHeaders.h"
#import "FLAppInfo.h"

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "FLAppInfo.h"


@interface FLHttpRequestHeaders ()
@property (readwrite, strong, nonatomic) NSDictionary* allHeaders;
@end

@implementation FLHttpRequestHeaders
@synthesize httpMethod = _httpMethod;
@synthesize allHeaders = _headers;
@synthesize requestURL = _requestURL;
@synthesize postLength = _postLength;
static NSString* s_defaultUserAgent = nil;

-(id) initWithHttpMethod:(NSString*) httpMethod {

    if((self = [super init])) {
        self.httpMethod = httpMethod;
        _headers = [[NSMutableDictionary alloc] init];
        
        if(FLStringIsEmpty(self.httpMethod)) {
            self.httpMethod = @"GET";
        }
        
        [self setUserAgentHeader:[FLHttpRequestHeaders defaultUserAgent]];
    }
    
    return self;
}

- (id) init {
    return [self initWithHttpMethod:@"GET"];
}

#if FL_MRC
- (void) dealloc {
    [_httpMethod release];
    [_headers release];
    [_requestURL release];
    [super dealloc];
}
#endif

- (NSString*) contentTypeHeader {
    return [self valueForHTTPHeaderField:@"Content-Type"];
}

-(void) setContentTypeHeader:(NSString*) contentType {
	FLAssertStringIsNotEmptyWithComment(contentType, nil);
    
	[self setValue:contentType forHTTPHeaderField:@"Content-Type"];
}

- (NSString*) HTTPVersion {
    return FLHttpRequestDefaultHTTPVersion;
}

- (void) setHttpMethod:(NSString *)httpMethod {
    FLSetObjectWithRetain(_httpMethod, httpMethod);
    
    if(self.isPostRequest) {
        [self setValue:[NSString stringWithFormat:@"%@ HTTP/%@", self.requestURL.path, [self HTTPVersion]] forHTTPHeaderField:@"POST"];
        [self setValue:[NSString stringWithFormat:@"%qu", self.postLength] forHTTPHeaderField:@"Content-Length"];
    }
    else {
        [self removeHTTPHeaderField:@"POST"];
        [self removeHTTPHeaderField:@"Content-Length"];
    }
}

- (NSString*) hostHeader {
    return [self valueForHTTPHeaderField:@"HOST"];
}

- (void) setHostHeader:(NSString*) host {
	[self setValue:host forHTTPHeaderField:@"HOST"];
}

- (unsigned long long) contentLengthHeader {
    NSString* length = [self valueForHTTPHeaderField:@"Content-Length"];
    return length ? length.longLongValue : 0;
}

-(void) setContentLengthHeader:(unsigned long long) length {
	[self setValue:[NSString stringWithFormat:@"%llu", length] forHTTPHeaderField:@"Content-Length"];
}

- (void) setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
	FLAssertStringIsNotEmptyWithComment(field, nil);
    FLAssertIsNotNilWithComment(value, nil);
    [_headers setObject:value forKey:field];
}

- (NSString *) valueForHTTPHeaderField:(NSString *) field {
    return [_headers objectForKey:field];
}

- (BOOL) hasHTTPHeaderField:(NSString*) header {
    FLAssertStringIsNotEmptyWithComment(header, nil);

	return [_headers objectForKey:header] != nil;
}

- (void) removeHTTPHeaderField:(NSString*) headerName {
    [_headers removeObjectForKey:headerName];
}

- (BOOL) isPostRequest {
	return FLStringsAreEqualCaseInsensitive(self.httpMethod, @"POST");
}

- (void) setPostRequest:(BOOL) isPost {
    if(isPost != self.isPostRequest) {
        self.httpMethod = isPost ? @"POST" : @"GET";
    }
}

- (NSString*) userAgentHeader {
    return [self valueForHTTPHeaderField:@"User-Agent"];
}

- (void) setUserAgentHeader:(NSString*) userAgent {
	[self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
}



#if OSX
// TODO: move this to an OSX lib
NSString* FLMachineModel()
{
    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);

    if (len)
    {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        NSString *model_ns = [NSString stringWithUTF8String:model];
        free(model);
        return model_ns;
    }

    return @"UnknownMac"; //incase model name can't be read
}

+ (void) initialize {
    
    if(![self defaultUserAgent]) {
        NSString* defaultUserAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@;)", 
            [FLAppInfo appName], 
            [FLAppInfo appVersion],
            [FLAppInfo bundleIdentifier],
            FLMachineModel(),
//                [UIDevice currentDevice].machineName,
//                [UIDevice currentDevice].systemName,
//                [UIDevice currentDevice].systemVersion];
            FLStringFromVersion(FLGetOSVersion())];
        

        [FLHttpRequestHeaders setDefaultUserAgent:defaultUserAgent];
//            [NSURLRequest setDefaultUserAgent:defaultUserAgent];
    
    }

}
#endif

+ (NSString*) defaultUserAgent {
    return s_defaultUserAgent;
}   

+ (void) setDefaultUserAgent:(NSString*) userAgent {
    FLSetObjectWithRetain(s_defaultUserAgent, userAgent);
}

- (id) copyWithZone:(NSZone *)zone {
    FLHttpRequestHeaders* headers = [[FLHttpRequestHeaders alloc] init];
    headers.allHeaders = FLAutorelease([self.allHeaders mutableCopy]);
    headers.requestURL = FLAutorelease([self.requestURL copy]); 
    headers.httpMethod = FLAutorelease([self.httpMethod copy]); 
    return headers;
}

//- (void) copyTo:(FLHttpRequest*) request {
//    request.httpMethod = FLAutorelease([self.httpMethod copy]);
//    request.allHTTPHeaderFields = FLAutorelease([self.allHTTPHeaderFields mutableCopy]);
//    request.requestURL = FLAutorelease([self.requestURL copy]);
//    request.postBodyFilePath = FLAutorelease([self.postBodyFilePath copy]);
//    request.HTTPBody = FLAutorelease([self.HTTPBody copy]);
//    request.postLength = self.postLength;
//    request.HTTPBodyStream = FLAutorelease([self.HTTPBodyStream copy]);
//}

- (NSString*) description {
    NSMutableString* desc = [NSMutableString stringWithFormat:@"%@\r\n", [super description]];
    [desc appendFormat:@"http method: \"%@\"\r\nurl: \"%@\"\r\n",  _httpMethod, [_requestURL description]];
    if(_headers && _headers.count) {
        [desc appendFormat:@"request headers:%@\r\n",  [_headers description]];
    }
    return desc;
}

@end
