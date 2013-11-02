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

//- (NSArray*) sortedGroupListWithGroupDictionary:(NSDictionary*) groups {
//    FLAssertNotNil(groups);
//
//    NSMutableArray* masterList = FLMutableCopyWithAutorelease(groups.allValues);
//    NSArray* immutableList = FLCopyWithAutorelease(masterList);
//
//    for(FLTTestFactoryList* group in immutableList) {
//
//
//    }
//
//
////    return [[groups allValues] sortedArrayUsingComparator:
////        ^NSComparisonResult(FLTTestFactoryList* obj1, FLTTestFactoryList* obj2) {
////        if(obj1.testGroup.runOrder == obj2.testGroup.runOrder) {
////            return NSOrderedSame;
////        }
////    
////        return obj1.testGroup.runOrder  > obj2.testGroup.runOrder ? NSOrderedAscending : NSOrderedDescending;
////    }];
//
//    return nil;
//}

//- (FLTTestFactoryList*) groupAtIndex:(NSUInteger) aIndex {
//    return [self.groups objectAtIndex:aIndex];
//}

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

//    self.unitTestFactories = [self removeUnitTestBaseClasses:self.unitTestFactories];
//
//    self.unitTestFactories = [self sortFactoryList:self.unitTestFactories];
//
//    self.testGroups = [self sortClassesIntoGroups:self.unitTestFactories];
//
//    self.sortedGroupList = [self sortedGroupListWithGroupDictionary:self.testGroups];

    return runList;
}

@end

