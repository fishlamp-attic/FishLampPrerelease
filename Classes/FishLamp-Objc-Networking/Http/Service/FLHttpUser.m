//
//  FLHttpUser.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpUser.h"
#import "FLAppInfo.h"

@implementation FLHttpUser

@synthesize userLogin = _userLogin;
@synthesize lastAuthenticationTimestamp = _lastAuthenticationTimestamp;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize authenticatedData = _authenticatedData;

- (id) init {
    return [self initWithUserLogin:nil];
}

- (id) initWithUserLogin:(FLUserLogin*) userLogin {
    self = [super init];
    if(self) {
        _timeoutInterval = 60 * 60;

        self.userLogin = userLogin;
    }
    return self;
}

+ (id) httpUser:(FLUserLogin*) userLogin {
    return FLAutorelease([[[self class] alloc] initWithUserLogin:userLogin]);
}

#if FL_MRC
- (void) dealloc {
    [_authenticatedData release];
    [_userLogin release];
    [super dealloc];
}
#endif

- (BOOL) isLoginAuthenticated {
    return _userLogin.isAuthenticated;
}

- (void) setLoginUnathenticated {
    _userLogin.isAuthenticated = NO;
    _userLogin.authToken = NO;
    _userLogin.authTokenLastUpdateTime = 0;
    _userLogin.password = @"";
    [self resetAuthenticationTimestamp];
    self.authenticatedData = nil;
}

- (void) touchAuthenticationTimestamp {
    _lastAuthenticationTimestamp = [NSDate timeIntervalSinceReferenceDate];
}

- (void) resetAuthenticationTimestamp {
	_lastAuthenticationTimestamp = 0;
}

- (id) copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithUserLogin:self.userLogin];
}

- (BOOL) authenticationHasExpired {
    return ([NSDate timeIntervalSinceReferenceDate] - _lastAuthenticationTimestamp) > _timeoutInterval;
}

- (NSString*) userFolderPath {
    return [NSString stringWithFormat:@"%@/%@", [FLAppInfo bundleIdentifier], self.userLogin.userName];
}

- (NSString*) cacheFolderPath {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingPathComponent:[self userFolderPath]];
}
 
- (NSString*) userDataFolderPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:[self userFolderPath]];
} 
 

@end
