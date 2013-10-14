//
//  FLAsyncInitiator.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLAsyncBlockTypes.h"

@class FLFinisher;
@protocol FLAsyncQueue;

@interface FLAsyncInitiator : NSObject {
@private
    NSTimeInterval _delay;
}
@property (readonly, assign) NSTimeInterval delay;
- (FLFinisher*) finisher;
- (id) initWithDelay:(NSTimeInterval) delay;

- (void) startAsyncOperation:(FLFinisher*) finisher
                     inQueue:(id<FLAsyncQueue>) queue;

- (FLPromisedResult) runSynchronousOperation:(FLFinisher*) finisher
                                     inQueue:(id<FLAsyncQueue>) queue;

@end


@interface FLBlockAsyncInitiator : FLAsyncInitiator {
@private
    FLFinisher* _finisher;
    fl_block_t _block;
}

@property (readonly, strong) FLFinisher* finisher;
@property (readonly, copy) fl_block_t block;

- (id) initWithBlock:(fl_block_t) block;
- (id) initWithDelay:(NSTimeInterval) delay block:(fl_block_t) block;

+ (id) blockEvent:(fl_block_t) block;
+ (id) blockEventWithDelay:(NSTimeInterval) delay block:(fl_block_t) block;
@end

@interface FLFinisherBlockAsyncInitiator : FLAsyncInitiator {
@private
    FLFinisher* _finisher;
    fl_finisher_block_t _block;
}

@property (readonly, strong) FLFinisher* finisher;
@property (readonly, copy) fl_finisher_block_t block;

- (id) initWithFinisherBlock:(fl_finisher_block_t) block;
- (id) initWithDelay:(NSTimeInterval) delay finisherBlock:(fl_finisher_block_t) block;

+ (id) finisherBlockEvent:(fl_finisher_block_t) block;
+ (id) finisherBlockEventWithDelay:(NSTimeInterval) delay finisherBlock:(fl_finisher_block_t) block;
@end

