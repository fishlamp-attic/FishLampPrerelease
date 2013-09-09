//
//  FLTestFactory.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLAssembledTest;
@class FLTestGroup;

@protocol FLTestFactory <NSObject>

- (FLAssembledTest*) createAssembledTest;

- (Class) testableClass;
- (FLTestGroup*) testGroup;

@end

