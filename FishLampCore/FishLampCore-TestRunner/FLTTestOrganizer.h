//
//  FLTTestOrganizer.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLTSortedTestGroupList.h"

@class FLTestable;
@class FLTTestGroupFinder;

@interface FLTTestOrganizer : NSObject {
@private
    FLTSortedTestGroupList* _sortedGroupList;
}

@property (readonly, strong, nonatomic) FLTSortedTestGroupList* sortedGroupList;

+ (id) testOrganizer;

- (void) organizeTests;

@end
