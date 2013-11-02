//
//  FLTTestableSubclassFinder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestFinder.h"

#define FLTestStaticMethodPrefix @"unitTest_"

@interface FLTTestableSubclassFinder : FLTTestFinder

+ (id) testableSubclassFinder;

@end
