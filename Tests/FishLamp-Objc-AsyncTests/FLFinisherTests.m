//
//  FLNotifierSanityCheck.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFinisherTests.h"
#import "FLTimeoutTests.h"
#import "FishLampAsync.h"

@interface FLPromise (Testing)
@property (readonly, strong) FLPromise* nextPromise;
@end

@implementation FLFinisherTests

+ (FLTestGroup*) testGroup {
    return [FLTestGroup frameworkTestGroup];
}

+ (void) specifyRunOrder:(FLTestableRunOrder*) runOrder {
    [runOrder runTestsForClass:self afterTestsForClass:[FLTimeoutTests class]];
}

- (void) testSingleCount {
    
    __block BOOL fired = NO;
    
    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) {
        fired = YES; 
    }];
    
    FLPromise* promise = [finisher addPromise];
    
    Assert(!promise.isFinished);
    Assert(fired == NO);
    [finisher setFinished];
    Assert(promise.isFinished);
    Assert(fired == YES);
}

- (void) willTestDoubleCount:(FLTestCase*) testCase {
    [testCase disable:@"problem with exception propagation"];
}

- (void) testDoubleCount:(FLTestCase*) testCase {

    __block BOOL fired = NO;
    
    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) { 
        fired = YES; 
    }];
    
    FLPromise* promise = [finisher addPromise];

    Assert(!promise.isFinished);
    Assert(fired);
    [finisher setFinished];
    Assert(promise.isFinished);

    BOOL gotError = NO;
    @try {
        [finisher setFinished];
        
    }
    @catch(NSException* expected) {
        gotError = YES;
    }
    
    AssertWithComment(gotError == YES, @"expecting an error");
}

- (void) testBasicAsyncTest {

    FLTestLog(@"async self test");
    
    FLFinisher* finisher = [FLFinisher finisher];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [NSThread sleepForTimeInterval:0.25];
        FLTestLog(@"done in thread");
        [finisher setFinished];
        });

    FLPromisedResult result = [finisher waitUntilFinished];
    AssertNotNil(result);
    Assert(finisher.isFinished);
}

- (void) testPromiseAdding {
    FLPromise* promise = [FLPromise promise];
    AssertNotNil(promise);
    AssertNil(promise.nextPromise);

    NSMutableArray* array = [NSMutableArray array];
    [array addObject:promise];

    for(int i = 0; i < 5; i++) {
        FLPromise* anotherPromise = [FLPromise promise];
        [array addObject:anotherPromise];

        [promise addPromise:anotherPromise];
    }

    FLPromise* walker = promise;
    FLAssert(walker == [array objectAtIndex:0]);

    int i = 0;
    while(walker) {
        Assert(walker == [array objectAtIndex:i++]);
        walker = walker.nextPromise;
    }
}


@end

