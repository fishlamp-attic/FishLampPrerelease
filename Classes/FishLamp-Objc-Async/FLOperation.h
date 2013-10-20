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
#import "FLQueueableAsyncOperation.h"
#import "FLFinishable.h"
#import "FLBroadcaster.h"
#import "FLSuccessfulResult.h"
#import "NSError+FLFailedResult.h"

@class FLOperationContext;
@class FLFinisher;
@class FLPromise;
@class FLOperationFinisher;

@protocol FLAsyncQueue;
@protocol FLOperationEvents;

@interface FLOperation : FLBroadcaster<FLFinishable, FLQueueableAsyncOperation> {
@private
	id _identifier;
    id<FLAsyncQueue> _asyncQueue;
    FLOperationFinisher* _finisher;
    NSUInteger _contextID;
    BOOL _cancelled;
    __unsafe_unretained FLOperationContext* _context;
}

// unique id. by default an incrementing integer number
@property (readwrite, strong) id identifier;

// id of context. 
@property (readonly, assign) NSUInteger contextID;

// if you want control over your executing operation, run it in a context.
@property (readonly, assign, nonatomic) id context;

// cancel yourself, and be quick about it.
@property (readonly, assign, getter=wasCancelled) BOOL cancelled;
- (void) requestCancel;

// overide points
- (void) startOperation;

// optional overrides
- (void) didFinishWithResult:(FLPromisedResult) result;
- (void) willStartOperation;

// DEPRECATED
// note that if you start an operation directly in a queue (e.g. you don't call start or run) the asyncQueue is ignored 
@property (readwrite, strong, nonatomic) id<FLAsyncQueue> asyncQueue;

@end

@interface FLOperation (Finishing)

- (FLFinisher*) finisher;

- (void) setFinished;
- (void) setFinishedWithResult:(id) result;

- (void) abortIfCancelled; // throws cancelError

// optional override
- (void) didFinishWithResult:(FLPromisedResult) result;

@end

@interface FLOperation (OperationContext)
- (void) wasAddedToContext:(FLOperationContext*) context;
- (void) wasRemovedFromContext:(FLOperationContext*) context;
- (void) contextDidClose;
- (void) contextDidOpen;
- (void) contextDidCancel;
@end

@protocol FLOperationEvents <NSObject>
@optional
- (void) operationWillBegin:(id) operation;
- (void) operationDidFinish:(id) operation withResult:(FLPromisedResult) result;
@end

#define FLDeclareExpectedResult(__CLASS_NAME__) \
    + (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result; \
    - (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result

#define FLSynthesizeExpectedResult(__CLASS_NAME__) \
    + (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result { \
        return [__CLASS_NAME__ fromPromisedResult:result]; \
    } \
    - (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result { \
        return [__CLASS_NAME__ fromPromisedResult:result]; \
    }