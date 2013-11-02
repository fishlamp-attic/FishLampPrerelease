//
//  FLTTestableSubclassFinder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestableSubclassFinder.h"
#import "FLTestable.h"
#import "FLTTestableSubclassFactory.h"
#import "FLTTestMethod.h"

@implementation FLTTestableSubclassFinder

+ (id) testableSubclassFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLTTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info {
    NSString* methodName = NSStringFromSelector(info.selector);
    if([methodName hasPrefix:FLTestStaticMethodPrefix]) {
        if(info.isMetaClass) {
            return [FLTTestMethod testMethod:info.class selector:info.selector];
        }
        else {
            NSLog(@"IGNORING: Test method [%@ %@] (should be declared at class scope (+), not object scope (-)",
                NSStringFromClass(info.class),
                NSStringFromSelector(info.selector));
        }
    }

    return nil;
}

- (id<FLTTestFactory>) findPossibleUnitTestClass:(FLRuntimeInfo) info {

    if(!info.isMetaClass) {
        if(FLRuntimeClassHasSubclass([FLTestable class], info.class) ||
            FLClassConformsToProtocol(info.class, @protocol(FLTestable))) {
            return [FLTTestableSubclassFactory testableSubclassFactory:info.class];
        }
    }

    return nil;
}

@end
