//
//  FLTTestFactory.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTestable.h"

@class FLTTest;

@protocol FLTTestFactory <NSObject>

- (FLTTest*) createTest;

- (Class) testableClass;

@end

