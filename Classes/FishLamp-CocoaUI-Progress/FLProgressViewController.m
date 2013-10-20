//
//  FLProgressViewController.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 3/23/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCocoaUIRequired.h"
#import "FLProgressViewController.h"
#import "FLViewController.h"
#import "SDKViewController+FLPresentationBehavior.h"

@interface FLProgressViewController ()
@end

@implementation FLProgressViewController

@synthesize minimumViewSize = _minSize;
@dynamic title;
@synthesize onShowProgress = _onShowProgress;
@synthesize onHideProgress = _onHideProgress;

- (BOOL) isProgressHidden {
    return !self.isViewLoaded ||
            self.view.isHidden ||
            self.view.superview == nil;
}

#if OSX
- (void) updateViewSizeAndPosition {
}
#endif

- (void) setMinimumViewSize:(CGSize) size {
    _minSize = size;
    if([self isViewLoaded]) {
        [self updateViewSizeAndPosition];
    }   
}

- (void) sizeToFitInBounds:(CGRect) bounds {
    if([self.progressView respondsToSelector:@selector(setMinimumViewSize:)]) {
        [((id)self.progressView) setMinimumViewSize:self.minimumViewSize];
    }
    
    [super sizeToFitInBounds:bounds];
}

- (id) init {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");

    self = [super init];
    if(self) {
#if IOS
        self.transitionAnimation = [FLViewController defaultTransitionAnimation];

// default handlers
        self.onShowProgress = ^(id progress) {

        [[UIApplication visibleViewController] showChildViewController:progress];
        };
        
        self.onHideProgress = ^(id progress) {
            [progress hideViewController:YES];
        };
        
        _progressProxy = [[FLProgressViewOwner alloc] init];
#endif
    }
    
    return self;
}

