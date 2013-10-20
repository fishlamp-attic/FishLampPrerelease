//
//  FLProgressViewController.h
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 3/23/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLAutoPositionedViewController.h"
#import "SDKViewController+FLPresentationBehavior.h"
#import "FLProgressView.h"

/// @brief A block with a abstract progressViewController as a parameter.
typedef void (^FLProgressViewControllerBlock)(id progress);

/// @brief FLProgressViewController is protocol describing simple API progress.
/// The controller does not have to be a view controller.
/// Also the implementer of this protocol SHOULD implement all of the methods
/// in the FLProgressViewController, though it's enclosed view may or may
/// not implement the protocol.
@protocol FLProgressViewController <FLProgressView>

/// @brief The progress view. 
/// May or may not conform to the FLProgressView protocol.
@property (readonly, retain, nonatomic) FLProgressView* progressView;

/// @brief Event that fires when the progress will show
/// @returns The block for the event.
@property (readwrite, copy, nonatomic) FLProgressViewControllerBlock onShowProgress;

/// @brief Event that fires whent the progress will show.
/// @returns The block for the event.
@property (readwrite, copy, nonatomic) FLProgressViewControllerBlock onHideProgress;

/// @brief Is the progress hidden?
/// @returns YES if hidden
@property (readonly, assign, nonatomic) BOOL isProgressHidden;

/// @brief Show the progress.
- (void) showProgress;

/// @brief Hide the progress.
- (void) hideProgress;
@end

// TODO: maybe this should be a NSProxy?
@interface FLProgressViewOwner : NSObject<FLProgressViewController> {
@private
    SDKView* _progressView;
    FLProgressViewControllerBlock _onShowProgress;
    FLProgressViewControllerBlock _onHideProgress;
}
@property (readwrite, retain, nonatomic) id progressView;

@property (readwrite, copy, nonatomic) FLProgressViewControllerBlock onHideProgress;
@property (readwrite, copy, nonatomic) FLProgressViewControllerBlock onShowProgress;

+ (FLProgressViewOwner*) progressViewOwner;
+ (FLProgressViewOwner*) progressViewOwner:(SDKView*) view;

/// SEE FLProgressViewController. This View Controller supports all the methods defined there.

@end

@interface FLProgressViewController : FLAutoPositionedViewController<FLProgressViewController> {
@private
    Class _viewClass;
    CGSize _minSize;
    FLProgressViewControllerBlock _onShowProgress;
    FLProgressViewControllerBlock _onHideProgress;
    FLProgressViewOwner* _progressProxy;
}

@property (readwrite, assign, nonatomic) CGSize minimumViewSize;

- (id) initWithProgressViewClass:(Class) viewClass;

+ (id) progressViewController:(Class) viewClass;

+ (id) progressViewController:(Class) viewClass 
         presentationBehavior:(id<FLPresentationBehavior>) presentationBehavior;

// TODO(MF): Not implemented yet.
- (void) setStartDelay:(CGFloat) startDelay;

@end

#if IOS
@interface FLProgressViewController (Instantiation)
+ (FLProgressViewController*) simpleProgress;
+ (FLProgressViewController*) simpleModalProgress;
@end
#endif