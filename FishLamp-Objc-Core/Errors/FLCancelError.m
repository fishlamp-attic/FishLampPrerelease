//
//  FLCancelError.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCancelError.h"
#import "FLErrorException.h"
#import "FLStringUtils.h"
#import "FLErrorCodes.h"
#import "FLAssertions.h"

NSString* const FLCancelExceptionName = @"cancel";

@implementation FLCancelError
- (BOOL) isCancelError {
    return YES;
}

- (NSException*) createContainingException {
    return [FLCancelException exceptionWithName:FLAssertionFailedExceptionName
                                         reason:self.localizedDescription
                                       userInfo:nil
                                          error:self];
}


#if DEBUG
- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict {
    return [super initWithDomain:domain code:code userInfo:dict];
}
#endif

@end

@implementation NSError (FLCancelling)

+ (NSError*) cancelError {
    return [FLCancelError errorWithDomain:FLErrorDomain
                               code:FLErrorCodeCancel
               localizedDescription:NSLocalizedString(@"Cancelled", @"used in cancel error localized description")];

}

- (BOOL) isCancelError {
	return	FLStringsAreEqual(FLErrorDomain, self.domain) && self.code == FLErrorCodeCancel; 
}

@end

@implementation FLCancelException
@end