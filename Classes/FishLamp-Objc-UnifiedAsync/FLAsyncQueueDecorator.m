//
//  FLAsyncQueueDecorator.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncQueueDecorator.h"

@implementation FLAsyncQueueDecorator

@synthesize nextQueue = _nextQueue;

#if FL_MRC
- (void)dealloc {
	[_nextQueue release];
	[super dealloc];
}
#endif

- (id) initWithNextQueue:(id<FLAsyncQueue>) queue {

    self = [super init];
    if(self) {
        _nextQueue = FLRetain(queue);
    }

    return _nextQueue;
}

- (id) init {	
    return [self initWithNextQueue:nil];
}

+ (id) asyncQueueDecorator:(id<FLAsyncQueue>) queue {
    return FLAutorelease([[[self class] alloc] initWithNextQueue:queue]);
}

- (FLPromise*) queueAsyncInitiator:(FLAsyncInitiator*) event
                        completion:(fl_completion_block_t) completion {
    return [self.nextQueue queueAsyncInitiator:event completion:completion];
}

- (FLPromisedResult) queueSynchronousInitiator:(FLAsyncInitiator*) event {
    return [self.nextQueue queueSynchronousInitiator:event];
}

@end
