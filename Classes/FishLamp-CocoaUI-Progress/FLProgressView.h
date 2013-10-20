//
//  FLProgressView.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

@protocol FLProgressView <NSObject>
@optional

/// @brief Main title of progress. 
/// Progress may not have text though. 
@property (readwrite, retain, nonatomic) NSString* title;

/// @brief Secondary text
@property (readwrite, retain, nonatomic) NSString* secondaryText;

/// @brief Alpha for the progress view.
/// Note: This may mean different things to different types of progress
@property (readwrite, assign, nonatomic) CGFloat progressViewAlpha;

/// @brief The title for a button.
/// May not have a button.
@property (readwrite, retain, nonatomic) NSString* buttonTitle;
- (void) setButtonTarget:(id)target 
                  action:(SEL) action
                isCancel:(BOOL) isCancel;

/// @brief Hide/Show the progress bar.
/// IF there's a progress bar.
@property (readwrite, assign, nonatomic) BOOL progressBarHidden;

- (void) updateProgress:(unsigned long long) amountWritten 
            totalAmount:(unsigned long long) totalAmount;


// IF appropriate
- (void) startAnimating;
- (void) stopAnimating;

@end

typedef FLCompatibleView<FLProgressView> FLProgressView;