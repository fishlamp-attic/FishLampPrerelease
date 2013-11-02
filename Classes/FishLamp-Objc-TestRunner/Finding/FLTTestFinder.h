//
//  FLTTestFinder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLObjcRuntime.h"

@protocol FLTTestFactory;
@class FLTTestMethod;

@interface FLTTestFinder : NSObject {
@private
}

- (id<FLTTestFactory>) findPossibleUnitTestClass:(FLRuntimeInfo) info;
- (FLTTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info;

@end
