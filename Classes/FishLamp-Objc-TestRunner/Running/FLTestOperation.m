//
//	FLTestCase.m
//	WreckingBall
//
//	Created by Mike Fullerton on 9/12/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestOperation.h"
#import "FLTestCase.h"
#import "FLObjcRuntime.h"
#import "FLTestCaseResult.h"
#import "FLObjcRuntime.h"
#import "FLTestResult.h"
#import "FLAsyncQueue.h"
#import "FLTestable.h"

#import "FLTestFactory.h"
#import "FLAssembledTest.h"

#import "FLTestResultCollection.h"

@implementation FLTestOperation

- (id) initWithUnitTest:(FLAssembledTest*) testable {
	self = [super init];
	if(self) {
        FLAssertNotNil(testable);
		_unitTest = FLRetain(testable);
	}
	return self;
}

+ (id) unitTestOperation:(FLAssembledTest*) testable {
   return FLAutorelease([[[self class] alloc] initWithUnitTest:testable]);
}

#if FL_MRC
- (void)dealloc {
	[_unitTest release];
	[super dealloc];
}
#endif

- (FLPromisedResult) performSynchronously {

    FLTestCaseList* testCases = _unitTest.testCaseList;

    NSArray* startList = FLCopyWithAutorelease(testCases.testCases);

    for(FLTestCase* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase willPerformTest];
    }

    [_unitTest willRunTestCases:testCases];

    for(FLTestCase* testCase in testCases) {
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

            [[FLTestLoggingManager instance] indent:^{
                [[FLTestLoggingManager instance] appendString:testCase.result.loggerOutput];
            }];
        }

    }

    [_unitTest didRunTestCases:testCases];

    for(FLTestCase* testCase in testCases) {
       if(!testCase.result.passed) {
            return FLFailedResult;
       }
    }

    return FLSuccessfulResult;
}

@end


