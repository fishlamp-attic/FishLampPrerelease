//
//  FLHttpRequestAuthenticator.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FishLampAsync.h"

@class FLHttpRequest;
@class FLHttpUser;
@class FLSynchronousOperation;
@protocol FLHttpRequestAuthenticatorDelegate;

@protocol FLHttpRequestAuthenticator <NSObject>
//// this needs to be synchronous for scheduling reasons amoung concurrent requests.
- (void) authenticateHttpRequest:(FLHttpRequest*) request;
@end

@interface FLHttpRequestAuthenticator : NSObject<FLHttpRequestAuthenticator> {
@private
    FLFifoAsyncQueue* _asyncQueue;
    __unsafe_unretained id _delegate;
}

@property (readwrite, assign, nonatomic) id<FLHttpRequestAuthenticatorDelegate> delegate;

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion;

// required overrides
- (FLPromisedResult) authenticateUser:(FLHttpUser*) user;

- (void) authenticateHttpRequest:(FLHttpRequest*) request 
           withAuthenticatedUser:(FLHttpUser*) user;

- (BOOL) credentialsNeedAuthentication:(FLHttpUser*) user;

@end

@protocol FLHttpRequestAuthenticatorDelegate <NSObject>
- (FLHttpUser*) httpRequestAuthenticatorGetUser:(FLHttpRequestAuthenticator*) service;

- (void) httpRequestAuthenticator:(FLHttpRequestAuthenticator*) authenticator
                didAuthenticateUser:(FLHttpUser*) user;
@end
