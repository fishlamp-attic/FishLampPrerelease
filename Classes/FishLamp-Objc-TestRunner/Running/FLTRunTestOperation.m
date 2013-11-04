//
//	FLTestCase.m
//	WreckingBall
//
//	Created by Mike Fullerton on 9/12/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTRunTestOperation.h"
#import "FLObjcRuntime.h"
#import "FLAsyncQueue.h"
#import "FLTestable.h"

#import "FLTTestCase.h"
#import "FLTTestCaseList.h"
#import "FLTTestCaseResult.h"
#import "FLTTestResult.h"
#import "FLTTestFactory.h"
#import "FLTTest.h"
#import "FLTTestResultCollection.h"

#import "FLOperationContext.h"

@interface FLTRunTestOperation ()

@property (readwrite, strong, nonatomic) NSMutableArray* queue;

@end

@implementation FLTRunTestOperation

@synthesize queue =_queue;


- (id) initWithUnitTest:(FLTTest*) testable {
	self = [super init];
	if(self) {
        FLAssertNotNil(testable);
		_unitTest = FLRetain(testable);
	}
	return self;
}

+ (id) runTestOperation:(FLTTest*) testable {
   return FLAutorelease([[[self class] alloc] initWithUnitTest:testable]);
}

#if FL_MRC
- (void)dealloc {
    [_queue release];
	[_unitTest release];
	[super dealloc];
}
#endif

/*
- (FLPromisedResult) runSynchronously {

    FLTTestCaseList* testCases = _unitTest.testCaseList;

    NSArray* startList = FLCopyWithAutorelease(testCases.testCases);

    for(FLTTestCase* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase willPerformTest];
    }

    [_unitTest willRunTestCases:testCases];

    for(FLTTestCase* testCase in testCases) {
        [testCase performTest];
        [testCase didPerformTest];

        if(testCase.isDisabled) {
            NSString* reason = testCase.disabledReason;
            if(![reason length]) {
                reason = @"NO REASON";
            }
            FLTestLog(@"DISABLED: %@ (%@)", testCase.testCaseName, reason);
        }
        else if(testCase.result.passed) {
            FLTestLog(@"Passed: %@", testCase.testCaseName);
        }
        else {
            FLTestLog(@"FAILED: %@", testCase.testCaseName);

            [[FLTestLoggingManager instance] indentedBlock:^{
                [[FLTestLoggingManager instance] appendString:testCase.result.loggerOutput];
            }];
        }

    }

    [_unitTest didRunTestCases:testCases];

    for(FLTTestCase* testCase in testCases) {
       if(!testCase.result.passed) {
            return FLFailedResult;
       }
    }

    return FLSuccessfulResult;
}
*/

- (id) resultForTest {

    for(FLTTestCase* testCase in _unitTest.testCaseList) {
       if(!testCase.result.passed) {
            return FLFailedResult;
       }
    }

    return FLSuccessfulResult;

}

- (void) beginNextTest {

    if(_queue.count > 0) {
        FLTTestCase* testCase = [_queue objectAtIndex:0];
        [_queue removeObjectAtIndex:0];

        [self.context beginOperation:testCase completion:^(FLPromisedResult result) {

            if(testCase.isDisabled) {
                NSString* reason = testCase.disabledReason;
                if(![reason length]) {
                    reason = @"NO REASON";
                }
                FLTestLog(@"DISABLED: %@ (%@)", testCase.testCaseName, reason);
            }
            else if(testCase.result.passed) {
                FLTestLog(@"Passed: %@", testCase.testCaseName);
            }
            else {
                FLTestLog(@"FAILED: %@", testCase.testCaseName);

                [FLTestLogger() indentedBlock:^{
                    [FLTestLogger() appendString:testCase.result.loggerOutput];
                }];
            }

            [FLBackgroundQueue queueTarget:self action:@selector(beginNextTest)];
        }];

    }
    else {

        [_unitTest didRunTestCases:_unitTest.testCaseList];

        [self setFinishedWithResult:[self resultForTest]];
    }
}

- (void) startOperation {

    [_unitTest willRunTestCases:_unitTest.testCaseList];

    NSArray* startList = FLCopyWithAutorelease(_unitTest.testCaseList.testCaseArray);
    for(FLTTestCase* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase prepareTestCase];
    }

    // the list is now prepared and ordered.
    self.queue = FLMutableCopyWithAutorelease(_unitTest.testCaseList.testCaseArray);


    [FLBackgroundQueue queueTarget:self action:@selector(beginNextTest)];
}

@end


