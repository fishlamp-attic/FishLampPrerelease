//
//  FLTTestResult.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

#import "FLTestResult.h"

@protocol FLStringFormatter;

//@protocol FLTTestResult <NSObject>
//
//@optional
//- (NSString*) runSummary;
//- (NSString*) failureDescription;
//
//@end

@interface FLTTestResult : NSObject<FLTestResult> {
@private 
    NSError* _error;
    NSException* _exception;
    NSString* _testName;
    NSMutableArray* _logEntries;
    BOOL _passed;
    BOOL _started;
    BOOL _finished;
}

- (id) initWithTestName:(NSString*) name;
+ (id) testResult:(NSString*) name;

@end

@interface FLTCountedTestResult : FLTTestResult<FLCountedTestResult> {
@private
    NSUInteger _expectedCount;
    NSUInteger _count;
}

- (id) initWithTestName:(NSString*) testName expectedCount:(NSUInteger) count;
+ (id) countedTestResult:(NSString*) testName expectedCount:(NSUInteger) count;

- (void) increment;

@end

