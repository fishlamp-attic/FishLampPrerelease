//
//  FLDispatchQueue.m
//  FLCore
//
//  Created by Mike Fullerton on 10/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDispatchQueue.h"
#import "FLSelectorPerforming.h"
#import "FLFinisher.h"
#import "FLPromisedResult.h"
#import "FLPromise.h"
#import "FLAsyncInitiator+FLDispatchQueue.h"

#if DEPRECATED
static void * const s_queue_key = (void*)&s_queue_key;
#endif

@implementation FLDispatchQueue

@synthesize dispatch_queue_t = _dispatch_queue;
@synthesize label = _label;

- (id) initWithDispatchQueue:(dispatch_queue_t) queue {
    if(!queue) {
        return nil;
    }
    
    self = [super init];
    if(self) {
        _dispatch_queue = queue;
#if !OS_OBJECT_USE_OBJC
        dispatch_retain(_dispatch_queue);
#endif
#if DEPRECATED
#if __MAC_10_8
        if(OSXVersionIsAtLeast10_7()) {        
            dispatch_queue_set_specific(_dispatch_queue, s_queue_key, FLBridge(void*, self), nil);
        }
#endif
#endif
        _label = [[NSString alloc] initWithCString:dispatch_queue_get_label(_dispatch_queue) encoding:NSASCIIStringEncoding];
    }
    return self;
}

- (id) initWithLabel:(NSString*) label  
                attr:(dispatch_queue_attr_t) attr {

    dispatch_queue_t queue = dispatch_queue_create([label cStringUsingEncoding:NSASCIIStringEncoding], attr);
    if(!queue) {
        return nil;
    }
    @try {
        self = [self initWithDispatchQueue:queue];
    }
    @finally {
#if !OS_OBJECT_USE_OBJC
        dispatch_release(queue);
#endif
    }

    return self;
}

+ (FLDispatchQueue*) dispatchQueue:(dispatch_queue_t) queue {
    return FLAutorelease([[[self class] alloc] initWithDispatchQueue:queue]);
}

+ (FLDispatchQueue*) dispatchQueueWithLabel:(NSString*) label attr:(dispatch_queue_attr_t) attr {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:attr]);
}

#if __MAC_10_8
+ (FLDispatchQueue*) fifoDispatchQueue:(NSString*) label {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:DISPATCH_QUEUE_SERIAL]);
}

+ (FLDispatchQueue*) concurrentDispatchQueue:(NSString*) label {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:DISPATCH_QUEUE_CONCURRENT]);
}
#else

// 10.6
+ (FLDispatchQueue*) fifoDispatchQueue:(NSString*) label {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:nil]);
}

#endif

- (void) dealloc {
    if(_dispatch_queue) {
#if DEPRECATED
#if __MAC_10_8
        if(OSXVersionIsAtLeast10_7()) {        
            dispatch_queue_set_specific(_dispatch_queue, s_queue_key, nil, nil);
        }
#endif        
#endif
#if !OS_OBJECT_USE_OBJC
        dispatch_release(_dispatch_queue);
#endif
    }
    
#if FL_MRC
    [_label release];
    [super dealloc];
#endif
}

#if DEPRECATED
+ (FLDispatchQueue*) currentQueue {

    FLDispatchQueue* currentQueue = nil;

#if __MAC_10_8
    if(OSXVersionIsAtLeast10_7()) {        
        currentQueue = FLBridge(FLDispatchQueue*, dispatch_queue_get_specific(dispatch_get_current_queue(), s_queue_key));
    }
#endif    

    if(!currentQueue) {
        if([NSThread isMainThread]) {
            currentQueue = [FLDispatchQueue mainThreadQueue];
        }
        else {
            currentQueue = [FLDispatchQueue defaultQueue];
        }
    }

    FLAssertNotNil(currentQueue);

    return currentQueue;
}
#endif

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], self.label];
}

