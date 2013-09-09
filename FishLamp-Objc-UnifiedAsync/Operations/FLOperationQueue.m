//
//  FLOperationQueue.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationQueue.h"
#import "FLDispatchQueue.h"
#import "FLLog.h"
#import "FLSuccessfulResult.h"
#import "FLOperation.h"
#import "FLSynchronousOperation.h"

@interface FLOperationQueue ()
@property (readwrite, assign) NSInteger finishedCount;
@property (readwrite, assign) NSInteger totalCount;
@property (readwrite, assign) BOOL processing;
@property (readonly, strong) NSMutableArray* operationFactories;
@property (readonly, strong) NSMutableArray* activeQueue;
@property (readonly, strong) NSMutableArray* objectQueue;
@property (readonly, strong) FLFifoAsyncQueue* schedulingQueue;

@property (readonly, strong) id<FLOperationQueueErrorStrategy> errorStrategy;

@end

@interface FLOperationQueue (SchedulingQueue)
- (void) respondToProcessQueueEvent;
- (void) respondToCancelEvent;
- (void) respondToAddObjectArrayEvent:(NSArray*) array;
- (void) respondToAddObjectEvent:(id) object;
@end

@implementation NSObject (FLOperationQueue)
- (FLOperation*) createOperationForOperationQueue:(FLOperationQueue*) operationQueue {
    return nil;
}
@end

@implementation FLOperation (FLOperationQueue)
- (FLOperation*) createOperationForOperationQueue:(FLOperationQueue*) operationQueue {
    return self;
}
@end

@implementation FLOperationQueue

@synthesize maxConcurrentOperations = _maxConcurrentOperations;
@synthesize finishedCount = _finishedCount;
@synthesize totalCount = _totalCount;
@synthesize processing = _processing;
@synthesize activeQueue = _activeQueue;
@synthesize objectQueue = _objectQueue;
@synthesize schedulingQueue = _schedulingQueue;
@synthesize queueName = _queueName;
@synthesize errorStrategy = _errorStrategy;

FLSynthesizeLazyGetter(operationFactories, NSMutableArray*, _operationFactories, NSMutableArray);

- (id) initWithName:(NSString*) name
      errorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy {
	self = [super init];
	if(self) {
        _queueName = FLRetain(name);
        _schedulingQueue = [[FLFifoAsyncQueue alloc] init];
        _activeQueue = [[NSMutableArray alloc] init];
        _objectQueue = [[NSMutableArray alloc] init];
        _maxConcurrentOperations = 1;

        _errorStrategy = FLRetain(errorStrategy);
	}
	return self;
}

- (id) initWithName:(NSString*) name {
    return [self initWithName:name errorStrategy:nil];
}

- (id) init {	
    return [self initWithName:nil];
}

+ (id) operationQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) operationQueueWithName:(NSString*) name {
    return FLAutorelease([[[self class] alloc] initWithName:name]);
}

+ (id) operationQueueWithName:(NSString*) name
                errorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy {
    return FLAutorelease([[[self class] alloc] initWithName:name errorStrategy:errorStrategy]);
}

- (void) addOperationFactory:(id<FLOperationQueueOperationFactory>)factory {
    FLAssertWithComment(self.processing == NO, @"can't add a factory while processing");

    [self.operationFactories addObject:factory];
}

- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object {

    [FLBackgroundQueue queueBlock:^{
        [self.listeners.notify operationQueue:self
                           didStartOperation:operation
                             forQueuedObject:object];
        }];
}

- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result {

    [FLBackgroundQueue queueBlock:^{
        [self.listeners.notify operationQueue:self
                           didFinishOperation:operation
                             forQueuedObject:object
                                   withResult:result];
    }];
}

- (void) setFinishedWithResult:(FLPromisedResult) result {
    self.processing = NO;
    [self.listeners.notify operationQueue:self
                      didFinishWithResult:result];
}

- (void) processQueue {
    [self.schedulingQueue queueTarget:self action:@selector(respondToProcessQueueEvent)];
}

- (void) queueObjectsInArray:(NSArray*) queuedObjects {
    [self.schedulingQueue queueTarget:self action:@selector(respondToAddObjectArrayEvent:) withObject:queuedObjects];
}

- (void) queueObject:(id) object {
    [self.schedulingQueue queueTarget:self action:@selector(respondToAddObjectEvent:) withObject:object];
}

- (void) queueOperation:(FLOperation*) operation {
    [self.schedulingQueue queueTarget:self action:@selector(respondToAddObjectEvent:) withObject:operation];
}

- (void) startProcessing {
    [self.errorStrategy operationQueueDidBeginProcessing:self];
    self.processing = YES;
    [self processQueue];
}

- (void) stopProcessing {
    self.processing = NO;
}

- (void) requestCancel {
    [self.errorStrategy setCancelled];
    [self.schedulingQueue queueTarget:self action:@selector(respondToCancelEvent)];
}

