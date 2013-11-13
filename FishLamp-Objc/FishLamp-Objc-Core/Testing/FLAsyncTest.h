//
//  FLAsyncTest.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@interface FLAsyncTest : NSObject {
@private
    dispatch_semaphore_t _semaphor;
    NSException* _exception;
}

+ (id) asyncTest;

- (void) wait;
- (void) finish;

- (void) verifyAsyncResults:(dispatch_block_t) block;

@end