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

@implementation FLHttpController (UserLogin)

- (FLCredentialsEditor*) loginPanelGetCredentials:(FLLoginPanel*) panel {
    return self.userService.credentialEditor;
}

- (void) loginPanel:(FLLoginPanel*) panel 
beginAuthenticatingWithCredentials:(FLCredentialsEditor*) editor
         completion:(fl_result_block_t) completion {
    [self.httpRequestAuthenticator beginAuthenticating:completion];
}

- (void) loginPanelDidCancelAuthentication:(FLLoginPanel*) panel {
    [self requestCancel];
}

- (BOOL) loginPanel:(FLLoginPanel*) panel 
credentialsAreAuthenticated:(FLCredentialsEditor*) editor {

    return  [self isAuthenticated];
}


@end
