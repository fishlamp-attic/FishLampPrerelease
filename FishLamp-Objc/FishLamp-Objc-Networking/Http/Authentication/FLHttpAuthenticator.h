//
//  FLHttpAuthenticator.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperation.h"

@class FLHttpRequest;
@protocol FLAuthenticationCredentials;
@protocol FLAuthenticatedEntity;
@protocol FLHttpAuthenticatorDelegate;

@interface FLHttpAuthenticator : FLOperation {
@private
    id<FLAuthenticationCredentials> _credentials;
    id<FLAuthenticatedEntity> _entity;
    FLHttpRequest* _httpRequest;
    __unsafe_unretained id<FLHttpAuthenticatorDelegate> _authenticationDelegate;
}

@property (readwrite, assign) id<FLHttpAuthenticatorDelegate> authenticationDelegate;

+ (id) httpAuthenticatorWithEntity:(id<FLAuthenticatedEntity>) entity withHttpRequest:(FLHttpRequest*) request;

+ (id) httpAuthenticatorWithEntity:(id<FLAuthenticatedEntity>) entity;

+ (id) httpAuthenticatorWithCredentials:(id<FLAuthenticationCredentials>) credentials ;

+ (id) httpAuthenticatorWithCredentials:(id<FLAuthenticationCredentials>) credentials withHttpRequest:(FLHttpRequest*) request;



@end

@protocol FLHttpAuthenticatorDelegate <NSObject>

- (BOOL) authenticateHttpRequestOperation:(FLHttpAuthenticator*) operation
            credentialsNeedAuthentication:(id<FLAuthenticationCredentials>) credentials;

- (id<FLAuthenticatedEntity>) authenticateHttpRequestOperation:(FLHttpAuthenticator*) operation
                                              authenticateUser:(id<FLAuthenticationCredentials>) credentials;

- (void) authenticateHttpRequestOperation:(FLHttpAuthenticator*) operation
                  authenticateHttpRequest:(FLHttpRequest*) httpRequest
                  withAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity;
@end


@protocol FLHttpAuthenticatorMessages <NSObject>
@optional
- (void) authenticateHttpRequestOperation:(FLHttpAuthenticator*) operation
                    didAuthenticateEntity:(id<FLAuthenticatedEntity>) entity;
@end