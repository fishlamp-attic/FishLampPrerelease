//
//  FLTestSubclassFactory.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableSubclassFactory.h"
#import "FLTestable.h"
#import "FLObjcRuntime.h"
#import "FLAssembledTest.h"

@implementation FLTestableSubclassFactory

@synthesize testableClass = _unitTestClass;

- (id) initWithUnitTestClass:(Class) aClass {
	self = [super init];
	if(self) {
        FLAssertNotNil(aClass);
		_unitTestClass = aClass;
	}
	return self;
}

+ (id) testableSubclassFactory:(Class) aClass {
    return FLAutorelease([[[self class] alloc] initWithUnitTestClass:aClass]);
}

- (id) createTestableObject {
    FLTestable* unitTest = FLAutorelease([[self.testableClass alloc] init]);

    FLAssertNotNil(unitTest);
    FLAssertWithComment([unitTest conformsToProtocol:@protocol(FLTestable)],
                            @"%@ is not a testable object",
                            NSStringFromClass([unitTest class]));

    return unitTest;
}

- (FLTestCaseList*) createTestCaseListForUnitTest:(id) unitTest {

    FLAssertNotNil(unitTest);

    NSMutableSet* set = [NSMutableSet set];

    FLRuntimeVisitEachSelectorInClassAndSuperclass([unitTest class],
        ^(FLRuntimeInfo info, BOOL* stop) {
            if(!info.isMetaClass) {
                if(info.class == [FLTestable class]) {
                    *stop = YES;
                }
                else {

                    NSString* name = NSStringFromSelector(info.selector);

                    if(     [name hasPrefix:@"test"] ||
                            FLStringsAreEqual(name, @"firstTest") ||
                            FLStringsAreEqual(name, @"lastTest")) {

                        [set addObject:NSStringFromSelector(info.selector)];
                    };
                }
            }
        });

    FLTestCaseList* testCaseList = [FLTestCaseList testCaseList];

    NSString* myName = NSStringFromClass([unitTest class]);
    
    for(NSString* selectorName in set) {

        NSString* testName = [NSString stringWithFormat:@"-[%@ %@]", myName, selectorName];

        FLTestCase* testCase = [FLTestCase testCase:testName
                                           unitTest:unitTest
                                             target:unitTest
                                           selector:NSSelectorFromString(selectorName)];
        [testCaseList addTestCase:testCase];

//        if([selector argumentCount] != 0) {
//            [testCase setDisabledWithReason:[NSString stringWithFormat:@"expecting zero arguments but found %d.", [selector argumentCount]]];
//        }
    }

    return testCaseList;
}

- (FLAssembledTest*) createAssembledTest {
    id testObject = [self createTestableObject];
    FLTestCaseList* list = [self createTestCaseListForUnitTest:testObject];
    return [FLAssembledTest assembledUnitTest:testObject testCases:list];
}

- (FLTestGroup*) testGroup {
    if([self.testableClass respondsToSelector:@selector(testGroup)]) {
        return [self.testableClass testGroup];
    }
    return nil;
}


@end
