//
//  FLOperationContext.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLFinisher.h"
#import "FLAsyncQueueDecorator.h"
#import "FLDecoratedAsyncQueue.h"

//#import "FLAsyncMessageBroadcaster.h"
@class FLCancellableAsyncQueue;

@class FLOperation;
@class FLOperationQueue;
@class FLFifoAsyncQueue;
@class FLAsyncQueueDecorator;

//typedef void (^FLOperationVisitor)(id operation, BOOL* stop);

extern NSString* const FLWorkerContextStarting;
extern NSString* const FLWorkerContextFinished;
extern NSString* const FLWorkerContextClosed;
extern NSString* const FLWorkerContextOpened;

@interface FLOperationContext : FLDecoratedAsyncQueue {
@private
    NSUInteger _contextID;
    BOOL _contextOpen;
    FLCancellableAsyncQueue* _cancelQueue;
}

@property (readonly, assign, getter=isContextOpen) BOOL contextOpen;
@property (readonly, assign) NSUInteger contextID;

+ (id) operationContext;

- (void) openContext;
- (void) closeContext;

- (void) requestCancel;

@end

//@protocol FLOperationQueueDecorator <NSObject>
//- (void) didQueueOperation:(id<FLOperation>) operation;
//@end


//@interface FLOperationContext (OptionalOverrides)
//- (void) removeOperation:(FLOperation*) operation;
//@end

//@protocol FLOperationContextObserverMessages <NSObject>
////- (void) operationContextDidStartWorking:(FLOperationContext*) operationContext;
////- (void) operationContextDidStopWorking:(FLOperationContext*) operationContext;
//- (void) operationContext:(FLOperationContext*) operationContext didAddOperation:(FLOperation*) object;
//- (void) operationContext:(FLOperationContext*) operationContext didRemoveOperation:(FLOperation*) object;
//@end
