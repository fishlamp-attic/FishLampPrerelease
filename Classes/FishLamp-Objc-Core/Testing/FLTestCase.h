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

@protocol FLTestable;
@protocol FLTestCaseList;
@protocol FLTestResult;

@protocol FLTestCase <NSObject>
// info
@property (readonly, assign) id<FLTestable> testable;

@property (readonly, strong) id<FLTestResult> result;

@property (readonly, strong) FLSelector* selector;
@property (readonly, strong) NSString* testCaseName;
@property (readonly, assign) id target;

// disabling
@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
- (void) disable:(NSString*) reason;

// configuring
@property (readwrite, assign, nonatomic) NSUInteger runOrder;
- (void) runSooner;
- (void) runLater;
- (void) runFirst;
- (void) runLast;
- (void) runBefore:(id<FLTestCase>) anotherTestCase;
- (void) runAfter:(id<FLTestCase>) anotherTestCase;

@end
