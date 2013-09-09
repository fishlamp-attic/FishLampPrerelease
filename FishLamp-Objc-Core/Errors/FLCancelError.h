//
//  FLCancelError.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"
#import "FLErrorException.h"

extern NSString* const FLCancelExceptionName;

@interface FLCancelError : NSError
@end

@interface FLCancelException : FLErrorException
@end

@interface NSError (FLCancelling)
+ (NSError*) cancelError;
@property (readonly, nonatomic, assign) BOOL isCancelError;
@end