#if FL_MRC 
- (void) dealloc {
    [_queueName release];
    [_errorStrategy release];
    [_operationFactories release];
    [_activeQueue release];
    [_schedulingQueue release];
    [_objectQueue release];
    [_errorStrategy release];
    [super dealloc];
}
#endif

- (void) sendCancelRequests {
    for(FLOperation* operation in self.activeQueue) {
        FLTrace(@"cancelled: %@", [operation description]);
        [operation requestCancel];
    }
    FLTrace(@"cancelled %d queued operations", _objectQueue.count);
}

- (void) respondToCancelEvent {
    [self sendCancelRequests];
    [self respondToProcessQueueEvent];
}

- (void) respondToAddObjectArrayEvent:(NSArray*) array {
    [_objectQueue addObjectsFromArray:array];
    self.totalCount += array.count;
    [self processQueue];
}

- (void) respondToAddObjectEvent:(id) object {
    [_objectQueue addObject:object];
    self.totalCount ++;
    [self processQueue];
}

- (void) respondToOperationFinished:(FLOperation*) operation
                    forQueuedObject:(id) queuedObject
                         withResult:(FLPromisedResult) result {

    self.finishedCount++;

    if([result isError]) {
        [self.errorStrategy handleError:[NSError fromPromisedResult:result] forQueuedObject:queuedObject];
    }
    else {

        FLTrace(@"finished operation: %@ withResult: %@",
                element.operation,
                [element.operationResult isError] ? element.operationResult : @"OK");

        [self didFinishOperation:operation forQueuedObject:queuedObject withResult:result];
    }

    [_activeQueue removeObject:operation];
    [self respondToProcessQueueEvent];
}

- (FLOperation*) createOperationForQueuedObject:(id) object {

    FLOperation* operation = [object createOperationForOperationQueue:self];

    if(!operation) {
        for(id<FLOperationQueueOperationFactory> factory in _operationFactories) {
            operation = [factory createOperationForQueuedObject:object];

            if(operation) {
                break;
            }
        }
    }

    FLAssertNotNilWithComment(operation, @"no operation created for queue for: %@", [object description]);

    return operation;
}

- (void) startOperationForObject:(id) object {
    FLOperation* operation = [self createOperationForQueuedObject:object];

    [_activeQueue addObject:operation];

    [self willStartOperation:operation forQueuedObject:object];
    
    FLTrace(@"starting operation: %@, queued object: %@",
        FLStringFromClass([operation class]),
        [object description]);

// TODO: give operations chance to run in whatever queue they want?
    [FLBackgroundQueue queueObject:operation
                        completion:^(FLPromisedResult result) {

        [self.schedulingQueue queueBlock: ^{
            [self respondToOperationFinished:operation forQueuedObject:object withResult:result];
        }];
    }];
}

- (BOOL) shouldStartAnotherOperation {
    return  self.processing &&
            ![self.errorStrategy operationQueueWillHalt:self] &&
                _activeQueue.count < self.maxConcurrentOperations &&
                _objectQueue.count > 0;
}

- (BOOL) shouldFinish {
    return  _activeQueue.count == 0 &&
            (_objectQueue.count == 0 || [self.errorStrategy operationQueueWillHalt:self]);
}

- (void) respondToProcessQueueEvent {
    FLAssertWithComment(self.maxConcurrentOperations > 0, @"zero max concurrent operations");
    FLTrace(@"max connections: %d", self.maxConcurrentOperations);

    while([self shouldStartAnotherOperation]) {
        [self startOperationForObject:[_objectQueue removeFirstObject_fl]];
    }

    if([self shouldFinish]) {

        id result = [self.errorStrategy errorResult];
        if(!result) {
            result = FLSuccessfulResult;
        }

        [self setFinishedWithResult:result];
    }

}


@end



@implementation FLBatchOperationQueue : FLOperationQueue
static NSInteger s_threadCount = FLQueueableAsyncOperationQueueOperationDefaultMaxConcurrentOperations;

- (id) init {	
	self = [super init];
	if(self) {
		self.maxConcurrentOperations = 0;
	}
	return self;
}

- (void) setMaxConcurrentOperations:(UInt32)maxConcurrentOperations {
    [super setMaxConcurrentOperations:maxConcurrentOperations];

    if(self.processing) {
        [self processQueue];
    }
}

- (UInt32) maxConcurrentOperations {
    UInt32 max = [super maxConcurrentOperations];
    if(!max) {
        max = [FLBatchOperationQueue defaultConnectionLimit];
    }
    return max;
}

+ (void) setDefaultConnectionLimit:(UInt32) threadCount {
    FLAtomicSetInteger(s_threadCount, threadCount);
}

+ (UInt32) defaultConnectionLimit {
    return FLAtomicGetInteger(s_threadCount);
}

@end
