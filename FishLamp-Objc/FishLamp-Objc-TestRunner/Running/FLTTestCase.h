//
//  FLTTestCase.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//
#import "FishLampMinimum.h"

#import "FLTestCase.h"
#import "FLFinisher.h"
#import "FLOperation.h"

@class FLTimer;

@interface FLTTestCase : FLOperation<FLTestCase> {
@private
    NSString* _testCaseName;
    FLSelector* _selector;
    FLSelector* _willTestSelector;
    FLSelector* _didTestSelector;
    id<FLTestResult> _result;

    NSString* _disabledReason;

    __unsafe_unretained id _target;
    __unsafe_unretained id<FLTestable> _unitTest;
    __unsafe_unretained id<FLTestCaseList> _testCaseList;
    BOOL _disabled;
    BOOL _debugMode;

    FLIndentIntegrity* _indentIntegrity;

    NSTimeInterval _timeoutInterval;

    FLTimer* _timer;
}

// creation

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable;

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector;

+ (id) testCase:(NSString*) name
       testable:(id<FLTestable>) testable
         target:(id) target
       selector:(SEL) selector;

- (void) prepareTestCase;

@property (readwrite, assign) BOOL debugMode;

@end

#if DEPRECATED
@interface FLTestCase (TestHelpers)

+ (void) runTestWithExpectedFailure:(void (^)()) test
                       checkResults:(void (^)(NSException* ex, BOOL* pass)) checkResults;

+ (void) runTestWithExpectedFailure:(void (^)()) test;

@end
#endif