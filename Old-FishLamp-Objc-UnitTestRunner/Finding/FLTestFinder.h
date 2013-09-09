//
//  FLTestFinder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLObjcRuntime.h"

@class FLTestFactory;
@class FLTestMethod;

@interface FLTestFinder : NSObject {
@private
}

- (FLTestFactory*) findPossibleUnitTestClass:(FLRuntimeInfo) info;
- (FLTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info;

@end
