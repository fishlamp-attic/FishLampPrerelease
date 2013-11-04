//
//  FLOperationContext.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationContext.h"
#import "FLAsyncQueue.h"
#import "FishLampAsync.h"
#import "FLDispatchQueue.h"
#import "FLAsyncQueue.h"
#import "FLOperation.h"

//#define TRACE 1

#define OperationInQueue(op) op

typedef void (^FLOperationVisitor)(id operation, BOOL* stop);

@interface FLOperationContext ()
@property (readwrite, assign, getter=isContextOpen) BOOL contextOpen; 

- (void) queueOperation:(FLOperation*) operation;
- (void) removeOperation:(FLOperation*) operation;
- (void) visitOperations:(FLOperationVisitor) visitor;

@end

@interface FLOperation (Protected)
- (void) setContext:(id) context;
@end

@implementation FLOperationContext
@synthesize contextOpen = _contextOpen;

- (id) init {
    self = [super init];
    if(self) {
        _operations = [[NSMutableSet alloc] init];
        _contextOpen = YES;
    }
    
    return self;
}

- (void) dealloc {
#if FL_MRC
    [_operations release];
    [super dealloc];
#endif
}

+ (id) operationContext {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) visitOperations:(FLOperationVisitor) visitor {

    FLAssertNotNil(visitor);

    @synchronized(self) {
        BOOL stop = NO;
        for(id operation in _operations) {
            visitor(OperationInQueue(operation), &stop);
            
            if(stop) {
                break;
            }
        }
    }
    
}

- (void) requestCancel {

    @synchronized(self) {

        // the reason we need a copy is because the set is likely going
        // to change out from under us as we iterate it and cancel the operations
        // (which then remove themselves from the context).
        NSSet* copy = FLCopyWithAutorelease(_operations);
        for(id operation in copy) {
#if TRACE
            FLLog(@"cancelled %@", [operation description]);
#endif
        
            FLPerformSelector0(OperationInQueue(operation), @selector(requestCancel));
        }
    }
}

- (void) openContext {
    self.contextOpen = YES;
}

- (void) closeContext {
    [self requestCancel];
    self.contextOpen = NO;
}

- (void) didAddOperation:(FLOperation*) operation {
}

- (void) didRemoveOperation:(FLOperation*) operation {
}

- (void) queueOperation:(FLOperation*) operation  {

    FLAssertNotNil(operation);

    @synchronized(self) {
    
#if TRACE
        FLLog(@"Operation added to context: %@", [operation description]);
#endif

       
        [_operations addObject:operation];
         
        FLOperationContext* oldContext = operation.context;
        if(oldContext && oldContext != self) {
            [operation.context removeOperation:operation];
        }
        [operation wasAddedToContext:self];
    }

    [self didAddOperation:operation];

    if(!self.isContextOpen) {
        [operation requestCancel];
    }
}

- (void) removeOperation:(FLOperation*) operation {

    FLAssertNotNil(operation);

    @synchronized(self) {
    
#if TRACE
        FLLog(@"Operation removed from context: %@", [operation description]);
#endif

        [_operations removeObject:FLRetainWithAutorelease(operation)];
        if(operation.context == self) {
            [operation wasRemovedFromContext:self];
        }
    }
    
    [self didRemoveOperation:operation];
}

- (id<FLAsyncQueue>) asyncQueueForOperation:(FLOperation*) operation {
    return FLDefaultQueue;
}

- (FLPromise*) beginOperation:(FLOperation*) operation
                   completion:(fl_completion_block_t) completion {

    FLAssertNotNil(operation);
    [self queueOperation:operation];

// TODO: provide way to specify queue
    return [[self asyncQueueForOperation:operation] queueObject:operation completion:completion];
}

- (FLPromisedResult) runOperation:(FLOperation*) operation {

    FLAssertNotNil(operation);

    [self queueOperation:operation];

// TODO: provide way to specify queue
    return [[self asyncQueueForOperation:operation] runSynchronously:operation];
}

@end



