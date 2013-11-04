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
@synthesize cancelled = _cancelled;
@synthesize finisher = _finisher;

- (id) init {
    self = [super init];
    if(self) {
//        self.asyncQueue = [FLDispatchQueue defaultQueue];
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
	[_finisher release];
	[super dealloc];
#endif
}

- (FLPromisedResult) runSynchronously {

    FLLog(@"%@ operation did nothing, you must override startOperation or runSynchronously.", NSStringFromClass([self class]));

    return FLSuccessfulResult;
}

- (FLPromisedResult) runSynchronouslyInQueue:(id<FLAsyncQueue>) asyncQueue {
    FLAssertNotNil(asyncQueue);

    FLAssertNotNil(self.finisher);
    [self startInQueue:asyncQueue];

    // if the operation is implemented as synchronous, the finisher will be done already, else it will block on the GCD semaphor in the finisher.
    FLPromisedResult result = [self.finisher waitUntilFinished];
    FLAssertNotNil(result);
    return result;

}

- (void) startOperation {

    id result = nil;

    @try {
        [self abortIfNeeded];
        result = [self runSynchronously];
    }
    @catch(NSException* ex) {
        result = ex.error;
        FLAssertNotNil(result);
    }
    
    if(self.wasCancelled) {
        result = [NSError cancelError];
    }
    
    if(!result) {
        result = [NSError failedResultError];
    }
    
    [self setFinishedWithResult:result];
}

- (FLFinisher*) willStartInQueue:(id<FLAsyncQueue>) asyncQueue {
    FLAssertNotNil(asyncQueue);
    return self.finisher;
}


- (void) startInQueue:(id<FLAsyncQueue>) asyncQueue {
    FLAssertNotNil(asyncQueue);

//    self.asyncQueue = asyncQueue;

    [self willStartOperation];
    [self startOperation];
    [self notify:@selector(operationWillBegin:) withObject:self];
}

- (void) abortIfNeeded {
    if(self.abortNeeded) {
        FLThrowError([NSError cancelError]);
    }
}

- (BOOL) abortNeeded {
    return self.wasCancelled;
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


- (void) willStartOperation {
}


- (void) wasAddedToContext:(FLOperationContext*) context {
    FLAssertNotNil(context);
    if(_context != context) {
        _context = context;
    }
}

- (void) wasRemovedFromContext:(FLOperationContext*) context {
    FLAssertNotNil(context);

    if(_context == context) {
        _context = nil;
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
