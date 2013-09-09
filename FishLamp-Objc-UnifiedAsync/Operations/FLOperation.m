//
//  FLOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/29/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperation.h"
#import "FLAsyncInitiator.h"
#import "FLAsyncQueue.h"
#import "FLFinisher.h"
#import "NSError+FLFailedResult.h"
#import "FLSuccessfulResult.h"
#import "FLPromise.h"

@interface FLOperationFinisher : FLFinisher {
@private
    __unsafe_unretained FLOperation* _operation;
}
@property (readwrite, assign, nonatomic) FLOperation* operation;

- (id) initWithOperation:(FLOperation*) operation;

@end

@interface FLOperationAsyncInitiator : FLAsyncInitiator {
@private
    FLOperation* _operation;
}

@property (readonly, strong) FLOperation* operation;

+ (id) operationEventWithDelay:(NSTimeInterval) timeInterval operation:(FLOperation*) operation;
@end

@interface FLOperation ()
@property (readwrite, assign) NSInteger childCount;
@property (readwrite, assign, getter=wasCancelled) BOOL cancelled;
@property (readwrite, strong) FLFinisher* finisher; 
@property (readwrite, assign) id<FLAsyncQueue> asyncQueue;

- (void) finisherWillFinish:(FLOperationFinisher*) finisher
                withResult:(FLPromisedResult) result;

- (void) finisherDidFinish:(FLOperationFinisher*) finisher
                withResult:(FLPromisedResult) result;

@end


@implementation FLOperationFinisher

@synthesize operation = _operation;

- (id) initWithOperation:(FLOperation*) operation {
	self = [super init];
	if(self) {
		_operation = operation;
	}
	return self;
}

- (void) willFinishWithResult:(id)result {
    [_operation finisherWillFinish:self withResult:result];
}

- (void) didFinishWithResult:(id)result {
    [_operation finisherDidFinish:self withResult:result];
}


@end


@implementation FLOperation

@synthesize asyncQueue = _asyncQueue;
@synthesize identifier = _identifier;
@synthesize storageService = _storageService;
@synthesize cancelled = _cancelled;
@synthesize finisher = _finisher;
@synthesize childCount = _childCount;

- (id) init {
    self = [super init];
    if(self) {
  		static int32_t s_counter = 0;
        _identifier = [[NSNumber alloc] initWithInt:FLAtomicIncrement32(s_counter)];
        _finisher = [[FLOperationFinisher alloc] initWithOperation:self];
    }
    return self;
}

- (void) dealloc {
    _finisher.operation = nil;

#if FL_MRC
    [_identifier release];
    [_storageService release];
	[_finisher release];
	[super dealloc];
#endif
}

- (FLFinisher*) willStartInQueue:(id<FLAsyncQueue>) asyncQueue {
    return self.finisher;
}

- (void) startInQueue:(id<FLAsyncQueue>) asyncQueue {
    self.asyncQueue = asyncQueue;
    [self startOperation];
    [self.listeners notify:@selector(operationWillBegin:) withObject:self];
}

- (FLPromisedResult) runSynchronouslyInQueue:(id<FLAsyncQueue>) asyncQueue {
    self.asyncQueue = asyncQueue;
    return [self runSynchronously];
}

- (FLPromisedResult) runSynchronously {
    FLPromise* promise = [self.finisher addPromise];
    [self startInQueue:self.asyncQueue];
    return [promise waitUntilFinished];
}

- (void) startOperation {
    FLLog(@"%@ operation did nothing, you must override startOperation.", NSStringFromClass([self class]));
    [self setFinished];
}

- (void) requestCancel {
    self.cancelled = YES;
    NSArray* children = nil;

    @synchronized(self) {
        children = FLCopyWithAutorelease(_children);
    }

    for(FLOperation* operation in children) {
        [operation requestCancel];
    }
}

- (void) willRunChildOperation:(FLOperation*) operation {

    @synchronized(self) {
        if(!_children) {
            _children = [[NSMutableArray alloc] init];
        }

        [_children addObject:operation];
        [operation.listeners addListener:self];
        self.childCount++;
    }

}

