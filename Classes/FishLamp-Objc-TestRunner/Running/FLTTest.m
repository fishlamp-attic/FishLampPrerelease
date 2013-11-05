//
//  FLTTest.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTest.h"
#import "FLTTestCaseList.h"
#import "FLDispatchQueue.h"
#import "FLOperationContext.h"

@interface FLTTest ()
@property (readwrite, strong, nonatomic) NSMutableArray* queue;
@end

@implementation FLTTest

@synthesize testableObject = _testableObject;
@synthesize testCaseList = _testCaseList;
@synthesize queue =_queue;

- (id) initWithTestable:(id<FLTestable>) testableObject testCases:(id<FLTestCaseList>) testCases {
	self = [super init];
	if(self) {
        FLAssertNotNil(testableObject);
        FLAssertNotNil(testCases);

		_testableObject = FLRetain(testableObject);
        _testCaseList = (FLTTestCaseList*) FLRetain(testCases);
    }
	return self;
}

+ (id) testWithTestable:(id<FLTestable>) testableObject testCases:(FLTTestCaseList*) testCases {
   return FLAutorelease([[[self class] alloc] initWithTestable:testableObject testCases:testCases]);
}

#if FL_MRC
- (void)dealloc {
    [_queue release];
	[_testableObject release];
	[_testCaseList release];
	[super dealloc];
}
#endif

- (NSString*) testName {
    return [_testableObject testName];
}

- (void) willRunTestCases:(id<FLTestCaseList>) testCases {

    if([_testableObject respondsToSelector:@selector(willRunTestCases:)]) {
        [_testableObject willRunTestCases:testCases];
    }

}

- (void) didRunTestCases:(id<FLTestCaseList>) testCases {

    if([_testableObject respondsToSelector:@selector(didRunTestCases:)]) {
        [_testableObject didRunTestCases:testCases];
    }
}


- (id) resultForTest {

    for(FLTTestCase* testCase in self.testCaseList) {
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

        [self.context queueOperation:testCase completion:^(FLPromisedResult result) {

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

        [self didRunTestCases:self.testCaseList];

        [self setFinishedWithResult:[self resultForTest]];
    }
}

- (void) startOperation {

    [self willRunTestCases:self.testCaseList];

    NSArray* startList = FLCopyWithAutorelease(self.testCaseList.testCaseArray);
    for(FLTTestCase* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase prepareTestCase];
    }

    // the list is now prepared and ordered.
    self.queue = FLMutableCopyWithAutorelease(self.testCaseList.testCaseArray);

    [FLBackgroundQueue queueTarget:self action:@selector(beginNextTest)];
}

@end
