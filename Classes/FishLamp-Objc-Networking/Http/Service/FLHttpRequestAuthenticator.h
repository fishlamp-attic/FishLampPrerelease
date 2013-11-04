//
//  FLHttpRequestAuthenticator.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLHttpRequest.h"
#import "FishLampAsync.h"

@class FLHttpUser;

@protocol FLHttpRequestAuthenticatorDelegate;

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

@property (readonly, assign, nonatomic) FLOperationContext* operationContext;
@property (readonly, assign, nonatomic) FLHttpUser* httpUser;

@end

@protocol FLHttpRequestAuthenticatorDelegate <NSObject>

- (FLOperationContext*) httpRequestAuthenticatorGetOperationContext:(FLHttpRequestAuthenticator*) context;

- (FLHttpUser*) httpRequestAuthenticatorGetUser:(FLHttpRequestAuthenticator*) service;

- (void) httpRequestAuthenticator:(FLHttpRequestAuthenticator*) authenticator
                didAuthenticateUser:(FLHttpUser*) user;
@end
