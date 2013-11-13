// 
// FLAuthenticationCredentials.h

// Project: FishLamp
// Schema: FLSessionObjects
//
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
//

#import "FLModelObject.h"

@protocol FLAuthenticationCredentials <NSObject, NSCopying>

@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;

@property (readwrite, assign, nonatomic) BOOL isAuthenticated;
@property (readwrite, assign, nonatomic) BOOL rememberPassword;

@property (readwrite, assign, nonatomic) NSTimeInterval authTokenLastUpdateTime;

@property (readwrite, strong, nonatomic) NSString* authToken;

- (void) clearCredentials;
- (void) setUnauthenticated;

@property (readonly, assign, nonatomic) BOOL canAuthenticate;

@property (readwrite, assign, nonatomic) NSTimeInterval timeoutInterval;
@property (readonly, assign, nonatomic) NSTimeInterval lastAuthenticationTimestamp;
@property (readonly, assign, nonatomic) BOOL authenticationHasExpired;

- (void) resetAuthenticationTimestamp;
- (void) touchAuthenticationTimestamp;

@end

@protocol FLAuthenticatedEntity <NSObject>
- (id<FLAuthenticationCredentials>) authenticationCredentials;
- (void) setAuthenticationCredentials:(id<FLAuthenticationCredentials>) creds;

- (NSString*) userName;
@end

@protocol FLCredentialsProvider <NSObject>
- (id<FLAuthenticationCredentials>) authenticationCredentials;
//- (void) updateCredentials:(id<FLAuthenticationCredentials>) authenticationCredentials;

- (id<FLAuthenticatedEntity>) authenticatedEntity;
- (void) updateEntity:(id<FLAuthenticatedEntity>) entity;
@end

@interface FLAuthenticationCredentials : FLModelObject<FLAuthenticationCredentials> {
@private
    NSString* _password;
    BOOL _isAuthenticated;
    NSString* _userName;
    NSTimeInterval _authTokenLastUpdateTime;
    NSString* _authToken;
    BOOL _rememberPassword;

    NSTimeInterval _lastAuthenticationTimestamp;
    NSTimeInterval _timeoutInterval;
}

+ (id) authenticationCredentials;
+ (id) authenticationCredentials:(NSString*) userName password:(NSString*) password;

@end