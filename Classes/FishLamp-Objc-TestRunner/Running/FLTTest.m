//
//  FLTTest.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTest.h"
#import "FLTTestCaseList.h"

@implementation FLTTest

@synthesize testableObject = _testableObject;
@synthesize testCaseList = _testCaseList;

- (id) initWithUnitTest:(id) testableObject testCases:(id<FLTestCaseList>) testCases {
	self = [super init];
	if(self) {
        FLAssertNotNil(testableObject);
        FLAssertNotNil(testCases);

		_testableObject = FLRetain(testableObject);
        _testCaseList = (FLTTestCaseList*) FLRetain(testCases);
    }
	return self;
}

+ (id) assembledUnitTest:(id) testableObject testCases:(FLTTestCaseList*) testCases {
   return FLAutorelease([[[self class] alloc] initWithUnitTest:testableObject testCases:testCases]);
}

#if FL_MRC
- (void)dealloc {
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




@end
