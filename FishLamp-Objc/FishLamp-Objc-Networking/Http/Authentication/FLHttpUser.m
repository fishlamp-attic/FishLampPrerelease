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

@synthesize authenticationCredentials = _authenticationCredentials;

- (id) init {
	self = [super init];
	if(self) {
	}
	return self;
}

+ (id) httpUser {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_authenticationCredentials release];
    [super dealloc];
}
#endif

- (void) setAuthenticationCredentials:(id)authenticationCredentials {
    FLSetObjectWithMutableCopy(_authenticationCredentials, authenticationCredentials);
}

- (NSString*) userName {
    return [_authenticationCredentials userName];
}

- (BOOL) isLoginAuthenticated {
    return [_authenticationCredentials isAuthenticated];
}

- (void) setLoginUnathenticated {
    [_authenticationCredentials setUnauthenticated];
}

- (id) copyWithZone:(NSZone *)zone {
    FLHttpUser* user = [[[self class] alloc] init];
    user.authenticationCredentials = self.authenticationCredentials;
    return user;
}

- (NSString*) userFolderPath {
    return [NSString stringWithFormat:@"%@/%@", [FLAppInfo bundleIdentifier], self.userName];
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
