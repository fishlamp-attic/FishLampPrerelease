//
//  FLTTestOrganizer.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestOrganizer.h"
#import "FLTTestFactoryList.h"
#import "FLTestableRunOrder.h"
#import "FLTTestFinder.h"
#import "FLTTestGroupFinder.h"
#import "FLTTestableSubclassFinder.h"

@interface FLTTestOrganizer ()
@property (readwrite, strong, nonatomic) FLTSortedTestGroupList* sortedGroupList;
@end

@implementation FLTTestOrganizer

@synthesize sortedGroupList = _sortedGroupList;

- (id) init {	
	self = [super init];
	if(self) {
    }
	return self;
}

+ (id) testOrganizer {
    return FLAutorelease([[[self class] alloc] init]);
}


#if FL_MRC
- (void)dealloc {
	[_sortedGroupList release];
	[super dealloc];
}
#endif

- (void) organizeTests {
    FLTTestGroupFinder* testRegistry = [FLTTestGroupFinder testGroupFinder];
    [testRegistry addTestFinder:[FLTTestableSubclassFinder testableSubclassFinder]];
    NSDictionary* groups = [testRegistry findTestGroups];

    self.sortedGroupList = [FLTSortedTestGroupList sortedTestGroupList:groups];
}

@end
