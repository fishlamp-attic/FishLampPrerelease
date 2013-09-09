//
//  FLSynchronousOperation.h
//  FishLamp
//
//	Created by Mike Fullerton on 8/28/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLOperation.h"

@interface FLSynchronousOperation : FLOperation {
@private
}

+ (id) synchronousOperation;

/// @brief Required override point
- (FLPromisedResult) performSynchronously;

// this will raise an abort exception if runState has been signaled as finished.
// only for subclasses to call while executing operation.
- (void) abortIfNeeded;
- (BOOL) abortNeeded;

@end

#if EXPERIMENTAL

@interface FLBatchSynchronousOperation : FLSynchronousOperation {
@private
    SEL _batchAction;
    __unsafe_unretained id _batchObserver;
}
- (void) setBatchObserver:(id) observer action:(SEL) action;


// for subclassses
//
//- (void) sendIterationObservation:(FLPromisedResult) result;

@end


#endif