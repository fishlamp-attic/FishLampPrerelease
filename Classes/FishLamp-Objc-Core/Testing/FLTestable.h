//
//  FLTestable.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

#import "FLTestCase.h"
#import "FLTestCaseList.h"
#import "FLTestableRunOrder.h"
#import "FLTestResultCollection.h"
#import "FLTestGroup.h"


/**
 *  A FLTestable is an object that represents a automoated test of some kind. Either a unit or functional test.
 *  Any method with "test" in it (no params) will be run.
 *  Tests with "first" and "test" will be run first
 *  Tests with "last" and "test" will be run last;
 *  All other tests are run in alphebetical order.
 */
@protocol FLTestable <NSObject>
@optional

/**
 *  Called before test is run.
 *  
 *  @param testCases List of test cases - order of execution can be modified
 *  @param expected  Expected results
 */
- (void) willRunTestCases:(id<FLTestCaseList>) testCases;

/**
 *  Called after test is rull
 *  
 *  @param testCases the test cases that were run
 *  @param expected  expected results
 *  @param actual    actual results
 */
- (void) didRunTestCases:(id<FLTestCaseList>) testCases;

/**
 *  Optionally set dependencies in run order at the class level for running FLTestable subclasses.
 *  This is called while the tests are getting setup by the Test Organizer.
 *  
 *  @param runOrder FLTestableRunOrder specifies dependencies.
 */
+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder;

/**
 *  Return class of testGroup.
 *  
 *  @return return Class of a FLTestGroup subclass or nil.
 */
+ (Class) testGroup;

/**
 *  Name of the testable class.
 *  
 *  @return return name. Default value is name of class.
 */
+ (NSString*) testName;

@end

/**
 *  FLTestable is a concrete implemenation of FLTestable. You can safely subclass this.
 */
@interface FLTestable : NSObject<FLTestable> {
@private
    id<FLTestCaseList> _testCases;
    id<FLExpectedTestResult> _expectedTestResult;
    id<FLTestResultCollection> _testResults;
}

/**
 *  Return a custom name for the unit test. By default this is the name of the class.
 */
@property (readonly, strong) id<FLTestCaseList> testCaseList;

- (id<FLTestCase>) testCaseForSelector:(SEL) selector;
- (id<FLTestCase>) testCaseForName:(NSString*) name;

@end

extern void FLTestableSetLogger(id<FLStringFormatter> logger);
extern id<FLStringFormatter> FLTestLogger();

/**
 *  Macro that all the tests should use for output.
 */
#define FLTestLog(__FORMAT__, ...) \
            [FLTestLogger() appendLineWithFormat:__FORMAT__, ##__VA_ARGS__]


#define FLGetTestCase() [self testCaseForSelector:_cmd]

#define FLDisableTest() \
            do { \
                [[self testCaseForSelector:_cmd] setDisabled:YES]; \
                return; \
            } while(0)

#define FLTestMode(YESNO) \
            [[self testCaseForSelector:_cmd] setDebugMode:YESNO]

#define FLConfirmPrerequisiteTestCasePassed(NAME) \
            do { \
                NSString* __name = @#NAME; \
                id<FLTestCase> testCase = [self testCaseForName:__name]; \
                FLConfirmNotNilWithComment(testCase, @"prerequisite test case not found: %@", __name); \
                FLConfirmWithComment([[testCase result] passed], @"prerequisite test case \"%@\" failed", testCase.testCaseName); \
            } while(0);
            