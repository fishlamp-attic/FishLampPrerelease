//
//  FLTestCaseList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@class FLTestCase;

@interface FLTestCaseList : NSObject<NSFastEnumeration> {
@private
    NSMutableArray* _testCases;
}

+ (id) testCaseList;

- (void) addTestCase:(FLTestCase*) testCase;

- (FLTestCase*) testCaseForName:(NSString*) name;
- (FLTestCase*) testCaseForSelector:(SEL) selector;

- (void) setRunOrder:(long) order forSelector:(SEL) selector;
- (void) setRunOrder:(long) order forTestCase:(FLTestCase*) testCase;

- (void) sort;

@end