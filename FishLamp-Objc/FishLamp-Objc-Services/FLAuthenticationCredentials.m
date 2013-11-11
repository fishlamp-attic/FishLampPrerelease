// 
// FLAuthenticationCredentials.m

// Project: FishLamp
// Schema: FLSessionObjects
// 
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
// 

#import "FLAuthenticationCredentials.h"

@implementation FLAuthenticationCredentials

@synthesize password = _password;
@synthesize isAuthenticated = _isAuthenticated;
@synthesize userName = _userName;
@synthesize authTokenLastUpdateTime = _authTokenLastUpdateTime;
@synthesize authToken = _authToken;
//@synthesize userGuid = _userGuid;
//@synthesize email = _email;
//@synthesize userInfo = _userInfo;
@synthesize rememberPassword = _rememberPassword;

@synthesize lastAuthenticationTimestamp = _lastAuthenticationTimestamp;
@synthesize timeoutInterval = _timeoutInterval;

- (id) init {	
	self = [super init];
	if(self) {
        _timeoutInterval = 60 * 60;
	}
	return self;
}

+ (id) authenticationCredentials {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) authenticationCredentials:(NSString*) userName password:(NSString*) password {
    FLAuthenticationCredentials* userLogin = [FLAuthenticationCredentials authenticationCredentials];
    userLogin.userName = userName;
    userLogin.password = password;
    return userLogin;
}

- (BOOL) canAuthenticate {
    return FLStringIsNotEmpty(self.userName) && FLStringIsNotEmpty(self.password);
}

#if FL_MRC
-(void) dealloc {
//    [_userGuid release];
    [_password release];
    [_userName release];
    [_authToken release];
//    [_userGuid release];
//    [_email release];
//    [_userInfo release];
    [super dealloc];
}
#endif

- (id) mutableCopyWithZone:(NSZone *)zone {
    return [self copy];
}

- (void) setUnauthenticated {
    self.isAuthenticated = NO;
    self.authToken = nil;
    self.authTokenLastUpdateTime = 0;
    self.password = @"";
    [self resetAuthenticationTimestamp];
}

- (void) clearCredentials {
    [self setUnauthenticated];
    self.userName = nil;
//    self.email = nil;
}

- (void) touchAuthenticationTimestamp {
    _lastAuthenticationTimestamp = [NSDate timeIntervalSinceReferenceDate];
}

- (void) resetAuthenticationTimestamp {
	_lastAuthenticationTimestamp = 0;
}

- (BOOL) authenticationHasExpired {
    return ([NSDate timeIntervalSinceReferenceDate] - _lastAuthenticationTimestamp) > _timeoutInterval;
}

@end
