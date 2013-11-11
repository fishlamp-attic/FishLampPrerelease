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
#import "FLCredentialsEditor.h"

@protocol FLCredentials;
@protocol FLCredentialsEditor;
@protocol FLUserServiceDelegate;
@protocol FLCredentialsStorage;

@protocol FLUserService <FLService, FLCredentialsEditorDelegate>
- (BOOL) canAuthenticate;
- (id<FLAuthenticationCredentials>) credentials;

- (FLCredentialsEditor*) credentialEditor;

- (void) openServiceWithCredentials:(id<FLAuthenticationCredentials>) credentials;
@end


@interface FLUserService : FLService<FLUserService> {
@private
    id<FLAuthenticationCredentials> _credentials;
    id<FLCredentialsStorage> _credentialStorage;
}

@property (readwrite, strong) id<FLAuthenticationCredentials> credentials;
@property (readwrite, strong) id<FLCredentialsStorage> credentialStorage;

+ (id) userService;
+ (id) userService:(id<FLAuthenticationCredentials>) credentials;

- (id) initWithCredentials:(id<FLAuthenticationCredentials>) credentials;

@end


@protocol FLUserServiceObserverMessages <NSObject>
- (void) userServiceDidOpen:(id<FLUserService>) service;
- (void) userServiceDidClose:(id<FLUserService>) service;
@end
