//
//  FLTestable.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"
#import "FLTestGroup.h"
#import "FLTestCaseList.h"
#import "FLTestResultCollection.h"

@protocol FLTestable <NSObject>

@optional

// any method with "test" in it (no params) will be run.

// tests with "first" and "test" will be run first

// tests with "last" and "test" will be run last;

// all other tests are run in alphebetical order.

/**
 *  Return a custom name for the unit test. By default this is the name of the class.
 */
@property (readonly, strong) NSString* unitTestName;

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
 *  Optionally return Array of Classes that this test depends on
 *  
 *  @return Array of Classes
 */
+ (NSArray*) testDependencies;

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

- (FLTestCase*) testCaseForSelector:(SEL) selector;

- (FLTestCase*) testCaseForName:(NSString*) name;


@end

#ifndef TESTS
#define TESTS 1
#endif

#import "FishLampTesting.h"

#define FLGetTestCase() [self testCaseForSelector:_cmd]

#define FLDisableTest() \
            do { \
                [[self testCaseForSelector:_cmd] setDisabled:YES]; \
                return; \
            } while(0)

