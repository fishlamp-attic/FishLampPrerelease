//
//  FLTestable.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestable.h"
#import "FLAssertions.h"
#import "FLTestGroup.h"

@implementation FLTestable

- (id) init {
	self = [super init];
	if(self) {
	}
	return self;
}

+ (FLTestable*) unitTest {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (NSInteger) unitTestPriority {
    return FLTestPriorityNormal;
}

#if FL_MRC
- (void) dealloc {
    [super dealloc];
}
#endif

- (NSString*) unitTestName {
    return NSStringFromClass([self class]);
}

+ (FLTestGroup*) testGroup {
    return [FLTestGroup defaultTestGroup];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { group=%@ }", [super description], [[[self class] testGroup] description]];
}

- (void) willRunTestCases:(FLTestCaseList*) testCases
              withResults:(FLTestResultCollection*) results {
}

- (void) didRunTestCases:(FLTestCaseList*) testCases
             withResults:(FLTestResultCollection*) results {
}

+ (NSArray*) testDependencies {
    return nil;
}

@end
