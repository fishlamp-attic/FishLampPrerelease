//
//  FLAsyncInitiator+FLDispatchQueue.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncInitiator+FLDispatchQueue.h"
#import "FLDispatchQueue.h"
#import "FLFinisher.h"
#import "FLPromise.h"
#import "FLOperation.h"

@implementation FLAsyncInitiator (FLDispachQueue)

- (FLPromise*) dispatchAsyncInQueue:(FLDispatchQueue*) queue
                         completion:(fl_completion_block_t) completion {

    FLFinisher* finisher = self.finisher;
    FLPromise* promise = [finisher addPromiseWithBlock:completion];

    fl_block_t block = ^{
        @try {
            [self startAsyncOperation:finisher inQueue:queue];
        }
        @catch(NSException* ex) {
            [finisher setFinishedWithResult:ex.error];
        }
    };

    NSTimeInterval delay = self.delay;
    if(delay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (delay * NSEC_PER_SEC)), queue.dispatch_queue_t, block);
    }
    else {
        dispatch_async(queue.dispatch_queue_t, block);
    }

    return promise;
}

- (FLPromisedResult) dispatchSyncInQueue:(FLDispatchQueue*) queue {

    __block FLPromisedResult result = nil;

    FLFinisher* finisher = self.finisher;

    fl_block_t block = ^{
        @try {
            result = [self runSynchronousOperation:finisher inQueue:queue];
        }
        @catch(NSException* ex) {
            [finisher setFinishedWithResult:ex.error];
        }
    };

    dispatch_sync(queue.dispatch_queue_t, block);

    return result;
}


@end


