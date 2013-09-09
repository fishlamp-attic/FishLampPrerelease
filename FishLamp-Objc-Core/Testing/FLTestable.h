//
//  FLTestable.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@class FLTestGroup;
@class FLTestCaseList;
@class FLExpectedTestResult;
@class FLTestResultCollection;

@protocol FLTestable <NSObject>
@optional

@property (readonly, strong) NSString* unitTestName;

+ (FLTestGroup*) testGroup; // defaultTestGroup by default.

// list of other testable classes (in same group)
+ (NSArray*) testDependencies;

// optional overrides

// NOTE: these are NOT tests. Thrown exceptions will terminate everything.
- (void) willRunTestCases:(FLTestCaseList*) testCases
       withExpectedResult:(FLExpectedTestResult*) expected;

- (void) didRunTestCases:(FLTestCaseList*) testCases
      withExpectedResult:(FLExpectedTestResult*) expected
        withActualResult:(FLTestResultCollection*) actual;

@end


@interface FLTestable : NSObject<FLTestable>

// any method with "test" in it (no params) will be run.

// tests with "first" and "test" will be run first

// tests with "last" and "test" will be run last;

// all other tests are run in alphebetical order.

@end

#ifndef TESTS
#define TESTS 1
#endif
