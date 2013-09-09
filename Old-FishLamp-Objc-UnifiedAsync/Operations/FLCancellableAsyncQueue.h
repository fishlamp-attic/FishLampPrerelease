//
//  FLCancellableAsyncQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncQueueDecorator.h"

@interface FLCancellableAsyncQueue : FLAsyncQueueDecorator {
@private
    NSMutableArray* _operations;
}

+ (id) cancellableAsyncQueue:(id<FLAsyncQueue>) nextQueue;

- (void) requestCancel;          

@end