- (FLPromise*) queueAsyncInitiator:(FLAsyncInitiator*) event
                    completion:(fl_completion_block_t) completion {
    return [event dispatchAsyncInQueue:self completion:completion];
}

- (FLPromisedResult) queueSynchronousInitiator:(FLAsyncInitiator*) event {
    return [event dispatchSyncInQueue:self];
}

#if __MAC_10_8

+ (void) sleepForTimeInterval:(NSTimeInterval)milliseconds {
    
    if([NSThread isMainThread]) {
        NSTimeInterval timeout = [NSDate timeIntervalSinceReferenceDate] + milliseconds;
        while([NSDate timeIntervalSinceReferenceDate] < timeout) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
        }
    } 
    else {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_wait(semaphore, 
                                dispatch_time(DISPATCH_TIME_NOW, (milliseconds * NSEC_PER_MSEC)));
#if !OS_OBJECT_USE_OBJC
        dispatch_release(semaphore);
#endif
    } 
}    

#endif

- (void) runBlockSynchronously:(dispatch_block_t) block {

    __block NSError* error = nil;
    
    FLPrepareBlockForFutureUse(block);
    
    dispatch_sync(self.dispatch_queue_t, ^{
        @try {
            block();
        }
        @catch(NSException* ex) {
            error = ex.error;
        }
    });
    
    FLThrowIfError(error);
}

- (FLPromisedResult) runFinisherBlockSynchronously:(fl_finisher_block_t) block {

    __block FLPromisedResult outResult = nil;
    __block FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) {
        outResult = FLRetain(result);
    }];
    FLAssertNotNil(finisher);

    FLPrepareBlockForFutureUse(block);

    FLRetain(finisher);
    dispatch_sync(self.dispatch_queue_t, ^{
        @try {
            block(finisher);
        }
        @catch(NSException* ex) {
            [finisher setFinishedWithResult:ex.error];
        }

        FLReleaseWithNil(finisher);
    });
    
    return FLAutorelease(outResult);
}

- (void) dispatch_async:(dispatch_block_t) block {
    dispatch_async(self.dispatch_queue_t, block);
}

- (void) dispatch_sync:(dispatch_block_t) block {
    dispatch_sync(self.dispatch_queue_t, block);
}

- (void) dispatch_after:(NSTimeInterval) seconds block:(dispatch_block_t) block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (seconds * NSEC_PER_SEC)), self.dispatch_queue_t, block);
}

- (void) dispatch_target:(id) target action:(SEL) action {
    __block id theTarget = FLRetain(target);
    [self dispatch_async:^{
        [theTarget performSelector:action];
        FLReleaseWithNil(theTarget);
    }];
}

- (void) dispatch_target:(id) target action:(SEL) action withObject:(id) object {
    __block id theTarget = FLRetain(target);
    __block id theObject = FLRetain(object);

    [self dispatch_async:^{
        [theTarget performSelector:action withObject:theObject];
        FLReleaseWithNil(theTarget);
        FLReleaseWithNil(theObject);
    }];
}

- (FLPromise*) queueBlock:(fl_block_t) block {
    return [self queueBlock:block completion:nil];
}

