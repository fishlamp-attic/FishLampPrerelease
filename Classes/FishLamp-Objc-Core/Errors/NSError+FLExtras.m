//
//	NSError.m
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLExtras.h"
#import "FLStringUtils.h"
#import "FLExceptions.h"
#import "FLErrorException.h"
#import "FLStackTrace.h"


NSString* const FLErrorCommentKey = @"com.fishlamp.error.comment";;
//NSString* const FLErrorDomainKey = @"com.fishlamp.error.domain";

NSString* const FLStackTraceKey = @"stacktrace";


@implementation NSError (FLExtras)

FLSynthesizeDictionaryGetterProperty(underlyingError, NSError*, NSUnderlyingErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(stringEncoding, NSArray*, NSStringEncodingErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(URL, NSURL*, NSURLErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(filePath, NSString*, NSFilePathErrorKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(comment, NSString*, FLErrorCommentKey, self.userInfo)
FLSynthesizeDictionaryGetterProperty(stackTrace, FLStackTrace*, FLStackTraceKey, self.userInfo);

+ (NSError*) errorWithDomain:(id) domain
                        code:(NSInteger) code
        localizedDescription:(NSString*) localizedDescription {

    return FLAutorelease([[[self class] alloc] initWithDomain:domain 
                                                         code:code
                                         localizedDescription:localizedDescription
                                                     userInfo:nil
                                                      comment:nil
                                                   stackTrace:nil]);
}

- (BOOL) isErrorCode:(NSInteger) code domain:(NSString*) domain {
	return code == self.code && FLStringsAreEqual(domain, self.domain);
}

- (BOOL) isErrorDomain:(NSString*) domain {
	return FLStringsAreEqual(domain, self.domain);
}

- (id) initWithDomain:(NSString*) domain
                 code:(NSInteger) code
 localizedDescription:(NSString*) localizedDescription
             userInfo:(NSDictionary *) userInfo
              comment:(NSString*) comment
           stackTrace:(FLStackTrace*) stackTrace {


#if 0
    NSString* errorCodeString = nil; // [[FLErrorDomainInfo instance] stringFromErrorCode:code withDomain:domain];
    NSString* commentAddOn = nil;
    if(errorCodeString) {
        commentAddOn = [NSString stringWithFormat:@"[%@:%ld (%@)]", domain, (long) code, errorCodeString];
    }
    else {
        commentAddOn = [NSString stringWithFormat:@"[%@:%ld]", domain, (long)code];
    }

    if(comment) {
        localizedDescription = [NSString stringWithFormat:@"%@ (%@) %@", localizedDescription, comment, commentAddOn];
    }
    else {
        localizedDescription = [NSString stringWithFormat:@"%@ %@", localizedDescription, commentAddOn];
    }
    

    if(comment) {
        comment = [NSString stringWithFormat:@"%@ %@", comment, commentAddOn];
    }
    else {
        comment = commentAddOn;
    }
#endif    


//    if(comment) {
//        localizedDescription = [NSString stringWithFormat:@"%@ (%@)", localizedDescription, comment];
//    }

    NSMutableDictionary* newUserInfo = userInfo != nil ?
                                            FLMutableCopyWithAutorelease(userInfo) :
                                            [NSMutableDictionary dictionaryWithCapacity:5];

//        [userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];

    if(FLStringIsNotEmpty(comment)) {
        [newUserInfo setObject:comment forKey:FLErrorCommentKey];
    }
    if(FLStringIsNotEmpty(localizedDescription)) {
        [newUserInfo setObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    }
    if(stackTrace) {
        [newUserInfo setObject:stackTrace forKey:FLStackTraceKey];
    }

    return [self initWithDomain:domain code:code userInfo:newUserInfo];
}

+ (NSError*) errorWithDomain:(id) domain
                        code:(NSInteger)code
        localizedDescription:localizedDescription
                    userInfo:(NSDictionary *)dict
                     comment:(NSString*) commentOrNil
                  stackTrace:(FLStackTrace*) stackTrace {

    return FLAutorelease([[[self class] alloc] initWithDomain:domain
                                                        code:code
                                         localizedDescription:localizedDescription
                                                    userInfo:dict
                                                     comment:commentOrNil
                                                     stackTrace:stackTrace]);
}

+ (NSError*) errorWithError:(NSError*) error stackTrace:(FLStackTrace*) stackTrace {

    NSDictionary* userInfo = error.userInfo;
    if(stackTrace) {
        if(userInfo) {
            NSMutableDictionary* newUserInfo = FLMutableCopyWithAutorelease(userInfo);
            [newUserInfo setObject:stackTrace forKey:FLStackTraceKey];
            userInfo = newUserInfo;
        }
        else {
            userInfo = [NSDictionary dictionaryWithObject:stackTrace forKey:FLStackTraceKey];
        }

        return FLAutorelease([[[error class] alloc] initWithDomain:error.domain code:error.code userInfo:userInfo]);
    }

    return FLRetainWithAutorelease(error);
}

- (NSException*) createContainingException {
    return [FLErrorException exceptionWithName:FLErrorExceptionName
                                        reason:self.localizedDescription
                                      userInfo:nil
                                         error:self];
}

- (BOOL) isError {
    return YES;
}
@end


