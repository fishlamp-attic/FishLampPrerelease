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
#import "FLOperationContext.h"
#import "FLDispatchQueue.h"

@interface FLOperation ()
@property (readwrite, assign, getter=wasCancelled) BOOL cancelled;
@property (readwrite, strong) FLFinisher* finisher; 
//@property (readwrite, assign) id<FLAsyncQueue> asyncQueue;

- (void) finisherDidFinish:(FLFinisher*) finisher
                withResult:(FLPromisedResult) resultOrNil;

@end

@interface FLOperationContext (Protected)
- (void) queueOperation:(FLOperation*) operation;
- (void) removeOperation:(FLOperation*) operation;
@end


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

@implementation FLOperationFinisher

@synthesize operation = _operation;

- (id) initWithOperation:(FLOperation*) operation {
	self = [super init];
	if(self) {
		_operation = operation;
	}
	return self;
}

- (void) didFinishWithResult:(id)result {
    [_operation finisherDidFinish:self withResult:result];
}
@end

@implementation FLOperation

@synthesize context = _context;
@synthesize contextID = _contextID;
//@synthesize asyncQueue = _asyncQueue;
@synthesize identifier = _identifier;
@synthesize cancelled = _cancelled;
@synthesize finisher = _finisher;

- (id) init {
    self = [super init];
    if(self) {
//        self.asyncQueue = [FLDispatchQueue defaultQueue];
  		static int32_t s_counter = 0;
        _identifier = [[NSNumber alloc] initWithInt:FLAtomicIncrement32(s_counter)];
        _finisher = [[FLOperationFinisher alloc] initWithOperation:self];
    }
    return self;
}

- (void) dealloc {
    if(_context) {
        FLOperationContext* context = _context;
        _context = nil;
        [context removeOperation:self];
        
        FLLog(@"Operation last ditch removal from context: %@", [self description]);
    }
    _finisher.operation = nil;

#if FL_MRC
    [_identifier release];
    [_asyncQueue release];
	[_finisher release];
	[super dealloc];
#endif
}

- (FLFinisher*) willStartInQueue:(id<FLAsyncQueue>) asyncQueue {
    FLAssertNotNil(asyncQueue);
//    self.asyncQueue = asyncQueue;
    return self.finisher;
}

- (void) willStartOperation {
}

//- (id<FLAsyncQueue>) asyncQueue {
//    if(!_)
//    [self queueOperation:operation];
//
//}

- (void) startInQueue:(id<FLAsyncQueue>) asyncQueue {
    FLAssertNotNil(asyncQueue);

//    self.asyncQueue = asyncQueue;

    [self willStartOperation];
    [self startOperation];
    [self notify:@selector(operationWillBegin:) withObject:self];
}

- (FLPromisedResult) runSynchronouslyInQueue:(id<FLAsyncQueue>) asyncQueue {
    FLAssertNotNil(asyncQueue);

//    self.asyncQueue = asyncQueue;
//    return [self runSynchronously];

    FLAssertNotNil(self.finisher);
    [self startInQueue:asyncQueue];

    FLPromisedResult result = [self.finisher waitUntilFinished];
    FLAssertNotNil(result);
    return result;

}

/*
- (FLPromisedResult) runSynchronously {
    FLAssertNotNil(self.finisher);
    FLAssertNotNil(self.asyncQueue);

    FLPromise* promise = [self.finisher addPromise];
    [self startInQueue:self.asyncQueue];

    FLPromisedResult result = [promise waitUntilFinished];
    FLAssertNotNil(result);
    return result;
}
*/

- (void) startOperation {
    FLLog(@"%@ operation did nothing, you must override startOperation.", NSStringFromClass([self class]));
    [self setFinished];
}

- (void) requestCancel {
    self.cancelled = YES;
}

- (void) setContext:(FLOperationContext*) context {
    if(context) {
        [context queueOperation:self];
    }
    else {
        [self.context removeOperation:self];
    }
}

- (void) wasAddedToContext:(FLOperationContext*) context {
    FLAssertNotNil(context);
    if(_context != context) {
        _context = context;
        _contextID = [context contextID];
    }
}

- (void) contextDidClose {
    [self requestCancel];
    self.context = nil;
}

- (void) contextDidOpen {

}

- (void) contextDidCancel {
    [self requestCancel];
    self.context = nil;
}

