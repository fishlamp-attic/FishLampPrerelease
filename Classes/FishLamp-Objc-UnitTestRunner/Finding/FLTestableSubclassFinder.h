//
//  FLTestableSubclassFinder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestFinder.h"

#define FLTestStaticMethodPrefix @"unitTest_"

@interface FLTestableSubclassFinder : FLTestFinder

+ (id) unitTestSubclassFinder;

@end
