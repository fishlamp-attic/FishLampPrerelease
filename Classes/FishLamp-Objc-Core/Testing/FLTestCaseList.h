//
//  FLTestCaseList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@class FLTestCase;

@protocol FLTestCaseList <NSObject>

@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;

@property (readonly, copy, nonatomic) NSArray* testCases;
@property (readonly, copy, nonatomic) NSArray* prerequisiteTestClasses;

- (id<FLTestCase>) testCaseForName:(NSString*) name;
- (id<FLTestCase>) testCaseForSelector:(SEL) selector;

- (void) setRunOrder:(NSUInteger) order forSelector:(SEL) selector;
- (void) setRunOrder:(NSUInteger) order forTestCase:(id<FLTestCase>) testCase;
- (NSUInteger) runOrderForTestCase:(id<FLTestCase>) testCase;

- (void) disableAllTests:(NSString*) reason;

- (void) addPrerequisiteTestClass:(Class) aClass;

@end