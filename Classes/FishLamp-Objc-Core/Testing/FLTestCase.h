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

@property (readonly, strong) NSString* testCaseName;
@property (readonly, strong) FLSelector* selector;
@property (readonly, assign) id target;

@property (readonly, assign) id<FLTestable> testable;
@property (readonly, strong) id<FLTestResult> result;


// disabling
@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
- (void) disable:(NSString*) reason;

@end
