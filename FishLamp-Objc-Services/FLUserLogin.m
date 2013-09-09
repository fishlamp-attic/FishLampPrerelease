// 
// FLUserLogin.m

// Project: FishLamp
// Schema: FLSessionObjects
// 
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
// 

#import "FLUserLogin.h"

@implementation FLUserLogin

@synthesize password = _password;
@synthesize isAuthenticated = _isAuthenticated;
@synthesize userName = _userName;
@synthesize authTokenLastUpdateTime = _authTokenLastUpdateTime;
@synthesize authToken = _authToken;
@synthesize userGuid = _userGuid;
@synthesize email = _email;
@synthesize userInfo = _userInfo;
@synthesize rememberPassword = _rememberPassword;

+ (id) userLogin {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) userLogin:(NSString*) userName password:(NSString*) password {
    FLUserLogin* userLogin = [FLUserLogin userLogin];
    userLogin.userName = userName;
    userLogin.password = password;
    return userLogin;
}

+ (id) userLoginWithCredentials:(id<FLCredentials>) credentials {
    FLUserLogin* userLogin = [self userLogin:credentials.userName password:credentials.password];
    userLogin.rememberPassword = credentials.rememberPassword;
    return userLogin;
}

- (BOOL) canAuthenticate {
    return FLStringIsNotEmpty(self.userName) && FLStringIsNotEmpty(self.password);
}

#if FL_MRC
-(void) dealloc {
    [_password release];
    [_userName release];
    [_authToken release];
    [_userGuid release];
    [_email release];
    [_userInfo release];
    [super dealloc];
}
#endif

- (id) mutableCopyWithZone:(NSZone *)zone {
    return [self copy];
}
@end