- (id) initWithProgressViewClass:(Class) viewClass {
    self = [self init];
    if(self) {
        _viewClass = viewClass;
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");

    FLRelease(_progressProxy);
    FLRelease(_onHideProgress);
    FLRelease(_onShowProgress);
    FLSuperDealloc();
}
#endif

- (void) viewDidLoad {
    [super viewDidLoad];
    _progressProxy.progressView = self.view;
    _progressProxy.title = self.title;
}

- (void) viewDidUnload {
    [super viewDidUnload];
    _progressProxy.progressView = nil;
}

- (FLProgressView*) progressView {
    return (FLProgressView*) self.view;
}

- (SDKView*) createView {
    if(_viewClass) {
        return FLAutorelease([[_viewClass alloc] initWithFrame:CGRectZero]);
    }
    
#if IOS
    return [super createView];
#else
    return nil;
#endif
}

- (void) bringToFront {
    [self.view.superview bringSubviewToFront:self.view];
}

+ (id) progressViewController:(Class) viewClass {
    return FLAutorelease([[[self class] alloc] initWithProgressViewClass:viewClass]);
}

+ (id) progressViewController:(Class) viewClass 
         presentationBehavior:(id<FLPresentationBehavior>) presentationBehavior {
        
    FLProgressViewController* progress = [self progressViewController:viewClass];
    progress.presentationBehavior = presentationBehavior;
    return progress;
}


- (void) startAnimating {
    [_progressProxy startAnimating];
}

- (void) stopAnimating {
    [_progressProxy stopAnimating];
}


- (void) setTitle:(NSString*) title
{
    [super setTitle:title];
    
    _progressProxy.title = title;
    [self updateViewSizeAndPosition];
}

- (void) hideProgress {
    FLAssertIsNotNil(_onHideProgress);
    if(_onHideProgress) {
        _onHideProgress(self);
        FLReleaseBlockWithNil(_onHideProgress);
    }
}

- (void) showProgress {
    FLAssertIsNotNil(_onShowProgress);
    if(_onShowProgress) {
        _onShowProgress(self);
    }
}

- (void) updateProgress:(unsigned long long) amountWritten 
            totalAmount:(unsigned long long) totalAmount {
    
    [_progressProxy updateProgress:amountWritten totalAmount:totalAmount];
}

- (NSString*) secondaryText {
    return _progressProxy.secondaryText;
}

- (void) setSecondaryText:(NSString*) secondaryText {
    _progressProxy.secondaryText = secondaryText;
    [self updateViewSizeAndPosition];
}

//- (void) setProgressBarText:(NSString*) progressBarText
//{
//    if([self.progressView respondsToSelector:@selector(setProgressBarText:)])
//    {
//        [self.progressView setProgressBarText:progressBarText];
//    }
//}
//
//- (NSString*) progressBarText
//{
//    return ([self.progressView respondsToSelector:@selector(progressBarText)]) ? 
//        [self.progressView progressBarText] : nil;
//}

- (void) setButtonTitle:(NSString*) buttonTitle {
    _progressProxy.buttonTitle = buttonTitle;
}

- (NSString*) buttonTitle {
    return _progressProxy.title;
}

- (void) setButtonTarget:(id)target 
                  action:(SEL) action
                isCancel:(BOOL) isCancel {

    [_progressProxy setButtonTarget:target action:action isCancel:isCancel];
} 

- (void) setStartDelay:(CGFloat) startDelay {
    TODO("Set start delay not implemented");
}             

- (CGFloat) progressViewAlpha {
    if([self.progressView respondsToSelector:@selector(progressViewAlpha)]) {
        return [self.progressView progressViewAlpha];
    }
    else {
        return [self.progressView alpha];
    }
}

- (void) setProgressViewAlpha:(CGFloat) alpha {
    if([self.progressView respondsToSelector:@selector(setProgressViewAlpha:)]) {
        [self.progressView setProgressViewAlpha:alpha];
    }
    else {
        [self.progressView setAlpha:alpha];
    }
}   

- (BOOL) progressBarHidden {
    return _progressProxy.progressBarHidden;
}

- (void) setProgressBarHidden:(BOOL) hidden {
    _progressProxy.progressBarHidden = hidden;
}


@end


@implementation FLProgressViewOwner 

@synthesize progressView = _progressView;
@synthesize onShowProgress = _onShowProgress;
@synthesize onHideProgress = _onHideProgress;

- (id) init {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");

    self = [super init];
    if(self) {
        self.onShowProgress = ^(id progress) {
            [progress setHidden:NO];
        };
        self.onHideProgress = ^(id progress) {
            [progress setHidden:YES];
        };
    }
    
    return self;
}

- (id) initWithView:(SDKView*) view {
    self = [self init];
    if(self) {
        FLSetObjectWithRetain(_progressView, view);
    }
    
    return self;
}

+ (FLProgressViewOwner*) progressViewOwner:(SDKView*) view {
    return FLAutorelease([[FLProgressViewOwner alloc] initWithView:view]);
}

+ (FLProgressViewOwner*) progressViewOwner {
    return FLAutorelease([[FLProgressViewOwner alloc] init]);
}

- (void) dealloc  {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");
    [_progressView removeFromSuperview];
#if FL_MRC    
    FLRelease(_onShowProgress);
    FLRelease(_onHideProgress);
    FLRelease(_progressView);
    FLSuperDealloc();
#endif
}

- (BOOL) isProgressHidden {
    return [self.progressView isHidden] || [self.progressView superview] == nil;
}

- (CGFloat) progressViewAlpha {
    if([self.progressView respondsToSelector:@selector(progressViewAlpha)]) {
        return [self.progressView progressViewAlpha];
    }
    else {
        return [self.progressView alphaValue];
    }
}

- (void) setProgressViewAlpha:(CGFloat) alpha {
    if([self.progressView respondsToSelector:@selector(setProgressViewAlpha:)]) {
        [self.progressView setProgressViewAlpha:alpha];
    }
    else {
        [self.progressView setAlphaValue:alpha];
    }
}   

- (void) startAnimating {
    if([self.progressView respondsToSelector:@selector(startAnimating)]) {
        [self.progressView startAnimating];
    }
}

- (void) stopAnimating {
    if([self.progressView respondsToSelector:@selector(stopAnimating)]) {
        [self.progressView stopAnimating];
    }
}

- (NSString*) title {
    if([self.progressView respondsToSelector:@selector(title)]) {
        return [self.progressView title];
    }
    
    return nil;
}

- (void) setTitle:(NSString*) title {
    if([self.progressView respondsToSelector:@selector(setTitle:)]) {
        [self.progressView setTitle:title];
    }
}

- (void) hideProgress {
    FLAssertIsNotNil(_onHideProgress);
    if(_onHideProgress) {
        _onHideProgress(self);
    }
}

- (void) showProgress {
    FLAssertIsNotNil(_onShowProgress);
    if(_onShowProgress) {
        _onShowProgress(self);
    }
}

- (void) updateProgress:(unsigned long long) amountWritten 
            totalAmount:(unsigned long long) totalAmount {
    if([self.progressView respondsToSelector:@selector(updateProgress:totalAmount:)]) {
        [self.progressView updateProgress:amountWritten totalAmount:totalAmount];
    }
}

- (NSString*) secondaryText {
    return ([self.progressView respondsToSelector:@selector(secondaryText)]) ? 
        [self.progressView secondaryText] : nil;
}

- (void) setSecondaryText:(NSString*) secondaryText {
    if([self.progressView respondsToSelector:@selector(setSecondaryText:)]) {
        [self.progressView setSecondaryText:secondaryText];
    }
}

- (void) setProgressBarText:(NSString*) progressBarText {
    if([self.progressView respondsToSelector:@selector(setProgressBarText:)]) {
        [self.progressView setProgressBarText:progressBarText];
    }
}

- (NSString*) progressBarText {
    return ([self.progressView respondsToSelector:@selector(progressBarText)]) ? 
            [self.progressView progressBarText] : nil;
}

- (void) setButtonTitle:(NSString*) buttonTitle {
    if([self.progressView respondsToSelector:@selector(setButtonTitle:)]) {
        [self.progressView setButtonTitle:buttonTitle];
    }
}

- (NSString*) buttonTitle {
    return ([self.progressView respondsToSelector:@selector(buttonTitle)]) ? 
        [self.progressView buttonTitle] : nil;
}

- (void) setButtonTarget:(id)target 
                  action:(SEL) action
                isCancel:(BOOL) isCancel {
    if([self.progressView respondsToSelector:@selector(setButtonTarget:action:isCancel:)]) {
        [self.progressView setButtonTarget:target action:action isCancel:isCancel];
    }
} 

- (BOOL) progressBarHidden {
    return ([self.progressView respondsToSelector:@selector(progressBarHidden)]) ? 
        [self.progressView progressBarHidden] : YES;
}

- (void) setProgressBarHidden:(BOOL) hidden {
    if([self.progressView respondsToSelector:@selector(setProgressBarHidden:)]) {
        [self.progressView setProgressBarHidden:hidden];
    }
}

@end

#if IOS
#import "FLSimpleProgressView.h"
        
@implementation FLProgressViewController (Instantiation)
+ (FLProgressViewController*) simpleModalProgress
{
    return [FLProgressViewController progressViewController:[FLSimpleProgressView class] presentationBehavior:[FLModalPresentationBehavior instance]];
}
+ (FLProgressViewController*) simpleProgress
{
    return [FLProgressViewController progressViewController:[FLSimpleProgressView class] presentationBehavior:[SDKViewController defaultPresentationBehavior]];
}
@end
#endif