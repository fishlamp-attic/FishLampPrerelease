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

@interface FLTestable (Internal)
@property (readwrite, strong) FLTestCaseList* testCaseList;
@end

@implementation FLTestable (TestCases)

- (id) initWithTestCaseCreation {
	self = [super init];
	if(self) {
		self.testCaseList = [self createTestCases];
	}
	return self;
}

- (void) sortTestCaseList:(NSMutableArray*) list {
    [list sortUsingComparator:^NSComparisonResult(FLTestCase* obj1, FLTestCase* obj2) {

        NSString* lhs = obj1.selector.name;
        NSString* rhs = obj2.selector.name;

        if( [lhs rangeOfString:@"firstTest" options:NSCaseInsensitiveSearch].length > 0 ||
            [rhs rangeOfString:@"lastTest" options:NSCaseInsensitiveSearch].length > 0) {
            return NSOrderedAscending;
        }
        else if ([rhs rangeOfString:@"firstTest" options:NSCaseInsensitiveSearch].length > 0 ||
                 [lhs rangeOfString:@"lastTest" options:NSCaseInsensitiveSearch].length > 0) {
            return NSOrderedDescending;
        }

        if(obj1.runOrder != obj2.runOrder) {
            return obj1.runOrder < obj2.runOrder ? NSOrderedAscending : NSOrderedDescending;
        }

        return [lhs compare:rhs];
    }];
}

- (FLTestCaseList*) createTestCases {

    NSMutableSet* set = [NSMutableSet set];

    FLRuntimeVisitEachSelectorInClassAndSuperclass([self class],
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


    NSMutableArray* testCaseList = [NSMutableArray array];

    NSString* myName = NSStringFromClass([self class]);
    
    for(NSString* selectorName in set) {

        NSString* testName = [NSString stringWithFormat:@"-[%@ %@]", myName, selectorName];

        FLTestCase* testCase = [FLTestCase testCase:testName
                                           testable:self
                                             target:self
                                           selector:NSSelectorFromString(selectorName)];
        [testCaseList addObject:testCase];
   }

    [self sortTestCaseList:testCaseList];

    return [FLTestCaseList testCaseListWithArrayOfTestCases:testCaseList];
}

@end

@implementation FLTestableSubclassFactory

@synthesize testableClass = _unitTestClass;

- (id) initWithUnitTestClass:(Class) aClass {
	self = [super init];
	if(self) {
        FLConfirmNotNil(aClass);
//        FLConfirmWithComment([aClass isKindOfClass:[FLTestable class]],
//                            @"%@ is not a testable object",
//                            NSStringFromClass([aClass class]));

		_unitTestClass = aClass;
	}
	return self;
}

+ (id) testableSubclassFactory:(Class) aClass {
    return FLAutorelease([[[self class] alloc] initWithUnitTestClass:aClass]);
}

- (id) createTestableObject {

//    FLConfirmWithComment([self.testableClass isKindOfClass:[FLTestable class]],
//                            @"%@ is not a testable object",
//                            NSStringFromClass([self.testableClass class]));

    FLTestable* testable = FLAutorelease([[self.testableClass alloc] initWithTestCaseCreation]);

    FLConfirmNotNil(testable);
    FLConfirmWithComment([testable isKindOfClass:[FLTestable class]],
                            @"%@ is not a testable object",
                            NSStringFromClass([testable class]));

    return testable;
}

- (FLAssembledTest*) createAssembledTest {
    FLTestable* testObject = [self createTestableObject];
    return [FLAssembledTest assembledUnitTest:testObject testCases:testObject.testCaseList];
}

- (FLTestGroup*) testGroup {
    if([self.testableClass respondsToSelector:@selector(testGroup)]) {
        return [self.testableClass testGroup];
    }
    return nil;
}

@end
