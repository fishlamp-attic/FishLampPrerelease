//
//  FLTestGroupRunner.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestGroupOrganizer.h"

@implementation FLTestGroupOrganizer

@synthesize testList = _testList;
@synthesize testGroup = _testGroup;

- (id) initWithGroup:(FLTestGroup*) group {
	self = [super init];
	if(self) {
        FLAssertNotNil(group);
		_testGroup = FLRetain(group);
        _testList = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_testGroup release];
    [_testList release];
	[super dealloc];
}
#endif

+ (id) unitTestGroupOrganizer:(FLTestGroup*) group {
    return FLAutorelease([[[self class] alloc] initWithGroup:group]);
}

- (void) addUnitTestFactory:(id<FLTestFactory>) unitTestFactory {
    [_testList addObject:unitTestFactory];
}

@end
