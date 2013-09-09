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
@property (readonly, strong) id<FLHttpRequestAuthenticatorStrategy> strategy;
@end

@implementation FLHttpRequestAuthenticator

@synthesize asyncQueue = _asyncQueue;
@synthesize strategy = _strategy;
@synthesize delegate = _delegate;

- (id) initWithStrategy:(id<FLHttpRequestAuthenticatorStrategy>) strategy {
    FLAssertNotNil(strategy);

	self = [super init];
	if(self) {
        _asyncQueue = [[FLFifoAsyncQueue alloc] init];
        _strategy = FLRetain(strategy);
	}
	return self;
}

- (id) init {
    return [self initWithStrategy:nil];
}

+ (id) httpRequestAuthenticator:(id<FLHttpRequestAuthenticatorStrategy>) strategy {
    return FLAutorelease([[[self class] alloc] initWithStrategy:strategy]);
}


#if FL_MRC
- (void) dealloc {
    [_strategy release];
    [_asyncQueue release];
    [super dealloc];
}
#endif

- (FLHttpUser*) user {
    return [self.delegate httpRequestAuthenticationServiceGetUser:self];
}
       
- (BOOL) credentialsNeedAuthentication:(FLHttpUser*) user {

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

    if([self.strategy respondsToSelector:@selector(credentialsNeedAuthentication:)]) {
        return [self.strategy credentialsNeedAuthentication:user];
    }

    return NO;
}

- (void) authenticateUser:(FLHttpUser*) user {
    [user resetAuthenticationTimestamp];

    FLOperation* authenticateUserOperation = [self.strategy createAuthenticateUserOperation:user];

    FLThrowIfError([authenticateUserOperation runSynchronously]);

    [user touchAuthenticationTimestamp];
    [self.delegate httpRequestAuthenticationService:self didAuthenticateUser:user];
}

- (void) authenticateHttpRequest:(FLHttpRequest*) request {

    FLHttpUser* user = self.user;
    FLAssertNotNil(user); 
        
    [_asyncQueue runBlockSynchronously:^{
        
        if([self credentialsNeedAuthentication:user]) {
            [self authenticateUser:user];
        }

        [self.strategy authenticateHttpRequest:request withAuthenticatedUser:user];
    }];
}

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion {
    FLHttpUser* user = self.user;
    FLAssertNotNil(user); 

    return [self.asyncQueue queueBlock:^{

        FLTrace(@"started auth");
        if([self credentialsNeedAuthentication:user]) {
            [self authenticateUser:user];
        }
        else {
            [self.delegate httpRequestAuthenticationService:self didAuthenticateUser:user];
        }
    } 
    completion:completion];
}

@end