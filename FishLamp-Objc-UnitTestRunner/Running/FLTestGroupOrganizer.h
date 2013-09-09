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

@interface FLTestGroupOrganizer : NSObject {
@private
    FLTestGroup* _testGroup;
    NSMutableArray* _testList;
}

@property (readonly, strong, nonatomic) NSArray* testList;
@property (readonly, strong, nonatomic) FLTestGroup* testGroup;

+ (id) unitTestGroupOrganizer:(FLTestGroup*) group;

- (void) addUnitTestFactory:(id<FLTestFactory>) unitTestFactory;

@end
