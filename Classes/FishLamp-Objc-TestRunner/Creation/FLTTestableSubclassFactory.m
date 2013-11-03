//
//  FLTestSubclassFactory.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestableSubclassFactory.h"
#import "FLTestable.h"
#import "FLObjcRuntime.h"
#import "FLTAssembledTest.h"

#import "FLTTestCase.h"
#import "FLTTestCaseList.h"

@interface FLTestable (Internal)
@property (readwrite, strong) FLTTestCaseList* testCaseList;
@end

@implementation FLTestable (TestCases)

- (id) initWithTestCaseCreation {
	self = [self init];
	if(self) {
		self.testCaseList = [self createTestCases];
	}
	return self;
}

- (void) sortTestCaseList:(NSMutableArray*) list {
    [list sortUsingComparator:^NSComparisonResult(id<FLTestCase> obj1, id<FLTestCase> obj2) {

        NSString* lhs = obj1.selector.selectorString;
        NSString* rhs = obj2.selector.selectorString;

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


- (FLTTestCaseList*) createTestCases {

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

        FLTTestCase* testCase = [FLTTestCase testCase:testName
                                           testable:self
                                             target:self
                                           selector:NSSelectorFromString(selectorName)];
        [testCaseList addObject:testCase];
   }

    [self sortTestCaseList:testCaseList];

    return [FLTTestCaseList testCaseListWithArrayOfTestCases:testCaseList];
}


@end

@implementation FLTTestableSubclassFactory

@synthesize testableClass = _testableClass;

- (id) initWithUnitTestClass:(Class) aClass {
	self = [super init];
	if(self) {
        FLConfirmNotNil(aClass);
		_testableClass = aClass;
	}
	return self;
}

+ (id) testableSubclassFactory:(Class) aClass {
    return FLAutorelease([[[self class] alloc] initWithUnitTestClass:aClass]);
}

- (id) createTestableObject {

    id<FLTestable> testable = FLAutorelease([[self.testableClass alloc] initWithTestCaseCreation]);

    FLConfirmNotNil(testable);
    FLConfirmWithComment([testable isKindOfClass:[FLTestable class]],
                            @"%@ is not a testable object",
                            NSStringFromClass([testable class]));

    return testable;
}

- (FLTAssembledTest*) createAssembledTest {
    FLTestable* testObject = [self createTestableObject];
    return [FLTAssembledTest assembledUnitTest:testObject testCases:testObject.testCaseList];
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ Group:%@, Class:%@",
                [super description],
                [self.testableClass testGroupName],
                NSStringFromClass(self.testableClass)];
}

@end
