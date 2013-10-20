
//
//  FLSynchronousOperation.m
//  FishLamp
//
//	Created by Mike Fullerton on 8/28/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSynchronousOperation.h"
#import "FLFinisher.h"
#import "FLAsyncQueue.h"
#import "FLSuccessfulResult.h"
#import "NSError+FLFailedResult.h"

@interface FLSynchronousOperation ()
@end

@implementation FLSynchronousOperation

+ (id) synchronousOperation {
	return FLAutorelease([[[self class] alloc] init]);
}

- (FLPromisedResult) performSynchronously {
    FLAssertionFailedWithComment(@"override this");
    return FLSuccessfulResult;
}

- (void) abortIfNeeded {
    if(self.abortNeeded) {
        FLThrowError([NSError cancelError]);
    }
}

- (BOOL) abortNeeded {
    return self.wasCancelled;
}

- (void) startOperation {
    [self runSynchronously];
}

- (FLPromisedResult) runSynchronously {

    id result = nil;

    @try {
        [self abortIfNeeded];
        result = [self performSynchronously];
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
    
    [self.finisher setFinishedWithResult:result];

    return result;
}

- (FLPromise*) runChildAsynchronously:(FLOperation*) operation 
                           completion:(fl_completion_block_t) completionOrNil {

    FLAssertionFailedWithComment(@"use runChildSynchronously only in synchronous operation");

    return nil;
}

@end

#if EXPERIMENTAL
@implementation FLBatchSynchronousOperation
//- (void) sendIterationObservation:(FLPromisedResult) result {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        FLPerformSelector1(_batchObserver, _batchAction, result);
//    });
//}

- (void) setBatchObserver:(id) observer action:(SEL) action {
    _batchObserver = observer;
    _batchAction = action;
}

@end


#endif
