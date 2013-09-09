//
//  FLTestCaseOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseOperation.h"
#import "FLTestCaseResult.h"
#import "FLTestable.h"
#import "FLTestCaseRunner.h"

//#import "FLTestable.h"
//#import "FLObjcRuntime.h"


@implementation FLTestCaseOperation

@synthesize testCase = _testCase;

- (id) init {	
	return [self initWithTestCase:nil];
}

- (id) initWithTestCase:(FLTestCase*) testCase {
	self = [super init];
	if(self) {
        FLAssertNotNil(testCase);
		_testCase = FLRetain(testCase);
	}
	return self;
}

+ (id) testCaseOperation:(FLTestCase*) testCase {
   return FLAutorelease([[[self class] alloc] initWithTestCase:testCase]);
}

#if FL_MRC
- (void)dealloc {
	[_testCase release];
	[super dealloc];
}
#endif

- (FLPromisedResult) performSynchronously {
    return [[FLTestCaseRunner testCaseRunner] performTestCase:self.testCase];
}


@end
