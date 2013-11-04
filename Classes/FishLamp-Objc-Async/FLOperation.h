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
#import "FLFinishable.h"
#import "FLBroadcaster.h"
#import "FLSuccessfulResult.h"
#import "NSError+FLFailedResult.h"
#import "FLAsyncQueue.h"

@class FLOperationContext;
@class FLOperationFinisher;

@interface FLOperation : FLBroadcaster<FLFinishable, FLQueueableAsyncOperation> {
@private
    FLOperationFinisher* _finisher;
    BOOL _cancelled;
    __unsafe_unretained FLOperationContext* _context;
}

/*!
 *  Operations must run in a context. See FLOpertionContext.
 */
@property (readonly, assign, nonatomic) id context;

/*!
 *  return YES is was cancelled
 */
@property (readonly, assign, getter=wasCancelled) BOOL cancelled;

/*!
 *  Return the finisher for this operation
 *  
 *  @return the finisher
 */
@property (readonly, strong) FLFinisher* finisher;

/*!
 *  someone has cancelled you. stop, and be quick about it.
 */
- (void) requestCancel;


//
// Override either startOperation or runSynchronously.
//

/*!
 *  Override this for a async operation. You are responsible for calling setFinished (See FLFinishable)
 */
- (void) startOperation;

/*!
 *  Override this for a synchronous operation.
 *  
 *  @return a result
 */
- (FLPromisedResult) runSynchronously;

@end

@interface FLOperation (OptionalOverrides)

/*!
 *  Optional override. This is called immediately before startOperation or runSynchronously.
 */
- (void) willStartOperation;

/*!
 *  Optional override. This is called after the finisher fufills promises, etc..
 *  
 *  @param result the result the operation will be finishing with.
 */
- (void) didFinishWithResult:(FLPromisedResult) result;

/*!
 *  Throws a cancel error if this operation has been cancelled. Careful with this, if you're executing an async operation in a thread be mindful of who is catching (handled fine if you're using an FLAsyncQueue).
 */
- (void) abortIfCancelled;

/*!
 *  Called when this operation is added to a context.
 *  
 *  @param context the context
 */
- (void) wasAddedToContext:(FLOperationContext*) context;

/*!
 *  Called when this operation is removed from a context
 *  
 *  @param context the context
 */
- (void) wasRemovedFromContext:(FLOperationContext*) context;

@end

/*!
 *  Since a FLOperation is FLBroadcaster, it sends these events to its listeners.
 */
@protocol FLOperationEvents <NSObject>
@optional

/*!
 *  Called with the operation is about to start.
 *  
 *  @param operation the operation sending the message
 */
- (void) operationWillBegin:(id) operation;

/*!
 *  The operation has completed.
 *  
 *  @param operation the operation that has finished
 *  @param result    the results of the operation.
 */
- (void) operationDidFinish:(id) operation withResult:(FLPromisedResult) result;
@end

#define FLDeclareExpectedResult(__CLASS_NAME__) \
    + (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result; \
    - (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result

#define FLSynthesizeExpectedResult(__CLASS_NAME__) \
    + (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result { \
        FLAssertNotNil(result); \
        return [__CLASS_NAME__ fromPromisedResult:result]; \
    } \
    - (__CLASS_NAME__*) objectFromResult:(FLPromisedResult) result { \
        FLAssertNotNil(result); \
        return [__CLASS_NAME__ fromPromisedResult:result]; \
    }