//
//  FLDispatchQueue.h
//  FLCore
//
//  Created by Mike Fullerton on 10/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <dispatch/dispatch.h>

#import "FishLampMinimum.h"
#import "FLAsyncQueue.h"

@class FLFifoAsyncQueue;

@interface FLDispatchQueue : FLAbstractAsyncQueue {
@private
    dispatch_queue_t _dispatch_queue;
    NSString* _label;
}

// 
// Info
//
//__attribute__((NSObject))
#if OS_OBJECT_USE_OBJC
@property (readonly, strong) dispatch_queue_t dispatch_queue_t;
#else
@property (readonly, assign) dispatch_queue_t dispatch_queue_t;
#endif

@property (readonly, strong) NSString* label;

// 
// constructors
//

- (id) initWithLabel:(NSString*) label  
                attr:(dispatch_queue_attr_t) attr;

- (id) initWithDispatchQueue:(dispatch_queue_t) queue;

+ (FLDispatchQueue*) fifoDispatchQueue:(NSString*) label;

#if __MAC_10_8
+ (FLDispatchQueue*) concurrentDispatchQueue:(NSString*) label;
#endif

+ (FLDispatchQueue*) dispatchQueue:(dispatch_queue_t) queue;

+ (FLDispatchQueue*) dispatchQueueWithLabel:(NSString*) label 
                                       attr:(dispatch_queue_attr_t) attr;

// same as GCD functions, just here for convienience so you don't have to get the dispatch_block_t
// for those send and forget

- (void) dispatch_async:(dispatch_block_t) block;

- (void) dispatch_sync:(dispatch_block_t) block;

- (void) dispatch_after:(NSTimeInterval) seconds block:(dispatch_block_t) block;

- (void) dispatch_target:(id) target action:(SEL) action;

- (void) dispatch_target:(id) target action:(SEL) action withObject:(id) object;

// 
// Shared Queues
//

+ (FLDispatchQueue*) veryLowPriorityQueue;

+ (FLDispatchQueue*) lowPriorityQueue;

+ (FLDispatchQueue*) defaultQueue;

+ (FLDispatchQueue*) highPriorityQueue;

+ (FLDispatchQueue*) mainThreadQueue; // note this is a fifo queue.

+ (FLFifoAsyncQueue*) fifoQueue;

// 
// Utils
//

+ (FLDispatchQueue*) currentQueue;

#if __MAC_10_8
+ (void) sleepForTimeInterval:(NSTimeInterval) milliseconds;
#endif
@end

@interface FLFifoAsyncQueue : FLDispatchQueue
+ (id) fifoAsyncQueue;
@end


#define FLForegroundQueue       [FLDispatchQueue mainThreadQueue]
#define FLBackgroundQueue       [FLDispatchQueue defaultQueue]
#define FLBackgroundFifoQueue   [FLDispatchQueue fifoQueue]
#define FLDefaultQueue          [FLDispatchQueue defaultQueue]
