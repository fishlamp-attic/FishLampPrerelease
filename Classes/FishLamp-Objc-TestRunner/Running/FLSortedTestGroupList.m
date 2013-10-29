//
//  FLSortedTestGroupList.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLSortedTestGroupList.h"
#import "FLSortedTestGroup.h"

@interface FLSortedTestGroupList ()
- (NSArray*) sortedGroupListWithGroupDictionary:(NSDictionary*) groups;
@end

@implementation FLSortedTestGroupList

@synthesize groups = _groups;
@synthesize groupDictionary = _groupDictionary;

- (id) initWithGroupDictionary:(NSDictionary*) groups {
	self = [super init];
	if(self) {
        FLAssertNotNil(groups);

        _groupDictionary = FLRetain(groups);
        _groups = FLRetain([self sortedGroupListWithGroupDictionary:_groupDictionary]);
	}
	return self;
}

+ (id) sortedTestGroupList:(NSDictionary*) groups {
    return FLAutorelease([[[self class] alloc] initWithGroupDictionary:groups]);
}

#if FL_MRC
- (void)dealloc {
	[_groups release];
    [_groupDictionary release];
    [super dealloc];
}
#endif

- (NSArray*) sortedGroupListWithGroupDictionary:(NSDictionary*) groups {
    FLAssertNotNil(groups);

    return [[groups allValues] sortedArrayUsingComparator:
        ^NSComparisonResult(FLSortedTestGroup* obj1, FLSortedTestGroup* obj2) {
        if(obj1.testGroup.groupPriority == obj2.testGroup.groupPriority) {
            return NSOrderedSame;
        }
    
        return obj1.testGroup.groupPriority  > obj2.testGroup.groupPriority ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (FLSortedTestGroup*) groupAtIndex:(NSUInteger) aIndex {
    return [self.groups objectAtIndex:aIndex];
}

- (NSUInteger) testCount {

    if(_totalTestCount == 0) {
        for(FLSortedTestGroup* group in self.groups) {
            _totalTestCount += group.testCount;
        }
    }

    return _totalTestCount;
}

- (NSUInteger) groupCount {
    return self.groups.count;
}

- (NSArray*) allTests{

    NSMutableArray* runList = [NSMutableArray array];

    for(FLSortedTestGroup* group in self.groups) {
        for(id<FLTestFactory> factory in [group testFactories]) {
            [runList addObject:factory];
        }
    }

//    self.unitTestFactories = [self removeUnitTestBaseClasses:self.unitTestFactories];
//
//    self.unitTestFactories = [self sortFactoryList:self.unitTestFactories];
//
//    self.testGroups = [self sortClassesIntoGroups:self.unitTestFactories];
//
//    self.sortedGroupList = [self sortedGroupListWithGroupDictionary:self.testGroups];

    return runList;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.groups countByEnumeratingWithState:state objects:buffer count:len];
}

@end
