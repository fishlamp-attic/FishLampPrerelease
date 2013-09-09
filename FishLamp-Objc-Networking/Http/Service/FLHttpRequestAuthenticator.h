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

@protocol FLHttpRequestAuthenticatorStrategy;

@interface FLHttpRequestAuthenticator : NSObject<FLHttpRequestAuthenticator> {
@private
    id<FLHttpRequestAuthenticatorStrategy> _strategy;
    __unsafe_unretained id _delegate;
}
@property (readwrite, assign, nonatomic) id<FLHttpRequestAuthenticatorDelegate> delegate;

+ (id) httpRequestAuthenticator:(id<FLHttpRequestAuthenticatorStrategy>) strategy;

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion;

@end

@protocol FLHttpRequestAuthenticatorStrategy <NSObject>
- (FLSynchronousOperation*) createAuthenticateUserOperation:(FLHttpUser*) user;

- (void) authenticateHttpRequest:(FLHttpRequest*) request 
           withAuthenticatedUser:(FLHttpUser*) user;

@optional
- (BOOL) credentialsNeedAuthentication:(FLHttpUser*) user;
@end

@protocol FLHttpRequestAuthenticatorDelegate <NSObject>

//- (FLOperationContext*) httpRequestAuthenticationServiceGetOperationContext:(FLHttpRequestAuthenticator*) service;

- (FLHttpUser*) httpRequestAuthenticationServiceGetUser:(FLHttpRequestAuthenticator*) service;

- (void) httpRequestAuthenticationService:(FLHttpRequestAuthenticator*) service
               didAuthenticateUser:(FLHttpUser*) user;

@optional 
- (void) httpRequestAuthenticationServiceDidOpen:(FLHttpRequestAuthenticator*) service;
- (void) httpRequestAuthenticationServiceDidClose:(FLHttpRequestAuthenticator*) service;

@end
