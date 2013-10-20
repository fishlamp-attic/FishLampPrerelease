//
//  FLCoreFrameworkTest.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreFrameworkTest.h"

@implementation FLCoreFrameworkTest

+ (FLTestGroup*) testGroup {

    FLReturnStaticObject( [[FLTestGroup alloc] initWithGroupName:@"Core Framework Tests" priority:FLTestPriorityFramework]);

}

@end
