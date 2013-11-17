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
#import "FLStringFormatter.h"
#import "FLAsyncTest.h"

typedef void (^FLAsyncTestResultBlock)();

@protocol FLTestable;
@protocol FLTestCaseList;
@protocol FLTestResult;

#define FLTestCaseDefaultAsyncTimeout 2.0f

@protocol FLTestCase <NSObject>

@property (readonly, strong) NSString* testCaseName;
@property (readonly, strong) FLSelector* selector;
@property (readonly, assign) id target;

@property (readonly, assign) id<FLTestable> testable;
@property (readonly, strong) id<FLTestResult> result;

// disabling
@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
- (void) setDisabledWithReason:(NSString*) reason;

// async testing

@property (readwrite, assign) BOOL debugMode;

- (void) startAsyncTest;
- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout;

- (void) verifyAsyncResults:(dispatch_block_t) block;

- (void) finishAsyncTestWithBlock:(void (^)()) finishBlock;
- (void) finishAsyncTest;
- (void) finishAsyncTestWithError:(NSError*) error;

- (void) waitUntilAsyncTestIsFinished;

@end

