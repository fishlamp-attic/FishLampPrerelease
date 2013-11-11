//
//  FLAsyncTest.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncTest.h"

@interface FLAsyncTest ()
@property (readwrite, copy, nonatomic) NSException* exception;
@end

@implementation FLAsyncTest

@synthesize exception = _exception;

- (id) init {	
	self = [super init];
	if(self) {
        _semaphor = dispatch_semaphore_create(0);
    }
	return self;
}

+ (id) asyncTest {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
    [_exception release];
    FLDispatchRelease(_semaphor);
	[super dealloc];
}
#endif

- (void) verifyAsyncResults:(dispatch_block_t) block {

    @try {
        if(block) {
            block();
        }
    }
    @catch(NSException* ex) {
        self.exception = ex;
    }

    dispatch_semaphore_signal(_semaphor);

}

- (void) wait {
    dispatch_semaphore_wait(_semaphor, DISPATCH_TIME_FOREVER); \
}

- (void) finish {
    if(self.exception) {
        @throw self.exception;
    }
}


@end