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

@implementation FLHttpOperationContext (UserLogin)

- (FLCredentialsEditor*) loginPanelGetCredentials:(FLLoginPanel*) panel {
    return self.userService.credentialEditor;
}

- (void) loginPanel:(FLLoginPanel*) panel 
beginAuthenticatingWithCredentials:(FLCredentialsEditor*) editor
         completion:(fl_result_block_t) completion {

    if(self.isServiceOpen) {
        [self closeService];
    }
    [self openServiceWithCredentials:editor.credentials];

    [self beginAuthenticating:completion];
}

- (void) loginPanelDidCancelAuthentication:(FLLoginPanel*) panel {
    [self requestCancel];
}

- (BOOL) loginPanel:(FLLoginPanel*) panel 
credentialsAreAuthenticated:(FLCredentialsEditor*) editor {

    return  [self isAuthenticated];
}


@end
