//
//  FLHttpOperationContext.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLServiceList.h"
#import "FLHttpRequestAuthenticator.h"

@protocol FLUserService;
@protocol FLStorageService;
@protocol FLCredentials;

@class FLOperationContext;
@class FLHttpRequest;
@class FLHttpUser;
@class FLHttpRequestAuthenticator;
@class FLServiceList;

extern NSString* const FLHttpControllerDidLogoutUserNotification;

@interface FLHttpOperationContext : FLOperationContext<FLHttpRequestAuthenticatorDelegate> {
@private
    FLHttpUser* _httpUser;
    id<FLUserService> _userService;
    id<FLStorageService> _storageService;
    FLHttpRequestAuthenticator* _httpRequestAuthenticator;
    FLServiceList* _serviceList;
}

// getters
@property (readonly, assign, nonatomic) BOOL isAuthenticated;
@property (readonly, strong) id<FLUserService> userService;
@property (readonly, strong) id<FLStorageService> storageService;
@property (readonly, strong) FLHttpRequestAuthenticator* httpRequestAuthenticator;
@property (readonly, strong) FLHttpUser* httpUser;

- (void) logoutUser;
- (void) setAuthenticatedUser:(FLHttpUser*) user;

// Optional overrides

/// @return FLHttpUser by default.
- (FLHttpUser*) createHttpUserForCredentials:(id<FLCredentials>) credentials;

/// @return FLUserService by default.
- (id<FLUserService>) createUserService;

/// @return FLDatabaseStorageService by default
- (id<FLStorageService>) createStorageService;

/// @return nil by default
- (FLHttpRequestAuthenticator*) createHttpRequestAuthenticator;

@end

@protocol FLHttpControllerMessages <NSObject>
@optional

- (void) httpController:(FLHttpOperationContext*) controller
    didAuthenticateUser:(FLHttpUser*) userLogin;

- (void) httpController:(FLHttpOperationContext*) controller 
          didLogoutUser:(FLHttpUser*) userLogin;

- (void) httpControllerDidClose:(FLHttpOperationContext*) controller;
- (void) httpControllerDidOpen:(FLHttpOperationContext*) controller;
@end