- (void) wasRemovedFromContext:(FLOperationContext*) context {
    FLAssertNotNil(context);

    if(_context == context) {
        _context = nil;
        _contextID = 0;
    }
}

- (id) objectFromResult:(id) result {
    FLAssertNotNil(result);
    FLThrowIfError(result);
    return result;
}

- (void) abortIfCancelled {
    if(self.wasCancelled) {
        FLThrowCancel();
    }
}

- (void) finisherDidFinish:(FLFinisher*) finisher
                withResult:(FLPromisedResult) result {

    FLAssertNotNil(finisher);
    FLAssertNotNil(result);

    [self didFinishWithResult:result];
    [self notify:@selector(operationDidFinish:withResult:) withObject:self withObject:result];
    self.context = nil;
    self.cancelled = NO;
}

- (void) didFinishWithResult:(FLPromisedResult) result {
}

- (void) setFinishedWithResult:(id) result {
    FLAssertNotNil(result);

    [self.finisher setFinishedWithResult:result];
}

- (void) setFinishedWithFailedResult {
    [self setFinishedWithResult:FLFailedResult];
}

- (void) setFinished {
    [self setFinishedWithResult:FLSuccessfulResult];
}

- (void) setFinishedWithCancel {
    [self setFinishedWithResult:[NSError cancelError]];
}

- (FLAsyncInitiator*) asyncInitiatorForAsyncQueue:(id<FLAsyncQueue>) queue withDelay:(NSTimeInterval) delay {
    FLAssertNotNil(queue);

    return [FLOperationAsyncInitiator operationEventWithDelay:delay operation:self];
}

@end

@implementation FLOperationAsyncInitiator : FLAsyncInitiator

@synthesize operation = _operation;

- (id) init {	
    return [self initWithDelay:0 operation:nil];
}

- (id) initWithDelay:(NSTimeInterval) delay
           operation:(FLOperation*) operation {

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


/*
- (FLPromisedResult) runSynchronously {
    return [[self.asyncQueue queueOperation:self] waitUntilFinished];
}

- (FLPromise*) runAsynchronously:(fl_completion_block_t) completion {
    return [self.asyncQueue queueOperation:self completion:completion];
}

- (FLPromise*) runAsynchronously {
    return [self runAsynchronously:nil];
}

- (FLPromise*) runAsynchronouslyWithObserver:(id) observer {
    [self.observers addObserver:observer];
    return [self runAsynchronously:^(FLPromisedResult result) {
        [FLForegroundQueue queueBlock:^{
            [self removeObserver:observer];
        }];
    }];
}

- (FLPromise*) runAsynchronouslyInContext:(FLOperationContext*) context 
                               completion:(fl_completion_block_t) completionOrNil {
    self.context = context;
    return [self runAsynchronously:completionOrNil];
}
*/

/*
- (void) willRunChildOperation:(FLOperation*) operation {

//    [operation.observers addObserver:[self.observers broadcasterReference]];
    [operation.observers addObserver:self];

    if([operation context] == nil) {
        [operation setContext:self.context];
    }
    if([operation asyncQueue] == nil) {
        [operation setAsyncQueue:self.asyncQueue];
    }

//    if([operation observer] == nil) {
//        [operation setObserver:self.observer];
//    }
}

- (void) didRunChildOperation:(FLOperation*) operation {
//    [operation.observers removeObserver:self.observers];
    [operation.observers removeObserver:self];
}

- (FLPromisedResult) runChildSynchronously:(FLOperation*) operation {

    FLAssertNotNilWithComment(operation, @"child operation is nil");

    [self willRunChildOperation:operation];
    
    FLPromisedResult result = nil;
    @try {
        result = [operation runSynchronously];
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

    [self willRunChildOperation:operation];
    
    if(completionOrNil) {
        completionOrNil = FLCopyWithAutorelease(completionOrNil);
    }
    
    return [operation runAsynchronously:^(FLPromisedResult result) {
        [self didRunChildOperation:operation];
        
        if(completionOrNil) {
            completionOrNil(result);
        }
    }];
}

- (FLPromise*) runChildAsynchronously:(FLOperation*) operation {
    return [self runChildAsynchronously:operation completion:nil];
}
*/

/*
@interface FLOperation (Synchronous)
// run synchronously
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
*/
