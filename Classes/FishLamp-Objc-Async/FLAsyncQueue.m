//
//  FLAbstractDispatcher.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAsyncQueue.h"
#import "FLAsyncInitiator.h"
#import "FLQueueableAsyncOperation.h"


@implementation FLAbstractAsyncQueue

- (FLPromise*) queueAsyncInitiator:(FLAsyncInitiator*) event completion:(fl_completion_block_t) completion {
    return nil;
}

- (FLPromisedResult) queueSynchronousInitiator:(FLAsyncInitiator*) event {
    return nil;
}

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block
                        completion:(fl_completion_block_t) completion {

    return [self queueAsyncInitiator:[FLBlockAsyncInitiator blockEventWithDelay:delay block:block] completion:completion];
}

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block {
    return [self queueAsyncInitiator:[FLBlockAsyncInitiator blockEventWithDelay:delay block:block] completion:nil];
}

- (FLPromise*) queueBlock:(fl_block_t) block {
    return [self queueAsyncInitiator:[FLBlockAsyncInitiator blockEvent:block] completion:nil];
}

- (FLPromise*) queueBlock:(fl_block_t) block
               completion:(fl_completion_block_t) completionOrNil {
    return [self queueAsyncInitiator:[FLBlockAsyncInitiator blockEvent:block] completion:completionOrNil];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                         completion:(fl_completion_block_t) completionOrNil {
    return [self queueAsyncInitiator:[FLFinisherBlockAsyncInitiator finisherBlockEvent:block] completion:completionOrNil];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block {
    return [self queueAsyncInitiator:[FLFinisherBlockAsyncInitiator finisherBlockEvent:block] completion:nil];
}

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) object
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil {

    return [self queueAsyncInitiator:[object asyncInitiatorForAsyncQueue:self withDelay:delay] completion:completionOrNil];
}

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) object
                completion:(fl_completion_block_t) completionOrNil {

    return [self queueObject:object withDelay:0 completion:completionOrNil];
}

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) object {

    return [self queueObject:object withDelay:0 completion:nil];
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action {
    return [self queueBlock:^{
        [target performSelector:action];
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object {
    return [self queueBlock:^{
        [target performSelector:action withObject:object];
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2 {

    return [self queueBlock:^{
        [target performSelector:action withObject:object1 withObject:object2];
    }];
}

#pragma GCC diagnostic pop

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {
    return [self queueBlock:^{
        [target performSelector_fl:action withObject:object1 withObject:object2 withObject:object3];
    }];

}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4 {
    return [self queueBlock:^{
        [target performSelector_fl:action withObject:object1 withObject:object2 withObject:object3 withObject:object4];
    }];
}

- (FLPromisedResult) runBlockSynchronously:(fl_block_t) block {
    return [self queueSynchronousInitiator:[FLBlockAsyncInitiator blockEvent:block]];
}

- (FLPromisedResult) runFinisherBlockSynchronously:(fl_finisher_block_t) block {
    return [self queueSynchronousInitiator:[FLFinisherBlockAsyncInitiator finisherBlockEvent:block]];
}

- (FLPromisedResult) runSynchronously:(id) object {
    return [self queueSynchronousInitiator:[object asyncInitiatorForAsyncQueue:self withDelay:0]];
}

@end

