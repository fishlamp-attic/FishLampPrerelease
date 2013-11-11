//
//  FLHttpAuthenticator.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLHttpAuthenticator.h"
#import "FLAuthenticationCredentials.h"
#import "FLHttpRequest.h"
#import "FLReachableNetwork.h"
#import "FLAuthenticationCredentials.h"

@interface FLHttpAuthenticator ()
// instance ctors
- (id) initWithAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials;

- (id) initWithAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity;

- (id) initWithHttpRequest:(FLHttpRequest*) request credentials:(id<FLAuthenticationCredentials>) credentials;

- (id) initWithHttpRequest:(FLHttpRequest*) request entity:(id<FLAuthenticatedEntity>) entity;

@end



@implementation FLHttpAuthenticator

@synthesize authenticationDelegate = _authenticationDelegate;

- (id) initWithAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials {
	self = [super init];
	if(self) {
        _credentials = credentials;

        FLAssertNotNil(_credentials);
	}
	return self;
}

- (id) initWithAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity {
	self = [super init];
	if(self) {
        _entity = FLRetain(entity);

        FLAssertNotNil(_entity);
	}
	return self;
}

- (id) initWithHttpRequest:(FLHttpRequest*) request credentials:(id<FLAuthenticationCredentials>) credentials {
	self = [super init];
	if(self) {
        _httpRequest = FLRetain(request);
        _credentials = credentials;

        FLAssertNotNil(_credentials);
        FLAssertNotNil(_httpRequest);
	}
	return self;

}

- (id) initWithHttpRequest:(FLHttpRequest*) request entity:(id<FLAuthenticatedEntity>) entity {
	self = [super init];
	if(self) {
        _httpRequest = FLRetain(request);
        _entity = FLRetain(entity);

        FLAssertNotNil(_entity);
        FLAssertNotNil(_httpRequest);
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
    [_httpRequest release];
    [_credentials release];
    [_entity release];
	[super dealloc];
}
#endif

+ (id) httpAuthenticatorWithEntity:(id<FLAuthenticatedEntity>) entity
                   withHttpRequest:(FLHttpRequest*) request {

    return FLAutorelease([[[self class] alloc] initWithHttpRequest:request entity:entity]);
}

+ (id) httpAuthenticatorWithCredentials:(id<FLAuthenticationCredentials>) credentials {
    return FLAutorelease([[[self class] alloc] initWithAuthenticationCredentials:credentials]);
}

+ (id) httpAuthenticatorWithEntity:(id<FLAuthenticatedEntity>) entity {
    return FLAutorelease([[[self class] alloc] initWithAuthenticatedEntity:entity]);
}

+ (id) httpAuthenticatorWithCredentials:(id<FLAuthenticationCredentials>) credentials withHttpRequest:(FLHttpRequest*) request {
    return FLAutorelease([[[self class] alloc] initWithHttpRequest:request credentials:credentials]);
}

- (BOOL) shouldAuthenticateUser:(id<FLAuthenticationCredentials>) creds {

	FLAssertIsNotNil(creds);

    if(!creds.isAuthenticated) {
        return YES;
    }

#if TEST_CACHE_EXPIRE
	creds.authTokenLastUpdateTimeValue = creds.authTokenLastUpdateTimeValue - (_timeoutInterval*2);
#endif
    
    if(creds.authenticationHasExpired) {
    
        if([FLReachableNetwork instance].isReachable) {
            FLTrace(@"Login expired, will reauthenticate %@", user.userLogin.userName);
            [creds setUnauthenticated];
            return YES;
        }
        else {
            // don't want to reauthenticate if we're offline.
            return NO;
        }
    }

    return [self.authenticationDelegate authenticateHttpRequestOperation:self credentialsNeedAuthentication:creds];
}

- (id<FLAuthenticatedEntity>) authenticateCredentials:(id<FLAuthenticationCredentials>) credentials {
    [credentials resetAuthenticationTimestamp];

    id<FLAuthenticatedEntity> entity = [self.authenticationDelegate authenticateHttpRequestOperation:self
                                                                                    authenticateUser:credentials];
    [entity.authenticationCredentials touchAuthenticationTimestamp];

    [self sendMessageToListeners:@selector(authenticateHttpRequestOperation:didAuthenticateEntity:) withObject:self withObject:entity];

    return entity;
}

- (id<FLAuthenticatedEntity>) authenticateEntity:(id<FLAuthenticatedEntity>) entity  {

    id<FLAuthenticationCredentials> credentials = entity.authenticationCredentials;

    if([self shouldAuthenticateUser:credentials]) {
        return [self authenticateCredentials:credentials];
    }

    return entity;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) httpRequest
    withAuthenticatedEntity:(id<FLAuthenticatedEntity>) authenticatedEntity {

    [self.authenticationDelegate authenticateHttpRequestOperation:self
                                          authenticateHttpRequest:httpRequest
                                          withAuthenticatedEntity:authenticatedEntity];

}

- (void) startOperation {

    id<FLAuthenticatedEntity> authenticatedEntity = nil;
    if(_entity) {
        authenticatedEntity = [self authenticateEntity:_entity];
    }
    else if(_credentials) {
        authenticatedEntity = [self authenticateCredentials:_credentials];
    }

    if(_httpRequest) {
        [self authenticateHttpRequest:_httpRequest withAuthenticatedEntity:authenticatedEntity];
    }

    [self setFinishedWithResult:authenticatedEntity];
}

@end
