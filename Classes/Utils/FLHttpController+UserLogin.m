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
#import "FLCredentialsStorage.h"

@implementation FLHttpOperationContext (UserLogin)

- (id<FLAuthenticationCredentials>) loginPanelGetCredentials:(FLLoginPanel*) panel {
    return self.authenticationCredentials;
}

- (void) loginPanel:(FLLoginPanel*) panel setCredentials:(id<FLAuthenticationCredentials>) credentials {
    self.authenticationCredentials = credentials;
}

- (void) loginPanel:(FLLoginPanel*) panel 
beginAuthenticatingWithCompletion:(fl_result_block_t) completion {

    [self beginAuthenticating:completion];
}

- (void) loginPanelDidCancelAuthentication:(FLLoginPanel*) panel {
    [self requestCancel];
}

- (BOOL) loginPanelGetSavePassword:(FLLoginPanel*) panel {
    return self.credentialsStorage.rememberPasswordSetting;
}

- (void) loginPanel:(FLLoginPanel*) panel setSavePassword:(BOOL) savePassword {
    self.credentialsStorage.rememberPasswordSetting = savePassword;
}


@end
