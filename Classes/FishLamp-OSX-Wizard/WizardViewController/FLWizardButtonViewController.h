//
//  FLWizardButtonViewController.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLPanelViewController.h"

@protocol FLWizardButtonViewControllerDelegate;
@interface FLWizardButtonViewController : FLCompatibleViewController<FLPanelButtons> {
@private
    IBOutlet NSButton* _nextButton;
    IBOutlet NSButton* _backButton;
    IBOutlet NSButton* _otherButton;
    IBOutlet SDKView* _contentView;
    
    __unsafe_unretained id<FLWizardButtonViewControllerDelegate> _delegate;
}
@property (readwrite, assign, nonatomic) id<FLWizardButtonViewControllerDelegate> delegate;
@property (readonly, strong, nonatomic) NSButton* nextButton;
@property (readonly, strong, nonatomic) NSButton* backButton;
@property (readonly, strong, nonatomic) NSButton* otherButton;
@property (readonly, strong, nonatomic) SDKView* contentView;

- (void) updateButtons;

@end

@protocol FLWizardButtonViewControllerDelegate <NSObject>
- (void) wizardButtonViewControllerUpdateButtonStates:(FLWizardButtonViewController*) controller;
- (void) wizardButtonViewControllerRespondToNextButton:(FLWizardButtonViewController*) controller;
- (void) wizardButtonViewControllerRespondToBackButton:(FLWizardButtonViewController*) controller;
- (void) wizardButtonViewControllerRespondToOtherButton:(FLWizardButtonViewController*) controller;
@end
