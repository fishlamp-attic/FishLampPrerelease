//
//	FLUserService.m
//	FishLamp
//
//	Created by Mike Fullerton on 12/13/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUserService.h"
#import "FLCredentialsStorage.h"
#import "FLAuthenticationCredentials.h"

@implementation FLUserService

@synthesize credentials = _credentials;
@synthesize credentialsStorage = _credentialsStorage;

//- (id) initWithCredentials:(id<FLAuthenticationCredentials>) credentials {
//    self = [super init];
//    if(self) {
//        _credentials = FLRetain(credentials);
//    }
//    return self;
//}

+ (id) userService {
    return FLAutorelease([[[self class] alloc] init]);
}

//+ (id) userService:(id<FLAuthenticationCredentials>) credentials {
//    return FLAutorelease([[[self class] alloc] initWithAuthenticationCredentials:credentials]);
//}

#if FL_MRC
- (void) dealloc {
    [_credentialsStorage release];
    [_credentials release];
    [super dealloc];
}
#endif

- (BOOL) canAuthenticate {
    return self.credentials && [self.credentials canAuthenticate];
}

- (BOOL) canOpenService {
    return [self canAuthenticate];
}

- (void) openService {
    FLConfirmWithComment([self canAuthenticate], @"no credentials");
    [super openService];
    [self sendMessageToListeners:@selector(userServiceDidOpen:) withObject:self];
}

//- (void) openServiceWithCredentials:(id<FLAuthenticationCredentials>) credentials {
//    self.credentials = credentials;
//    [self openService];
//}

- (void) closeService {

    [super closeService];

//    FLCredentialsEditor* editor = [self credentialEditor];
//    editor.password = nil;
//    [editor stopEditing];

    [self sendMessageToListeners:@selector(userServiceDidClose:) withObject:self];

}

//- (BOOL) isAuthenticated {
//    return self.credentials.isAuthenticated;
//}

//- (FLCredentialsEditor*) credentialEditor {
//    FLCredentialsEditor* editor = [FLCredentialsEditor authCredentialEditor:self.credentials];
//    editor.delegate = self;
//    return editor;
//}

//- (void) credentialsEditor:(FLCredentialsEditor*) editor
//willStartEditingCredentials:(id<FLAuthenticationCredentials>) credentials {
//
//   [self closeService];
//}
//
//- (void) credentialsEditor:(FLCredentialsEditor*) editor
//      credentialsDidChange:(id<FLAuthenticationCredentials>) credentials {
//
//    self.credentials = editor.credentials;
//}

- (void) saveCredentials {

    if(self.credentialsStorage) {
        [self.credentialsStorage writeCredentials:self.credentials];
    }
}

@end
