//
//  FLTestCase.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"
#import "FLSelector.h"

@class FLTestable;
@class FLTestCaseList;
@class FLTestResult;

#define FLTestCaseOrderDefault  NSIntegerMax

@interface FLTestCase : NSObject {
@private
    NSString* _testCaseName;
    FLSelector* _selector;
    FLSelector* _willTestSelector;
    FLSelector* _didTestSelector;
    FLTestResult* _result;

    NSString* _disabledReason;

    __unsafe_unretained id _target;
    __unsafe_unretained FLTestable* _unitTest;
    __unsafe_unretained FLTestCaseList* _testCaseList;
    BOOL _disabled;
    BOOL _debugMode;
}

// info
@property (readonly, strong) FLSelector* selector;
@property (readonly, assign) FLTestable* testable;
@property (readonly, strong) NSString* testCaseName;
@property (readonly, assign) id target;
@property (readonly, strong) FLTestResult* result;

// creation

- (id) initWithName:(NSString*) name
           testable:(FLTestable*) testable;

- (id) initWithName:(NSString*) name
           testable:(FLTestable*) testable
             target:(id) target
           selector:(SEL) selector;

+ (FLTestCase*) testCase:(NSString*) name
                testable:(FLTestable*) testable
                  target:(id) target
                selector:(SEL) selector;

// disabling
@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
- (void) disable:(NSString*) reason;

// performing
- (void) willPerformTest;
- (void) performTest;
- (void) didPerformTest;

// configuring
@property (readwrite, assign, nonatomic) NSUInteger runOrder;
- (void) runSooner;
- (void) runLater;
- (void) runFirst;
- (void) runLast;
- (void) runBefore:(FLTestCase*) anotherTestCase;
- (void) runAfter:(FLTestCase*) anotherTestCase;

@property (readwrite, assign) BOOL debugMode;

@end

#if DEPRECATED
@interface FLTestCase (TestHelpers)

+ (void) runTestWithExpectedFailure:(void (^)()) test
                       checkResults:(void (^)(NSException* ex, BOOL* pass)) checkResults;

+ (void) runTestWithExpectedFailure:(void (^)()) test;

@end
#endif