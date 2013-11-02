//
//  FLTestGroupRunner.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestFactoryList.h"
#import "FLTTestFactory.h"

@interface FLTTestFactoryList ()
//@property (readwrite, strong, nonatomic) NSArray* testFactories;
@end

@implementation FLTTestFactoryList

@synthesize groupName = _groupName;
@synthesize testGroup = _testGroup;

- (id) initWithGroup:(Class) group {
	self = [super init];
	if(self) {
        FLAssertNotNil(group);
        _testGroup = group;
		_groupName = FLRetain([group groupName]);
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_groupName release];
	[super dealloc];
}
#endif

+ (id) testFactoryList:(Class) group {
    return FLAutorelease([[[self class] alloc] initWithGroup:group]);
}

- (void) organizeTests {
    [self sortUsingComparator:^NSComparisonResult(id<FLTTestFactory> obj1, id<FLTTestFactory> obj2) {

        NSString* lhs = [obj1.testableClass testName];
        NSString* rhs = [obj2.testableClass testName];

        return [lhs compare:rhs];
    }];

    [self organize];
}


- (Class) classFromObject:(id) object {
    return [object testableClass];
}

@end
