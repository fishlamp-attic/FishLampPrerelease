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
#import "FishLampAsync.h"

@protocol FLLoginPanelDelegate;

@protocol FLLoginPanelAuthenticationProvider;

@interface FLLoginPanel : FLPanelViewController<NSTextFieldDelegate, FLProgressPanelDelegate>  {
@private
    IBOutlet NSTextField* _userNameTextField;
    IBOutlet NSSecureTextField* _passwordEntryField;
    IBOutlet NSButton* _savePasswordCheckBox;
    IBOutlet NSButton* _forgotPasswordButton;
    IBOutlet NSButton* _loginButton;
    __unsafe_unretained id<FLLoginPanelAuthenticationProvider> _authenticationDelegate;
}
+ (id) loginPanel;
@property (readwrite, assign, nonatomic) id<FLLoginPanelAuthenticationProvider> authenticationProvider;
@end

@protocol FLLoginPanelAuthenticationProvider <NSObject>

// get/set credentials

- (id<FLAuthenticationCredentials>) loginPanelGetCredentials:(FLLoginPanel*) panel;

- (void) loginPanel:(FLLoginPanel*) panel setCredentials:(id<FLAuthenticationCredentials>) credentials;

// authetication

- (void) loginPanel:(FLLoginPanel*) loginPanel
beginAuthenticatingWithCompletion:(fl_result_block_t) completion;

- (void) loginPanelDidCancelAuthentication:(FLLoginPanel*) panel;

//- (BOOL) loginPanel:(FLLoginPanel*) panel 
//credentialsAreAuthenticated:(id<FLAuthenticationCredentials>) credentials;

// get/set BOOL for saving password

- (BOOL) loginPanelGetSavePassword:(FLLoginPanel*) panel;

- (void) loginPanel:(FLLoginPanel*) panel setSavePassword:(BOOL) savePassword;

@end

@protocol FLLoginPanelDelegate <NSObject>
- (void) loginPanelForgotPasswordButtonWasClicked:(FLLoginPanel*) panel;
- (void) loginPanel:(FLLoginPanel*) panel authenticationFailed:(NSError*) error;
- (void) loginPanelDidAuthenticate:(FLLoginPanel*) panel;
@end

