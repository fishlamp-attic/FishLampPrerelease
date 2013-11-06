//
//  FLTestable.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestable.h"
#import "FLAssertions.h"

#import "FLTestCaseList.h"
#import "FLTestResultCollection.h"

@interface FLTestable ()
@property (readwrite, strong) id<FLTestCaseList> testCaseList;
@property (readwrite, strong) id<FLExpectedTestResult> expectedTestResult;
@property (readwrite, strong) id<FLTestResultCollection> testResults;
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

+ (NSString*) testName {
    return NSStringFromClass([self class]);
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { group=%@ }", [super description], [[self class] testGroupName]];
}

- (id<FLTestCase>) testCaseForSelector:(SEL) selector {
    return [self.testCaseList testCaseForSelector:selector];
}

- (id<FLTestCase>) testCaseForName:(NSString*) name {
    return [self.testCaseList testCaseForName:name];
}

- (void) willRunTestCases:(id<FLTestCaseList>) testCases {
}

- (void) didRunTestCases:(id<FLTestCaseList>) testCases {
}

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {
}

+ (Class) testGroupClass {
    return [FLTestGroup class];
}

+ (NSString*) testGroupName {
    return NSStringFromClass([self testGroupClass]);
}

@end

static id<FLStringFormatter> s_logger = nil;

void FLTestableSetLogger(id<FLStringFormatter> logger) {
    FLSetObjectWithRetain(s_logger, logger);
}

id<FLStringFormatter> FLTestLogger() {
    return s_logger;
}
