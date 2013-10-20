//
//  FLAsyncInitiator+FLDispatchQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLAsyncInitiator.h"
#import "FLAsyncBlockTypes.h"

@class FLDispatchQueue;
@class FLPromise;
@protocol FLAsyncQueue;

@interface FLAsyncInitiator (FLDispatchQueue)
- (FLPromise*) dispatchAsyncInQueue:(FLDispatchQueue*) queue
                    completion:(fl_completion_block_t) completion;

- (FLPromisedResult) dispatchSyncInQueue:(FLDispatchQueue*) queue;

@end