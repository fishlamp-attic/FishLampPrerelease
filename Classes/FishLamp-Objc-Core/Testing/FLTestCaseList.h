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

@property (readonly, copy, nonatomic) NSArray* testCases;

+ (id) testCaseList;
+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCases;

- (void) addTestCase:(FLTestCase*) testCase;

- (FLTestCase*) testCaseForName:(NSString*) name;
- (FLTestCase*) testCaseForSelector:(SEL) selector;

- (void) setRunOrder:(NSUInteger) order forSelector:(SEL) selector;
- (void) setRunOrder:(NSUInteger) order forTestCase:(FLTestCase*) testCase;
- (NSUInteger) runOrderForTestCase:(FLTestCase*) testCase;

@end