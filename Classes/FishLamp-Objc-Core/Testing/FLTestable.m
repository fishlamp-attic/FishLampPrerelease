//
//  FLTestable.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestable.h"
#import "FLAssertions.h"
#import "FLTestGroup.h"

@interface FLTestable ()
@property (readwrite, strong) FLTestCaseList* testCaseList;
@property (readwrite, strong) FLExpectedTestResult* expectedTestResult;
@property (readwrite, strong) FLTestResultCollection* testResults;
@end

@implementation FLTestable

@synthesize testCaseList = _testCaseList;
@synthesize expectedTestResult = _expectedTestResult;
@synthesize testResults = _testResults;

#if FL_MRC
- (void)dealloc {
	[_testCaseList release];
    [_expectedTestResult release];
    [_testResults release];

[super dealloc];
}
#endif

+ (NSInteger) unitTestPriority {
    return FLTestPriorityNormal;
}

- (NSString*) unitTestName {
    return NSStringFromClass([self class]);
}

+ (FLTestGroup*) testGroup {
    return [FLTestGroup defaultTestGroup];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { group=%@ }", [super description], [[[self class] testGroup] description]];
}

+ (NSArray*) testDependencies {
    return nil;
}

- (FLTestCase*) testCaseForSelector:(SEL) selector {
    return [self.testCaseList testCaseForSelector:selector];
}

- (FLTestCase*) testCaseForName:(NSString*) name {
    return [self.testCaseList testCaseForName:name];
}

- (void) willRunTestCases:(FLTestCaseList*) testCases {
}

- (void) didRunTestCases:(FLTestCaseList*) testCases {
}

- (void) willBeginExecutingTestCases:(FLTestCaseList*) testCases {
    self.testCaseList = testCases;
    [self willRunTestCases:self.testCaseList];
}

- (void) didFinishExecutingTestCases {
    [self didRunTestCases:self.testCaseList];
    self.testCaseList = nil;
}

@end
