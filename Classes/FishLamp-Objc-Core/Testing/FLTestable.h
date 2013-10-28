//
//  FLTestable.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@class FLTestCase;
@class FLTestGroup;
@class FLTestCaseList;
@class FLExpectedTestResult;
@class FLTestResultCollection;
@class FLTestableRunOrder;

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
- (void) willRunTestCases:(FLTestCaseList*) testCases;

/**
 *  Called after test is rull
 *  
 *  @param testCases the test cases that were run
 *  @param expected  expected results
 *  @param actual    actual results
 */
- (void) didRunTestCases:(FLTestCaseList*) testCases;

/**
 *  Optionally set dependencies in run order at the class level for running FLTestable subclasses.
 *  This is called while the tests are getting setup by the Test Organizer.
 *  
 *  @param runOrder FLTestableRunOrder specifies dependencies.
 */
+ (void) specifyRunOrder:(FLTestableRunOrder*) runOrder;

/**
 *  Optionally add this test to a test group.
 *  
 *  @return The test group.
 */
+ (FLTestGroup*) testGroup; // defaultTestGroup by default.

@end

@interface FLTestable : NSObject<FLTestable> {
@private
    FLTestCaseList* _testCases;
    FLExpectedTestResult* _expectedTestResult;
    FLTestResultCollection* _testResults;
}

/**
 *  Return a custom name for the unit test. By default this is the name of the class.
 */
@property (readonly, strong) NSString* unitTestName;

- (FLTestCase*) testCaseForSelector:(SEL) selector;

- (FLTestCase*) testCaseForName:(NSString*) name;

- (void) willBeginExecutingTestCases:(FLTestCaseList*) testCases;
- (void) didFinishExecutingTestCases;

@end
