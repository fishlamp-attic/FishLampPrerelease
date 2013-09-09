//
//  FLTestOrganizer.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLTestFinder.h"

@class FLTestable;

@interface FLTestOrganizer : NSObject {
@private
    NSMutableArray* _unitTestFinders;
    NSArray* _unitTests;
    NSDictionary* _unitTestGroups;
    NSDictionary* _testMethods;
    NSArray* _sortedGroupList;
}

+ (id) unitTestOrganizer;

@property (readonly, strong, nonatomic) NSDictionary* unitTestGroups;
@property (readonly, strong, nonatomic) NSArray* sortedGroupList;
@property (readonly, strong, nonatomic) NSArray* unitTestFactories;

- (void) addUnitTestFinder:(FLTestFinder*) finder;

- (void) findAndOrganizeUnitTests;

@end
