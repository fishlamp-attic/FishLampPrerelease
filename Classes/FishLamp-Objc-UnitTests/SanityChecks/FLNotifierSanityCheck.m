//
//  FLNotifierSanityCheck.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNotifierSanityCheck.h"
#import "FLTimeoutTests.h"
#import "FishLampAsync.h"

@implementation FLNotifierSanityCheck

+ (FLTestGroup*) testGroup {
    return [FLTestGroup frameworkTestGroup];
}

+ (NSArray*) testDependencies {
    return [NSArray arrayWithObject:[FLTimeoutTests class]];
}

- (void) testSingleCount {
    
    __block BOOL fired = NO;
    
    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) {
        fired = YES; 
    }];
    
    FLPromise* promise = [finisher addPromise];
    
    FLAssert(!promise.isFinished);
    FLAssert(fired == NO);
    [finisher setFinished];
    FLAssert(promise.isFinished);
    FLAssert(fired == YES);
}

- (void) testDoubleCount__off {
    
    __block BOOL fired = NO;
    
    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) { 
        fired = YES; 
    }];
    
    FLPromise* promise = [finisher addPromise];

    FLAssert(!promise.isFinished);
    FLAssert(fired == NO);
    [finisher setFinished];
    FLAssert(promise.isFinished);

    BOOL gotError = NO;
    @try {
        [finisher setFinished];
        
    }
    @catch(NSException* expected) {
        gotError = YES;
    }
    
    FLAssertWithComment(gotError == YES, @"expecting an error");
}

- (void) testBasicAsyncTest {

    FLTestLog(@"async self test");
    
    FLFinisher* finisher = [FLFinisher finisher];
    FLPromise* promise = [finisher addPromise];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [NSThread sleepForTimeInterval:0.25];
        FLTestLog(@"done in thread");
        [finisher setFinished];
        });
    
    [promise waitUntilFinished];
    FLAssert(promise.isFinished);
}


@end