- (FLPromise*) queueBlock:(fl_block_t) block
                completion:(fl_completion_block_t) completion {

    __block FLFinisher* finisher = [FLFinisher finisherWithBlock:completion];
    FLAssertNotNil(finisher);

    FLPrepareBlockForFutureUse(block);

    FLRetain(finisher);
    dispatch_async(_dispatch_queue, ^{
        @try {
            if(block) {
                block();
            }
            [finisher setFinished];
        }
        @catch(NSException* ex) {
            [finisher setFinishedWithResult:ex.error];
        }

        FLReleaseWithNil(finisher);
    });


    return finisher;
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                          completion:(fl_completion_block_t) completion {

    __block FLFinisher* theFinisher = [FLFinisher finisherWithBlock:completion];
    FLAssertNotNil(theFinisher);

    FLPrepareBlockForFutureUse(block);

    FLRetain(theFinisher);
    [self dispatch_async:^{
        @try {
            if(block) {
                block(theFinisher);
            }
        }
        @catch(NSException* ex) {
            [theFinisher setFinishedWithResult:ex.error];
        }

        FLReleaseWithNil(theFinisher);
    }];

    return theFinisher;
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block {
    return [self queueFinishableBlock:block completion:nil];
}

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block
                        completion:(fl_completion_block_t) completion {

    __block FLFinisher* finisher = [FLFinisher finisherWithBlock:completion];
    FLAssertNotNil(finisher);

    FLRetain(finisher);
    [self dispatch_after:delay block:^{
        @try {
            
            if(block) {
                block();
            }
            [finisher setFinished];
        }
        @catch(NSException* ex) {
            [finisher setFinishedWithResult:ex.error];
        }

        FLReleaseWithNil(finisher);
    }];

    return finisher;
}


- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block {
    return [self queueBlockWithDelay:delay block:block completion:nil];
}

- (FLPromise*) queueOperation:(id<FLDispatchable>) operation
                   completion:(fl_result_block_t) completion {

    FLAssertNotNil(operation);
    
    __block FLFinisher* theFinisher = FLRetain([operation asyncQueueWillBeginAsync:self]);
    __block id<FLDispatchable> theOperation = FLRetain(operation);

    FLPromise* promise = [theFinisher addPromiseWithBlock:completion];

    [self dispatch_async:^{
        @try {
            [theOperation asyncQueue:self beginAsyncWithFinisher:theFinisher];
        }
        @catch(NSException* ex) {
            [theFinisher setFinishedWithResult:ex.error];
        }

        FLReleaseWithNil(theFinisher);
        FLReleaseWithNil(theOperation);
    }];
    
    return promise;
}                  

- (FLPromise*) queueOperation:(id<FLDispatchable>) operation {
    return [self queueOperation:operation completion:nil];
}

- (FLPromisedResult) runOperationSynchronously:(id<FLDispatchable>) operation {
    
    __block FLPromisedResult theResult = nil;
    __block id<FLDispatchable> theOperation = FLRetainWithAutorelease(operation);

    FLRetain(theOperation);
    [self dispatch_sync:^{
        theResult = FLRetain([theOperation runSynchronouslyInAsyncQueue:self]);

        FLReleaseWithNil(theOperation);
    }];
    
    return FLAutorelease(theResult);
}

+ (FLDispatchQueue*) lowPriorityQueue {
    FLReturnStaticObject( [FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)]);
}
+ (FLDispatchQueue*) defaultQueue {
    FLReturnStaticObject( [FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]);
}
+ (FLDispatchQueue*) highPriorityQueue {
    FLReturnStaticObject([FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)]);
}
+ (FLDispatchQueue*) veryLowPriorityQueue {
    FLReturnStaticObject([FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]);
}
+ (FLDispatchQueue*) mainThreadQueue {
    FLReturnStaticObject([FLDispatchQueue dispatchQueue:dispatch_get_main_queue()]);
}

+ (FLFifoAsyncQueue*) fifoQueue {
    FLReturnStaticObject([[FLFifoAsyncQueue alloc] init]);
}

@end

@implementation FLFifoAsyncQueue  

+ (id) fifoAsyncQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    static int s_count = 0;
#if __MAC_10_8
    return [super initWithLabel:[NSString stringWithFormat:@"com.fishlamp.queue.fifo%d", s_count++] attr:DISPATCH_QUEUE_SERIAL];
#else 
    return [super initWithLabel:[NSString stringWithFormat:@"com.fishlamp.queue.fifo%d", s_count++] attr:nil];
#endif
}

//+ (FLObjectPool*) pool {
//    static FLObjectPoolFactory s_factory = ^{
//        return [FLFifoAsyncQueue fifoAsyncQueue];
//    };
//
//    FLReturnStaticObject([[FLObjectPool alloc] initWithObjectFactory:s_factory]); 
//}

- (void) releaseToPool {

}

@end



