//
//  FLTestCaseList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

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

- (id<FLTestCase>) orderFirst:(SEL) testCase;

- (id<FLTestCase>) orderLast:(SEL) testCase;

- (id<FLTestCase>) order:(SEL) testCase
                   after:(SEL) anotherTestCase;

- (id<FLTestCase>) order:(SEL) testCase
                  before:(SEL) anotherTestCase;

@end


