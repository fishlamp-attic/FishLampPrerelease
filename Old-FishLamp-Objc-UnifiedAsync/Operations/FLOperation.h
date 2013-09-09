//
//  FLOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/29/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"
#import "FLAsyncMessageBroadcaster.h"
#import "FLFinishable.h"
#import "FLQueueableAsyncOperation.h"
#import "FLSuccessfulResult.h"
#import "NSError+FLFailedResult.h"

@class FLFinisher;
@class FLPromise;
@class FLOperationFinisher;

@protocol FLAsyncQueue;
@protocol FLOperationEvents;

@interface FLOperation : FLAsyncMessageBroadcaster<FLFinishable, FLQueueableAsyncOperation> {
@private
	id _identifier;
    FLOperationFinisher* _finisher;
    BOOL _cancelled;
    NSMutableArray* _children;
    __unsafe_unretained id<FLAsyncQueue> _asyncQueue;
    NSInteger _childCount;

// deprecated
    id _storageService;
}

// unique id. by default an incrementing integer number
@property (readwrite, strong) id identifier;
@property (readonly, assign) id<FLAsyncQueue> asyncQueue;

// cancel yourself, and be quick about it.
@property (readonly, assign, getter=wasCancelled) BOOL cancelled;
- (void) requestCancel;

// overide points
- (void) startOperation;

// this will be deprecated soon
@property (readwrite, strong, nonatomic) id storageService /*__attribute__((deprecated))*/;
@end

@interface FLOperation (Finishing)

- (FLFinisher*) finisher;

- (void) setFinished;
- (void) setFinishedWithResult:(id) result;

- (void) abortIfCancelled; // throws cancelError

// optional override
- (void) didFinishWithResult:(FLPromisedResult) result;

@end

@interface FLOperation (Synchronous)
// SEE FLSynchronousOperation
- (FLPromisedResult) runSynchronously;
@end

@interface FLOperation (ChildOperations)
// these call willRunInParent on the child before operation
// is run or started.
- (FLPromisedResult) runChildSynchronously:(FLOperation*) operation;

- (FLPromise*) runChildAsynchronously:(FLOperation*) operation;

- (FLPromise*) runChildAsynchronously:(FLOperation*) operation 
                            completion:(fl_completion_block_t) completionOrNil;
@end

@protocol FLOperationEvents <NSObject>
@optional
- (void) operationWillBegin:(id) operation;
- (void) operationDidFinish:(id) operation withResult:(FLPromisedResult) result;
@end

