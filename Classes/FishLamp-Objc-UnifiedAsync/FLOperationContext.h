//
//  FLOperationContext.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"

@class FLOperation;
@class FLPromise;

@interface FLOperationContext : NSObject {
@private
    NSMutableSet* _operations;
    NSUInteger _contextID;
    BOOL _contextOpen;
}
@property (readonly, assign, getter=isContextOpen) BOOL contextOpen; 

@property (readonly, assign) NSUInteger contextID;

+ (id) operationContext;

/**
 *  Open the context. Context's are open by default.
 */
- (void) openContext;

/**
 *  Close the context. This cancels and removes all the operations. Further operations are cancelled and discarded until the context is opened again.
 */
- (void) closeContext;

/**
 *  Cancel and remove all the current operations.
 */
- (void) requestCancel;          

/**
 *  Begin an Operation.
 *  
 *  @param operation  the operation to run
 *  @param completion the completion block or nil
 *  
 *  @return The promise representing the running operation scope.
 */
- (FLPromise*) beginOperation:(FLOperation*) operation
                   completion:(fl_completion_block_t) completion;

/**
 *  Execute an operation synchronously.
 *  
 *  @param operation the Operation
 *  
 *  @return the Promise result
 */
- (FLPromisedResult) runOperation:(FLOperation*) operation;

@end

@interface FLOperationContext (OptionalOverrides)
- (void) didAddOperation:(FLOperation*) operation;
- (void) didRemoveOperation:(FLOperation*) operation;
@end

