//
//  FLAsyncInitiator.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncInitiator.h"
#import "FLFinisher.h"
#import "FLPromise.h"

@implementation FLAsyncInitiator

@synthesize delay = _delay;

- (FLFinisher*) finisher {
    return nil;
}

- (id) initWithDelay:(NSTimeInterval) delay {
	self = [super init];
	if(self) {
        _delay = delay;
	}
	return self;
}

- (void) startAsyncOperation:(FLFinisher*) finisher inQueue:(id<FLAsyncQueue>) queue {
    FLAssertionFailedWithComment(@"must overrided this");
}

- (FLPromisedResult) runSynchronousOperation:(FLFinisher*) finisher
                                     inQueue:(id<FLAsyncQueue>) queue {

    FLPromise* promise = [finisher addPromise];
    [self startAsyncOperation:finisher inQueue:queue];
    return [promise waitUntilFinished];
}

@end

@implementation FLBlockAsyncInitiator

@synthesize block =_block;
@synthesize finisher = _finisher;

- (id) initWithBlock:(fl_block_t) block {
    return [self initWithDelay:0 block:block];
}

- (id) initWithDelay:(NSTimeInterval) delay block:(fl_block_t) block {
	self = [super initWithDelay:delay];
	if(self) {
        _finisher = [[FLFinisher alloc] init];
		_block = [block copy];
	}
	return self;
}

+ (id) blockEvent:(fl_block_t) block {
    return FLAutorelease([[[self class] alloc] initWithDelay:0 block:block]);
}

+ (id) blockEventWithDelay:(NSTimeInterval) delay block:(fl_block_t) block {
    return FLAutorelease([[[self class] alloc] initWithDelay:0 block:block]);
}

#if FL_MRC
- (void)dealloc {
    [_finisher release];
	[_block release];
	[super dealloc];
}
#endif

- (void) startAsyncOperation:(FLFinisher*) finisher inQueue:(id<FLAsyncQueue>) queue {
    if(self.block) {
        self.block();
    }
    [finisher setFinished];
}
@end

@implementation FLFinisherBlockAsyncInitiator

@synthesize block =_block;
@synthesize finisher = _finisher;

- (id) initWithFinisherBlock:(fl_finisher_block_t) block {
    return [self initWithDelay:0 finisherBlock:block];
}

- (id) initWithDelay:(NSTimeInterval) delay finisherBlock:(fl_finisher_block_t) block {
	self = [super initWithDelay:delay];
	if(self) {
        _finisher = [[FLFinisher alloc] init];
		_block = block;
	}
	return self;
}

+ (id) finisherBlockEvent:(fl_finisher_block_t) block {
    return FLAutorelease([[[self class] alloc] initWithDelay:0 finisherBlock:block]);
}

+ (id) finisherBlockEventWithDelay:(NSTimeInterval) delay finisherBlock:(fl_finisher_block_t) block {
    return FLAutorelease([[[self class] alloc] initWithDelay:delay finisherBlock:block]);
}

#if FL_MRC
- (void)dealloc {
    [_finisher release];
	[_block release];
	[super dealloc];
}
#endif

- (void) startAsyncOperation:(FLFinisher*) finisher inQueue:(id<FLAsyncQueue>) queue {
    if(self.block) {
        self.block(finisher);
    }
}

@end
