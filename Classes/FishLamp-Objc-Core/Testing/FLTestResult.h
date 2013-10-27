//
//  FLTestResult.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

@protocol FLStringFormatter;

//@protocol FLTestResult <NSObject>
//
//@optional
//- (NSString*) runSummary;
//- (NSString*) failureDescription;
//
//@end

@interface FLTestResult : NSObject {
@private 
    NSError* _error;
    NSException* _exception;
    NSString* _testName;
    id<FLStringFormatter> _loggerOutput;
    BOOL _passed;
}

- (id) initWithTestName:(NSString*) name;
+ (id) testResult:(NSString*) name;

@property (readonly, strong) id<FLStringFormatter> loggerOutput;
@property (readonly, assign) BOOL passed;
@property (readonly, strong) NSString* testName;

// error data
@property (readonly, copy) NSException* exception;
@property (readonly, copy) NSError* error;

- (void) setPassed; // only passes if error is nil
- (void) setFailedWithError:(NSError*) error;
- (void) setFailedWithException:(NSException*) ex;

@end

@interface FLCountedTestResult : FLTestResult {
@private
    NSUInteger _expectedCount;
    NSUInteger _count;
}

@property (readonly, assign) NSUInteger expectedCount;
@property (readonly, assign) NSUInteger count;

- (id) initWithTestName:(NSString*) testName expectedCount:(NSUInteger) count;
+ (id) countedTestResult:(NSString*) testName expectedCount:(NSUInteger) count;

- (void) increment;

@end
