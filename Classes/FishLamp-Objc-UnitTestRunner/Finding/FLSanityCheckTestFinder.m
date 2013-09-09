//
//  FLSanityCheckRunner.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSanityCheckTestFinder.h"

#import "FLFinisher.h"
#import "FLAsyncQueue.h"
#import "FLTestCase.h"
//#import "FishLampAsync.h"
//#import "FLTestOperation.h"
//#import "FLTestCaseOperation.h"

#import "FLTestMethod.h"

@implementation FLSanityCheckTestFinder

+ (id) sanityCheckTestFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

/*
- (FLPromisedResult) performSynchronously {
    
    NSMutableArray* tests = FLAutorelease([[_sanityTests allObjects] mutableCopy]);
    
    [tests sortedArrayUsingSelector:@selector(compare:)];
    
    for(FLTestCase* test in tests) {
        FLThrowIfError([self runChildSynchronously:[FLTestCaseOperation testCaseOperation:test]]);
    }
    
    return [FLSuccessfulResult successfulResult];
}
*/

- (FLTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info {
    if([NSStringFromSelector(info.selector) hasPrefix:FLSanityCheckStaticTestMethodPrefix]) {
        if(info.isMetaClass) {
            return [FLTestMethod testMethod:info.class selector:info.selector];
        }
        else {
            NSLog(@"IGNORING: Sanity Tests [%@ %@] (should be declared at class scope (+), not object scope (-)",
                NSStringFromClass(info.class),
                NSStringFromSelector(info.selector));
        }
    }
    return nil;
}

- (FLTestFactory*) findPossibleUnitTestClass:(FLRuntimeInfo) info {

    return nil;
}

@end
