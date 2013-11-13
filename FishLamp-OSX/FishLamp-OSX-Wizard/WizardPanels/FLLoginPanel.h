//
//  FLLoginPanel.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLamp-OSX.h"
#import "FLPanelViewController.h"
#import "FLWizardViewController.h"
#import "FLProgressPanel.h"
#import "FLAuthenticationCredentials.h"

#if OSX

@protocol FLLoginPanelDelegate;
@protocol FLLoginPanelAthenticationDelegate;

@interface FLLoginPanel : FLPanelViewController<NSTextFieldDelegate, FLProgressPanelDelegate>  {
@private
    IBOutlet NSTextField* _userNameTextField;
    IBOutlet NSSecureTextField* _passwordEntryField;
    IBOutlet NSButton* _savePasswordCheckBox;
    IBOutlet NSButton* _forgotPasswordButton;
    IBOutlet NSButton* _loginButton;
    id<FLAuthenticationCredentials> _credentials;
    __unsafe_unretained id<FLLoginPanelAthenticationDelegate> _authenticationDelegate;
}
+ (id) loginPanel;
@property (readwrite, assign, nonatomic) id<FLLoginPanelAthenticationDelegate> authenticationDelegate;
@end

@protocol FLLoginPanelAthenticationDelegate <NSObject>

- (id<FLAuthenticationCredentials>) loginPanelGetCredentials:(FLLoginPanel*) panel;

- (void) loginPanel:(FLLoginPanel*) panel setCredentials:(id<FLAuthenticationCredentials>) credentials;

- (void) loginPanel:(FLLoginPanel*) loginPanel
beginAuthenticatingWithCompletion:(fl_result_block_t) completion;

- (void) loginPanelDidCancelAuthentication:(FLLoginPanel*) panel;

- (BOOL) loginPanel:(FLLoginPanel*) panel 
credentialsAreAuthenticated:(id<FLAuthenticationCredentials>) credentials;
   
@end

@protocol FLLoginPanelDelegate <NSObject>
- (void) loginPanelForgotPasswordButtonWasClicked:(FLLoginPanel*) panel;
- (void) loginPanel:(FLLoginPanel*) panel authenticationFailed:(NSError*) error;
- (void) loginPanelDidAuthenticate:(FLLoginPanel*) panel;
@end


#endif