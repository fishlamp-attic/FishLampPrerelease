//
//  FLSanityCheckRunner.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTSanityCheckTestFinder.h"

#import "FLFinisher.h"
#import "FLAsyncQueue.h"
#import "FLTestCase.h"
//#import "FishLampAsync.h"
//#import "FLTRunAssembledTestOperation.h"

#import "FLTTestMethod.h"

@implementation FLTSanityCheckTestFindler

+ (id) sanityCheckTestFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLTTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info {
    if([NSStringFromSelector(info.selector) hasPrefix:FLSanityCheckStaticTestMethodPrefix]) {
        if(info.isMetaClass) {
            return [FLTTestMethod testMethod:info.class selector:info.selector];
        }
        else {
            NSLog(@"IGNORING: Sanity Tests [%@ %@] (should be declared at class scope (+), not object scope (-)",
                NSStringFromClass(info.class),
                NSStringFromSelector(info.selector));
        }
    }
    return nil;
}



@end
