//
//  FLTestGroupRunner.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLTestableRunOrder.h"
#import "FLTOrderedRunList.h"

@protocol FLTTestFactory;

@interface FLTTestFactoryList : FLTOrderedRunList {
@private
    Class _testGroup;
}

@property (readonly, assign, nonatomic) Class testGroup;

@property (readonly, strong, nonatomic) NSString* groupName;

+ (id) testFactoryList:(Class) testGroup;

- (void) organizeTests;

@end
