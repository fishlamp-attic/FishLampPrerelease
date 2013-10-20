//
//  FLHttpRequestAuthenticator.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLHttpRequestAuthenticator.h"
#import "FishLampAsync.h"
#import "FLHttpRequest.h"
#import "FLReachableNetwork.h"
#import "FLHttpUser.h"

@interface FLHttpRequestAuthenticator ()
@property (readonly, strong) FLFifoAsyncQueue* asyncQueue;
@end

@implementation FLHttpRequestAuthenticator

@synthesize asyncQueue = _asyncQueue;
@synthesize delegate = _delegate;

- (id) init {
	self = [super init];
	if(self) {
        _asyncQueue = [[FLFifoAsyncQueue alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_asyncQueue release];
    [super dealloc];
}
#endif

- (FLHttpUser*) httpUser {
    return [self.delegate httpRequestAuthenticatorGetUser:self];
}

- (FLOperationContext*) operationContext {
    return [self.delegate httpRequestAuthenticatorGetOperationContext:self];
}

- (BOOL) credentialsNeedAuthentication:(FLHttpUser*) user {
    return NO;
}

- (BOOL) shouldAuthenticateUser:(FLHttpUser*) user {

	FLAssertIsNotNil(user);
	
    if(!user.isLoginAuthenticated) {
        return YES;
    }

#if TEST_CACHE_EXPIRE
	userLogin.authTokenLastUpdateTimeValue = userLogin.authTokenLastUpdateTimeValue - (_timeoutInterval*2);
#endif
    
    if(user.authenticationHasExpired) {
    
        if([FLReachableNetwork instance].isReachable) {
            FLTrace(@"Login expired, will reauthenticate %@", user.userLogin.userName);
            [user setLoginUnathenticated];
            return YES;
        }
        else {
            // don't want to reauthenticate if we're offline.
            return NO;
        }
    }

    return [self credentialsNeedAuthentication:user];
}

- (FLPromisedResult) authenticateUser:(FLHttpUser*) user {
    return user;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) request 
           withAuthenticatedUser:(FLHttpUser*) user {
}

- (FLHttpUser*) synchronouslyAuthenticateUser:(FLHttpUser*) user {
    [user resetAuthenticationTimestamp];

    FLPromisedResult result = [self authenticateUser:user];
    FLThrowIfError(result);

    FLHttpUser* authenticatedUser = [FLHttpUser fromPromisedResult:result];
    [authenticatedUser touchAuthenticationTimestamp];
    [self.delegate httpRequestAuthenticator:self didAuthenticateUser:user];

    return authenticatedUser;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) request {

    __block FLHttpUser* user = FLRetain(self.httpUser);
    FLAssertNotNil(user); 

    __block FLHttpRequestAuthenticator* myself = FLRetain(self);

    [_asyncQueue runBlockSynchronously:^{

        FLHttpUser* authenticatedUser = user;
        if([myself shouldAuthenticateUser:user]) {
            user = FLRetainWithAutorelease([myself synchronouslyAuthenticateUser:user]);
        }

        [myself authenticateHttpRequest:request withAuthenticatedUser:user];

        [self.delegate httpRequestAuthenticator:self didAuthenticateUser:user];

        FLReleaseWithNil(myself);
        FLReleaseWithNil(user);
    }];
}

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion {

    __block FLHttpUser* user = FLRetain(self.httpUser);
    __block FLHttpRequestAuthenticator* myself = FLRetain(self);
    FLAssertNotNil(user); 

    return [self.asyncQueue queueBlock:^{

        FLTrace(@"started auth");

        FLHttpUser* authenticatedUser = user;
        if([myself shouldAuthenticateUser:user]) {
            authenticatedUser = FLRetainWithAutorelease([myself synchronouslyAuthenticateUser:user]);
        }

        [myself.delegate httpRequestAuthenticator:self didAuthenticateUser:user];

        FLReleaseWithNil(user);
        FLReleaseWithNil(myself);
    } 
    completion:completion];
}

@end