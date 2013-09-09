//
//  FLAssertionFailedError.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAssertionFailedError.h"
#import "FLErrorException.h"
#import "FLAssertions.h"

@implementation FLAssertionFailedError

+ (id) assertionFailedError:(NSInteger) code 
                     reason:(NSString*) reason 
                    comment:(NSString*) comment
                 stackTrace:(FLStackTrace*) stackTrace{
 
    return [self errorWithDomain:FLAssertionFailureErrorDomain code:code localizedDescription:reason userInfo:nil comment:comment stackTrace:stackTrace];
}                    

- (NSException*) createContainingException {
    return [FLAssertionFailedException exceptionWithName:FLAssertionFailedExceptionName
                                                  reason:self.localizedDescription
                                                userInfo:nil
                                                   error:self];
}

@end

NSString* const FLAssertionFailedExceptionName = @"assert";

@implementation FLAssertionFailedException

@end