- (void) didRunChildOperation:(FLOperation*) operation {
    @synchronized(self) {
        [operation.listeners removeListener:self];
        [_children removeObject:operation];
        self.childCount--;
    }
}

- (FLPromisedResult) runChildSynchronously:(FLOperation*) operation {

    FLAssertNotNilWithComment(self.asyncQueue, @"parent (%@) should be run in an async queue", [self description]);

    FLAssertNotNilWithComment(operation, @"child operation is nil");

    [self willRunChildOperation:operation];
    
    FLPromisedResult result = nil;
    @try {
        result = [self.asyncQueue runSynchronously:operation];
    }
    @catch(NSException* ex) {
        result = ex.error;
    }

    FLAssertNotNilWithComment(result, @"result should not be nil");
    
    [self didRunChildOperation:operation];
        
    return result;
}

- (FLPromise*) runChildAsynchronously:(FLOperation*) operation 
                           completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNilWithComment(self.asyncQueue, @"parent (%@) should be run in an async queue", [self description]);

    [self willRunChildOperation:operation];

    FLPrepareBlockForFutureUse(completionOrNil);

    return [self.asyncQueue queueObject:operation
                             completion:^(FLPromisedResult result) {

        [self didRunChildOperation:operation];
        
        if(completionOrNil) {
            completionOrNil(result);
        }
    }];
}

- (FLPromise*) runChildAsynchronously:(FLOperation*) operation {
    return [self runChildAsynchronously:operation completion:nil];
}

- (void) abortIfCancelled {
    if(self.wasCancelled) {
        FLThrowError([NSError cancelError]);
    }
}

- (void) didFinishWithResult:(FLPromisedResult) result {
}

- (void) finisherWillFinish:(FLOperationFinisher*) finisher
                 withResult:(FLPromisedResult) result {

    FLAssertWithComment(self.childCount == 0, @"finishing operation with %ld children", (long) self.childCount);

    [self didFinishWithResult:result];
}

- (void) finisherDidFinish:(FLOperationFinisher*) finisher
                withResult:(FLPromisedResult) result {
            
    [self.listeners.notify operationDidFinish:self withResult:result];
    self.asyncQueue = nil;
    self.cancelled = NO;
}

- (void) setFinishedWithResult:(id) result {
    [self.finisher setFinishedWithResult:result];
}

- (void) setFinishedWithFailedResult {
    [self setFinishedWithResult:FLFailureResult];
}

- (void) setFinished {
    [self setFinishedWithResult:FLSuccessfulResult];
}

- (void) setFinishedWithCancel {
    [self setFinishedWithResult:[NSError cancelError]];
}

- (FLAsyncInitiator*) asyncInitiatorForAsyncQueue:(id<FLAsyncQueue>) queue withDelay:(NSTimeInterval) delay {
    return [FLOperationAsyncInitiator operationEventWithDelay:delay operation:self];
}

@end

@implementation FLOperationAsyncInitiator : FLAsyncInitiator

@synthesize operation = _operation;

- (id) init {	
    return [self initWithDelay:0 operation:nil];
}

- (id) initWithDelay:(NSTimeInterval) delay operation:(FLOperation*) operation {
    self = [super initWithDelay:delay];
    if(self) {
        FLAssertNotNil(operation);
        _operation = FLRetain(operation);
    }

    return self;
}

#if FL_MRC
- (void)dealloc {
	[_operation release];
	[super dealloc];
}
#endif

+ (id) operationEventWithDelay:(NSTimeInterval) timeInterval operation:(FLOperation*) operation {
   return FLAutorelease([[[self class] alloc] initWithDelay:timeInterval operation:operation]);
}

- (FLFinisher*) finisher {
    return [self.operation finisher];
}

- (void) startAsyncOperation:(FLFinisher*) finisher inQueue:(id<FLAsyncQueue>) queue {
    [self.operation startInQueue:queue];
}

- (FLPromisedResult) runSynchronousOperation:(FLFinisher*) finisher
                                     inQueue:(id<FLAsyncQueue>) queue {
    return [self.operation runSynchronouslyInQueue:queue];
}
@end




