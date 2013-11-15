//
//  FLHttpController+UserLogin.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpController+UserLogin.h"
#import "FLLoginPanel.h"
#import "FLUserService.h"
#import "FLCredentialsStorage.h"

@implementation FLHttpOperationContext (UserLogin)

- (id<FLAuthenticationCredentials>) loginPanelGetCredentials:(FLLoginPanel*) panel {
    return self.userService.credentials;
}

- (void) loginPanel:(FLLoginPanel*) panel setCredentials:(id<FLAuthenticationCredentials>) credentials {
    [self.userService setCredentials:credentials];
    [self.userService saveCredentials];
}

- (void) loginPanel:(FLLoginPanel*) panel 
beginAuthenticatingWithCompletion:(fl_result_block_t) completion {

    if(!self.isServiceOpen) {
        [self openService];
    }
    [self beginAuthenticating:completion];
}

- (void) loginPanelDidCancelAuthentication:(FLLoginPanel*) panel {
    [self requestCancel];
}

//- (BOOL) loginPanel:(FLLoginPanel*) panel 
//credentialsAreAuthenticated:(id<FLAuthenticationCredentials>) editor {
//    return  [self.userService isAuthenticated];
//}

- (BOOL) loginPanelGetSavePassword:(FLLoginPanel*) panel {
    return self.userService.credentialsStorage.rememberPasswordSetting;
}

- (void) loginPanel:(FLLoginPanel*) panel setSavePassword:(BOOL) savePassword {
    self.userService.credentialsStorage.rememberPasswordSetting = savePassword;
}


@end
