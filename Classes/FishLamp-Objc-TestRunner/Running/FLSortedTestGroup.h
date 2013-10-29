//
//  FLTestGroupRunner.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@class FLTestGroup;
@protocol FLTestFactory;

@interface FLSortedTestGroup : NSObject<NSFastEnumeration> {
@private
    FLTestGroup* _testGroup;
    NSMutableArray* _testFactories;
}

@property (readonly, assign, nonatomic) NSUInteger testCount;

@property (readonly, strong, nonatomic) FLTestGroup* testGroup;
@property (readonly, strong, nonatomic) NSArray* testFactories;

+ (id) sortedTestGroup:(FLTestGroup*) group;

- (void) addUnitTestFactory:(id<FLTestFactory>) unitTestFactory;
- (void) organizeTests;

@end
