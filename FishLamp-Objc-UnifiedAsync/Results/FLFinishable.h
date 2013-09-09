//
//  FLFinishable.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLPromisedResult.h"

@protocol FLFinishable <NSObject>

// notify finish with one of these

- (void) setFinishedWithResult:(FLPromisedResult) result;
// convienience methods - these call setFinishedWithResult:error
- (void) setFinished;
- (void) setFinishedWithFailedResult;
- (void) setFinishedWithCancel;

@end
