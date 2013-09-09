//
//  FLTestCaseRunner.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseRunner.h"
#import "FLTestCase.h"
#import "FLTestLoggingManager.h"
#import "FLTestCaseResult.h"
#import "FLTestable.h"

#import "FLTrace.h"

@implementation FLTestCaseRunner

+ (id) testCaseRunner {
   return FLAutorelease([[[self class] alloc] init]);
}

- (FLTestCaseResult*) performTestCase:(FLTestCase*) testCase {

    FLAssertNotNil(testCase);

    FLTestCaseResult* result = [FLTestCaseResult testCaseResult:testCase];

    [[FLTestLoggingManager instance] pushLogger:result.loggerOutput];

    @try {
        [testCase performTest];
        [result setPassed];
    }
    @catch(NSException* ex) {
//        FLTrace(@"got test exception: %@", ex);

//                 [[results testResultForKey:testCase.testCaseName] setError:ex.error];
    }
    @finally {
    }

    [[FLTestLoggingManager instance] popLogger];

    if(result.passed) {
        if(testCase.isDisabled) {
            [FLTestOutput appendLineWithFormat:@"DISABLED: %@", testCase.testCaseName];
        }
        else {
            [FLTestOutput appendLineWithFormat:@"Passed: %@", testCase.testCaseName];
        }
    }
    else {
        [FLTestOutput appendLineWithFormat:@"FAILED: %@", testCase.testCaseName];;

        [[FLTestLoggingManager instance] indent:^{
            [FLTestOutput appendStringFormatter:result.loggerOutput];
        }];
    }

    return result;
}


@end
