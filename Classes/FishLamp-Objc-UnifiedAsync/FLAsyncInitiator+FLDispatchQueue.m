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

    __block FLFinisher* theFinisher = FLRetain(self.finisher);
    __block FLAsyncInitiator* myself = FLRetain(self);
    __block FLDispatchQueue* theQueue = FLRetain(queue);

    if(completion) {
        [theFinisher addPromiseWithBlock:completion];
    }

    fl_block_t block = ^{
        @try {
            [myself startAsyncOperation:theFinisher inQueue:theQueue];
        }
        @catch(NSException* ex) {
            [theFinisher setFinishedWithResult:ex.error];
        }

        FLReleaseWithNil(theFinisher);
        FLReleaseWithNil(myself);
        FLReleaseWithNil(theQueue);
    };

    NSTimeInterval delay = self.delay;
    if(delay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (delay * NSEC_PER_SEC)), queue.dispatch_queue_t, block);
    }
    else {
        dispatch_async(queue.dispatch_queue_t, block);
    }

    return self.finisher;
}

- (FLPromisedResult) dispatchSyncInQueue:(FLDispatchQueue*) queue {

    __block FLPromisedResult result = nil;
    __block FLFinisher* theFinisher = FLRetain(self.finisher);
    __block FLAsyncInitiator* myself = FLRetain(self);
    __block FLDispatchQueue* theQueue = FLRetain(queue);

    fl_block_t block = ^{
        @try {
            result = FLRetain([myself runSynchronousOperation:theFinisher inQueue:theQueue]);
        }
        @catch(NSException* ex) {
            [theFinisher setFinishedWithResult:ex.error];
        }
        FLReleaseWithNil(theFinisher);
        FLReleaseWithNil(theQueue);
        FLReleaseWithNil(myself);
    };

    dispatch_sync(queue.dispatch_queue_t, block);

    return FLAutorelease(result);
}


@end


