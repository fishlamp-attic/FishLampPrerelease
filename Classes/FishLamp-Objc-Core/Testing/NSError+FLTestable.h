//
//  NSError+FLTestable.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/27/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLCoreRequired.h"
#import "FLErrorException.h"
#import "FLStackTrace.h"

extern NSString* const FLTestFailedErrorDomain;

@interface NSError (FLTestable)
+ (id) testFailedError:(NSInteger) code
             condition:(NSString*) condition
               comment:(NSString*) comment
            stackTrace:(FLStackTrace*) stackTrace;

@end
