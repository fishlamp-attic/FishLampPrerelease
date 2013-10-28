//
//  FLTesting.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

// tests
#import "FLTestable.h"

// test groupds
#import "FLTestGroup.h"

// test cases
#import "FLTestCase.h"
#import "FLTestCaseList.h"

// results
#import "FLTestResult.h"
#import "FLTestCaseResult.h"
#import "FLTestResultCollection.h"

// output
#import "FLTestLoggingManager.h"

// utils
#import "FLTestable+Utils.h"
#import "FLTestableRunOrder.h"

#import "FLTestAssertions.h"

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
                FLTestCase* testCase = [self testCaseForName:__name]; \
                FLTAssertNotNilWithComment(testCase, @"prerequisite test case not found: %@", __name); \
                FLTAssertWithComment([[testCase result] passed], @"prerequisite test case \"%@\" failed", testCase.testCaseName); \
            } while(0);
