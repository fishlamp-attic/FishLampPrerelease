//
//  FLHttpOperationContext.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationContext.h"
#import "FLService.h"
#import "FLHttpRequest.h"
//#import "FLHttpAuthenticator.h"

@protocol FLUserService;
@protocol FLStorageService;
@protocol FLAuthenticationCredentials;
@protocol FLHttpAuthenticatorDelegate;
@protocol FLAuthenticatedEntity;

@class FLServiceList;

extern NSString* const FLHttpControllerDidLogoutUserNotification;

@interface FLHttpOperationContext : FLOperationContext<FLService, FLHttpRequestAuthenticator> {
@private
    id<FLUserService> _userService;
    id<FLStorageService> _storageService;
    id<FLAuthenticatedEntity> _authenticatedEntity;
    FLFifoAsyncQueue* _authenticationQueue;
    FLServiceList* _serviceList;
    __unsafe_unretained id<FLHttpAuthenticatorDelegate> _authenticationDelegate;
}
@property (readwrite, assign) id<FLHttpAuthenticatorDelegate> authenticationDelegate;
@property (readwrite, strong) id<FLAuthenticatedEntity> authenticatedEntity;
@property (readonly, strong) id<FLAuthenticationCredentials> authenticationCredentials;

// getters

@property (readonly, strong) id<FLUserService> userService;

@property (readonly, assign, nonatomic) BOOL isAuthenticated;
@property (readonly, strong) id<FLStorageService> storageService;

- (void) openServiceWithCredentials:(id<FLAuthenticationCredentials>) credentials;

- (void) openServiceWithUser:(id<FLAuthenticatedEntity>) entity;

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion;

@end

@interface FLHttpOperationContext (OptionalOverrides)

- (void) didChangeAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials;

/// @return FLUserService by default.
- (id<FLUserService>) createUserService;

/// @return FLDatabaseStorageService by default
- (id<FLStorageService>) createStorageService;

- (void) prepareAuthenticatedOperation:(id) operation;

@end

@protocol FLHttpContextMessages <NSObject>
@optional

- (void) httpContext:(FLHttpOperationContext*) controller
 didAuthenticateUser:(id<FLAuthenticatedEntity>) userLogin;

- (void) httpContext:(FLHttpOperationContext*) controller 
       didLogoutUser:(id<FLAuthenticationCredentials>) userLogin;

- (void) httpControllerDidClose:(FLHttpOperationContext*) controller;
- (void) httpControllerDidOpen:(FLHttpOperationContext*) controller;
@end



