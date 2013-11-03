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

@protocol FLTTestClassFinder <NSObject>
- (id<FLTTestFactory>) findPossibleUnitTestClass:(FLRuntimeInfo) info;
@end

@protocol FLTTestMethodFinder <NSObject>
- (FLTTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info;
@end

@protocol FLTTestGroupClassFinder <NSObject>
- (Class) findPossibleTestGroup:(FLRuntimeInfo) info;
@end