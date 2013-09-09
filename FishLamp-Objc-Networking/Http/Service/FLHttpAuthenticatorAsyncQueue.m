//
//  FLHttpAuthenticatorAsyncQueue.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLHttpAuthenticatorAsyncQueue.h"
#import "FLHttpRequestAuthenticator.h"
#import "FLDispatchQueue.h"
#import "FLQueueableAsyncOperation.h"
#import "FLHttpRequest.h"

@interface FLHttpAuthenticatorAsyncQueue ()
@property (readonly, strong) id<FLHttpRequestAuthenticator> authenticator;
@property (readonly, strong) FLFifoAsyncQueue* asyncQueue;
@end

@implementation FLHttpAuthenticatorAsyncQueue

@synthesize asyncQueue = _asyncQueue;
@synthesize authenticator = _authenticator;

- (id) initWithAuthenticator:(id<FLHttpRequestAuthenticator>) authenticator
               withNextQueue:(id<FLAsyncQueue>) nextQueue {

    FLAssertNotNil(authenticator);

	self = [super initWithNextQueue:nextQueue];
	if(self) {
        _asyncQueue = [[FLFifoAsyncQueue alloc] init];
        _authenticator = FLRetain(authenticator);
	}
	return self;
}

+ (id) httpAuthenticatorAsyncQueue:(id<FLHttpRequestAuthenticator>) authenticator {
    return FLAutorelease([[[self class] alloc] initWithAuthenticator:authenticator withNextQueue:nil]);
}

- (id) init {
    return [self initWithAuthenticator:nil withNextQueue:nil];
}

+ (id) httpAuthenticatorAsyncQueue:(id<FLHttpRequestAuthenticator>) strategy withNextQueue:(id<FLAsyncQueue>) nextQueue{
    return FLAutorelease([[[self class] alloc] initWithAuthenticator:strategy withNextQueue:nextQueue]);
}

#if FL_MRC
- (void) dealloc {
    [_authenticator release];
    [_asyncQueue release];
    [super dealloc];
}
#endif

- (FLPromise*) queueObject:(id<FLQueueableAsyncOperation>) object
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil {

    if([object respondsToSelector:@selector(setHttpRequestAuthenticator:)]) {
        [((id)object) setHttpRequestAuthenticator:self.authenticator];
    }

    return [super queueObject:object withDelay:delay completion:completionOrNil];
}

@end
