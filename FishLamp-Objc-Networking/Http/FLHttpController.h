//
//  FLHttpController.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLServiceList.h"

@protocol FLUserService;
@protocol FLStorageService;
@protocol FLCredentials;

@class FLOperationContext;
@class FLHttpRequest;
@class FLHttpUser;
@class FLHttpRequestAuthenticator;

extern NSString* const FLHttpControllerDidLogoutUserNotification;

//    FLHttpRequestContext,
//    FLDatabaseObjectStorageServiceDelegate,
//    FLHttpRequestAuthenticatorDelegate {

@interface FLHttpController : FLServiceList {
@private
    FLHttpUser* _httpUser;
    id<FLUserService> _userService;
    id<FLStorageService> _storageService;
    FLHttpRequestAuthenticator* _httpRequestAuthenticator;
//    FLNetworkStreamSecurity _streamSecurity;
    FLOperationContext* _operationContext;
}

// settable properties
//@property (readwrite, assign, nonatomic) FLNetworkStreamSecurity streamSecurity;

// getters
@property (readonly, strong) FLOperationContext* operationContext;
@property (readonly, assign, nonatomic) BOOL isAuthenticated;
@property (readonly, strong) id<FLUserService> userService;
@property (readonly, strong) id<FLStorageService> storageService;
@property (readonly, strong) FLHttpRequestAuthenticator* httpRequestAuthenticator;
@property (readonly, strong) FLHttpUser* httpUser;

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

- (void) httpController:(FLHttpController*) controller
    didAuthenticateUser:(FLHttpUser*) userLogin;

- (void) httpController:(FLHttpController*) controller 
          didLogoutUser:(FLHttpUser*) userLogin;

- (void) httpControllerDidClose:(FLHttpController*) controller;
- (void) httpControllerDidOpen:(FLHttpController*) controller;
@end

