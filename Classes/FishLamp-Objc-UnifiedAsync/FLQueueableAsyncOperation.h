//
//  FLQueueableAsyncOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@class FLAsyncInitiator;
@protocol FLAsyncQueue;

@protocol FLQueueableAsyncOperation <NSObject>
- (FLAsyncInitiator*) asyncInitiatorForAsyncQueue:(id<FLAsyncQueue>) queue withDelay:(NSTimeInterval) delay;
@end
