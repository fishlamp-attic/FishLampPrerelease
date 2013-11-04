//
//  FLAbstractDispatcher.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"
#import "FLPromise.h"
#import "FLFinisher.h"

@protocol FLQueueableAsyncOperation;

@protocol FLAsyncQueue <NSObject>

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block
                        completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block;

- (FLPromise*) queueBlock:(fl_block_t) block
               completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueBlock:(fl_block_t) block;

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                         completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block;

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) operation
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) operation
                completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) operation;

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action;

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object;

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2;

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3;

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4;

- (FLPromisedResult) runBlockSynchronously:(fl_block_t) block;

- (FLPromisedResult) runFinisherBlockSynchronously:(fl_finisher_block_t) block;

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) asyncObject;

@end

@protocol FLQueueableAsyncOperation <NSObject>
- (FLFinisher*) finisher;

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue;

- (FLPromisedResult) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue;
@end


