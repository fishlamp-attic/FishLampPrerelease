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
#import "FLTestCaseOperation.h"
#import "FLTestable.h"

#import "FLTestFactory.h"
#import "FLAssembledTest.h"

#import "FLTestCaseRunner.h"
#import "FLTestResultCollection.h"

@implementation FLTestOperation

- (id) initWithUnitTest:(FLAssembledTest*) unitTest {
	self = [super init];
	if(self) {
        FLAssertNotNil(unitTest);
		_unitTest = FLRetain(unitTest);
	}
	return self;
}

+ (id) unitTestOperation:(FLAssembledTest*) unitTest {
   return FLAutorelease([[[self class] alloc] initWithUnitTest:unitTest]);
}

#if FL_MRC
- (void)dealloc {
	[_unitTest release];
	[super dealloc];
}
#endif

- (FLPromisedResult) performSynchronously {

    FLExpectedTestResult* testCaseResults = [FLExpectedTestResult testResultCollection];

    FLTestCaseList* testCases = _unitTest.testCaseList;
    [_unitTest willRunTestCases:testCases withExpectedResult:testCaseResults];

    FLTestCaseRunner* runner = [FLTestCaseRunner testCaseRunner];
    [testCases sort];

    for(FLTestCase* testCase in testCases) {

        FLPromisedResult result = [runner performTestCase:testCase];

        FLTestCaseResult* testCaseResult = [FLTestCaseResult fromPromisedResult:result];

        [testCaseResults setTestResult:result forKey:testCase.testCaseName];
    }

    [_unitTest didRunTestCases:testCases withExpectedResult:testCaseResults withActualResult:testCaseResults];

    return testCaseResults;
}


@end


