//
//  FLTestCaseList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@class FLTestCase;
@protocol FLTestCase;

@interface FLTestCaseList : NSObject<NSFastEnumeration> {
@private
    NSMutableArray* _testCaseArray;
    BOOL _isDisabled;
    NSString* _disabledReason;
}

@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
@property (readonly, strong, nonatomic) NSArray* testCaseArray;

+ (id) testCaseList;

+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCaseArray;

- (void) addTestCase:(id<FLTestCase>) testCase;

- (id<FLTestCase>) testCaseForName:(NSString*) name;

- (id<FLTestCase>) testCaseForSelector:(SEL) selector;

- (void) disableAllTests:(NSString*) reason;

- (id<FLTestCase>) orderFirst:(id) testCase;

- (id<FLTestCase>) orderLast:(id) testCase;

- (id<FLTestCase>) order:(id) testCase
                   after:(id) anotherTestCase;

- (id<FLTestCase>) order:(id) testCase
                  before:(id) anotherTestCase;

@end


