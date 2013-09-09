//
//  FLTestableSubclassFinder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableSubclassFinder.h"
#import "FLTestable.h"
#import "FLTestableSubclassFactory.h"
#import "FLTestMethod.h"

@implementation FLTestableSubclassFinder

+ (id) unitTestSubclassFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info {
    NSString* methodName = NSStringFromSelector(info.selector);
    if([methodName hasPrefix:FLTestStaticMethodPrefix]) {
        if(info.isMetaClass) {
            return [FLTestMethod testMethod:info.class selector:info.selector];
        }
        else {
            NSLog(@"IGNORING: Test method [%@ %@] (should be declared at class scope (+), not object scope (-)",
                NSStringFromClass(info.class),
                NSStringFromSelector(info.selector));
        }
    }

    return nil;
}

- (FLTestFactory*) findPossibleUnitTestClass:(FLRuntimeInfo) info {
//class_conformsToProtocol
    if(!info.isMetaClass) {
//        if(FLRuntimeClassHasSubclass([FLTestable class], info.class)) {

        if( FLClassConformsToProtocol(info.class, @protocol(FLTestable))) {
            return [FLTestableSubclassFactory testableSubclassFactory:info.class];
        }
    }

    return nil;
}

@end
