//
//  NSBundle+FLCurrentBundle.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSBundle+FLCurrentBundle.h"

@implementation NSBundle (FLCurrentBundle)

static NSMutableArray* s_bundleStack = nil;

+ (NSBundle*) currentBundle {
    return [s_bundleStack lastObject];
}

+ (void) pushCurrentBundle:(NSBundle*) bundle {
    if(!s_bundleStack) {
        s_bundleStack = [[NSMutableArray alloc] init];
    }
    [s_bundleStack addObject:bundle];
}

+ (void) popCurrentBundle {
    [s_bundleStack removeLastObject_fl];
}

@end
