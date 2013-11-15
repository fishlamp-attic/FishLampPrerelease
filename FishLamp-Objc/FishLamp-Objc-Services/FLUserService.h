//
//	FLUserService.h
//	FishLamp
//
//	Created by Mike Fullerton on 12/13/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLService.h"

@protocol FLCredentials;
@protocol FLUserServiceDelegate;
@protocol FLCredentialsStorage;
@protocol FLAuthenticationCredentials;

@protocol FLUserService <FLService>
@property (readonly, strong) id<FLCredentialsStorage> credentialsStorage;
@property (readwrite, strong) id<FLAuthenticationCredentials> credentials;

- (void) saveCredentials;
@end

@interface FLUserService : FLService<FLUserService> {
@private
    id<FLAuthenticationCredentials> _credentials;
    id<FLCredentialsStorage> _credentialsStorage;
}

@property (readwrite, strong) id<FLAuthenticationCredentials> credentials;
@property (readwrite, strong) id<FLCredentialsStorage> credentialsStorage;

+ (id) userService;

//+ (id) userService:(id<FLAuthenticationCredentials>) credentials;
//- (id) initWithCredentials:(id<FLAuthenticationCredentials>) credentials;

@end


@protocol FLUserServiceObserverMessages <NSObject>
- (void) userServiceDidOpen:(id<FLUserService>) service;
- (void) userServiceDidClose:(id<FLUserService>) service;
@end
