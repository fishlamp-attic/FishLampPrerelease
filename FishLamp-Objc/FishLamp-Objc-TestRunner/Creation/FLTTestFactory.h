//
//  FLTTestFactory.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTestable.h"

@class FLTestableOperation;

@protocol FLTTestFactory <NSObject>

- (FLTestableOperation*) createTest;

- (Class) testableClass;

@end

