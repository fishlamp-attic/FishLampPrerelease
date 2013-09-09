//
//  FLOperationQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLDispatchQueue.h"
#import "FLAsyncQueue.h"
#import "FLAsyncMessageBroadcaster.h"

@class FLFifoAsyncQueue;
@class FLOperation;

@protocol FLOperationQueueOperationFactory;
@protocol FLOperationQueueErrorStrategy;

@interface FLOperationQueue : FLAsyncMessageBroadcaster {
@private
    FLFifoAsyncQueue* _schedulingQueue;
    NSMutableArray* _objectQueue;
    NSMutableArray* _activeQueue;
    NSMutableArray* _operationFactories;

    UInt32 _maxConcurrentOperations;
    NSInteger _finishedCount;
    NSInteger _totalCount;
    BOOL _processing;
    NSString* _queueName;

    id<FLOperationQueueErrorStrategy> _errorStrategy;
}

// concurrent operations, defaults to 1
@property (readwrite, assign) UInt32 maxConcurrentOperations;

- (id) initWithName:(NSString*) name;
- (id) initWithName:(NSString*) name
      errorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy;

+ (id) operationQueue;
+ (id) operationQueueWithName:(NSString*) name
                errorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy;

// info
@property (readonly, strong) NSString* queueName;
@property (readonly, assign) NSInteger finishedCount;
@property (readonly, assign) NSInteger totalCount;

///    objects that are queued will attempt to create an operation when it is their turn to execute.
///    Will try to get operation in following order
///    1. [object createOperationForOperationQueue];
///    2. iterate through operationQueue's factory list.
- (void) queueObject:(id) object;

///    see queueObject comment.
///    Note it is more efficient to send in an array than individual objects.
- (void) queueObjectsInArray:(NSArray*) queuedObjects;

///    operations that are queued don't get sent through factories.
- (void) queueOperation:(FLOperation*) operation;

///    start the queue.
- (void) startProcessing;

///    tell the queue to stop.
///    Note the currently executing operations will finish before it stops.
- (void) stopProcessing;

///    cancel all the operations and stop processing
- (void) requestCancel;

///    add factory for creating operations to be executed in the operation queue.
- (void) addOperationFactory:(id<FLOperationQueueOperationFactory>) factory;


// optional overrides

- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object;

- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result;

- (FLOperation*) createOperationForQueuedObject:(id) object;
@end

@protocol FLOperationQueueErrorStrategy <NSObject>
- (void) setCancelled;
- (void) handleError:(NSError*) error forQueuedObject:(id) object;
- (void) operationQueueDidBeginProcessing:(FLOperationQueue*) operationQueue;
- (BOOL) operationQueueWillHalt:(FLOperationQueue*) operationQueue;
- (NSError*) errorResult;
@end

@interface FLSingleErrorOperationQueueStrategy : NSObject {
@private
    NSError* _error;
}

@end

@protocol FLQueuedObject <NSObject>
@optional
- (FLOperation*) createOperationForOperationQueue:(FLOperationQueue*) operationQueue;
@end

@protocol FLOperationQueueOperationFactory <NSObject>
- (FLOperation*) createOperationForQueuedObject:(id) object;
@end

@protocol FLOperationQueueEvents <NSObject>
@optional
- (void) operationQueueDidStart:(FLOperationQueue*) operationQueue;

- (void) operationQueue:(FLOperationQueue*) operationQueue
    didFinishWithResult:(FLPromisedResult) result;

- (void) operationQueue:(FLOperationQueue*) operationQueue
      didStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object;

- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result;
@end


#define FLQueueableAsyncOperationQueueOperationDefaultMaxConcurrentOperations 3

@interface FLBatchOperationQueue : FLOperationQueue
+ (void) setDefaultConnectionLimit:(UInt32) threadCount;
+ (UInt32) defaultConnectionLimit;
@end