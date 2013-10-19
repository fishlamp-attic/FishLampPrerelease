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

NSString* const FLWorkerContextStarting = @"FLWorkerContextStarting";
NSString* const FLWorkerContextFinished = @"FLWorkerContextFinished";

NSString* const FLWorkerContextClosed = @"FLWorkerContextClosed";
NSString* const FLWorkerContextOpened = @"FLWorkerContextOpened"; 

#define OperationInQueue(op) op

typedef void (^FLOperationVisitor)(id operation, BOOL* stop);

@interface FLOperationContext ()
@property (readwrite, assign, getter=isContextOpen) BOOL contextOpen; 
@property (readwrite, assign) NSUInteger contextID;

- (void) queueOperation:(FLOperation*) operation;
- (void) removeOperation:(FLOperation*) operation;
- (void) visitOperations:(FLOperationVisitor) visitor;

@end

@interface FLOperation (Protected)
- (FLPromisedResult) runSynchronously;
- (FLPromise*) runAsynchronously:(fl_completion_block_t) completionOrNil;
@end


@implementation FLOperationContext
@synthesize contextOpen = _contextOpen;
@synthesize contextID = _contextID;

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

    self.contextID++;
    
    [self visitOperations:^(id operation, BOOL *stop) {
        [operation contextDidOpen];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FLWorkerContextOpened object:self];
    });
}

- (void) closeContext {
    [self visitOperations:^(id operation, BOOL *stop) {
        [operation contextDidClose];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FLWorkerContextClosed object:self];
    });
}

- (void) didAddOperation:(FLOperation*) operation {
}

- (void) didRemoveOperation:(FLOperation*) operation {
}

- (void) queueOperation:(FLOperation*) operation  {
    
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

    BOOL didStop = NO;
    
    @synchronized(self) {
    
#if TRACE
        FLLog(@"Operation removed from context: %@", [operation description]);
#endif

        FLRetainWithAutorelease(operation);

        [_operations removeObject:operation];
        if(operation.context == self) {
            [operation wasRemovedFromContext:self];
        }
    }
    
    [self didRemoveOperation:operation];
}

- (FLPromise*) beginOperation:(FLOperation*) operation
                   completion:(fl_completion_block_t) completion {

    operation.context = self;
    return [operation runAsynchronously:completion];
}

- (FLPromisedResult) runOperation:(FLOperation*) operation {
    operation.context = self;
    return [operation runSynchronously];
}

   
@end



