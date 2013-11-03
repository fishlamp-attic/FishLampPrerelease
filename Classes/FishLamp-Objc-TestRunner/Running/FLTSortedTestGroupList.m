//
//  FLTSortedTestGroupList.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTSortedTestGroupList.h"
#import "FLTTestFactoryList.h"

@interface FLTSortedTestGroupList ()
@end

@implementation FLTSortedTestGroupList

@synthesize groupDictionary = _groupDictionary;

- (id) initWithGroupDictionary:(NSDictionary*) groups {
	self = [super initWithArray:[groups allValues]];
	if(self) {
        FLAssertNotNil(groups);
        _groupDictionary = FLRetain(groups);

        [self organize];
	}
	return self;
}

+ (id) sortedTestGroupList:(NSDictionary*) groups {
    return FLAutorelease([[[self class] alloc] initWithGroupDictionary:groups]);
}

#if FL_MRC
- (void)dealloc {
    [_groupDictionary release];
    [super dealloc];
}
#endif

- (Class) classFromObject:(id) object {
    return [object testGroup];
}

- (NSUInteger) testCount {

    if(_totalTestCount == 0) {
        for(FLTTestFactoryList* group in self) {
            _totalTestCount += group.count;
        }
    }

    return _totalTestCount;
}

- (NSArray*) allTests{

    NSMutableArray* runList = [NSMutableArray array];

    for(FLTTestFactoryList* group in self) {
        for(id<FLTTestFactory> factory in group) {
            [runList addObject:factory];
        }
    }

    return runList;
}

@end

