//
//  FLTTestGroupFinder.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FishLampMinimum.h"

@class FLTTestFinder;

@interface FLTTestGroupFinder : NSObject {
@private
    NSMutableArray* _testFinders;
}

+ (id) testGroupFinder;

- (void) addTestFinder:(FLTTestFinder*) finder;

- (NSDictionary*) findTestGroups;

@end
