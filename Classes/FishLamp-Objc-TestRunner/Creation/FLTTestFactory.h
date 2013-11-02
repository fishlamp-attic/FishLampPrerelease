//
//  FLTTestFactory.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTestable.h"

@class FLTAssembledTest;

@protocol FLTTestFactory <NSObject>

- (FLTAssembledTest*) createAssembledTest;

- (Class) testableClass;

@end

