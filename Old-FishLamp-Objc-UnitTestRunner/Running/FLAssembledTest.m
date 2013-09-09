//
//  FLAssembledTest.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAssembledTest.h"
#import "FLTestCaseList.h"

@implementation FLAssembledTest

@synthesize testableObject = _testableObject;
@synthesize testCaseList = _testCaseList;

- (id) initWithUnitTest:(id) testableObject testCases:(FLTestCaseList*) testCases {
	self = [super init];
	if(self) {
        FLAssertNotNil(testableObject);
        FLAssertNotNil(testCases);

		_testableObject = FLRetain(testableObject);
        _testCaseList = FLRetain(testCases);
    }
	return self;
}

+ (id) assembledUnitTest:(id) testableObject testCases:(FLTestCaseList*) testCases {
   return FLAutorelease([[[self class] alloc] initWithUnitTest:testableObject testCases:testCases]);
}

#if FL_MRC
- (void)dealloc {
	[_testableObject release];
	[_testCaseList release];
	[super dealloc];
}
#endif


- (void) willRunTestCases:(FLTestCaseList*) testCases
       withExpectedResult:(FLExpectedTestResult*) expected {

    if([_testableObject respondsToSelector:@selector(willRunTestCases:withExpectedResult:)]) {
        [_testableObject willRunTestCases:testCases withExpectedResult:expected];
    }

}

- (void) didRunTestCases:(FLTestCaseList*) testCases
      withExpectedResult:(FLExpectedTestResult*) expected
        withActualResult:(FLTestResultCollection*) actual {

    if([_testableObject respondsToSelector:@selector(didRunTestCases:withExpectedResult:withActualResult:)]) {
        [_testableObject didRunTestCases:testCases
                      withExpectedResult:expected
                        withActualResult:actual];
    }

}




@end
