//
//  SDKViewController+FLExtras.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 3/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewController.h"
#import <objc/runtime.h>

#import "SDKViewController+FLPresentationBehavior.h"

#if OSX 
@implementation FLViewController
@end
#endif

#if IOS

@implementation FLViewController


FLSynthesizeAssociatedProperty(copy_nonatomic, dismissHandler, setDismissHandler, FLViewControllerDismissHandler);
FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, _backButtonTitle, setBackButtonTitle, NSString*);
FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, transitionAnimation, setTransitionAnimation, id<FLViewControllerTransitionAnimation>);

- (NSString*) backButtonTitle {
    NSString* title = self._backButtonTitle;

	return FLStringIsEmpty(title) ? self.title : title;
}

- (BOOL) backButtonWillDismissViewController {
	return YES;
}

- (void) respondToBackButtonPress:(id) sender {
	if([self backButtonWillDismissViewController]) {
		[self hideViewController:YES];
//        FLInvokeCallback(_dismissEvent, self);
	}
}

- (SDKView*) viewByTag:(NSUInteger) tag {
    FLAssertWithComment(self.isViewLoaded, @"subview is not loaded");

    if(self.isViewLoaded) {
        for(SDKView* subview in self.view.subviews) {
            if(subview.tag == tag)
            {
                return subview;
            }
        }
    }
    
    return nil;
}

- (void) addViewWithTag:(SDKView*) subview tag:(NSUInteger) tag {
    FLAssertWithComment(self.isViewLoaded, @"subview is not loaded");

    if(self.isViewLoaded) {
        SDKView* prev = [self viewByTag:tag];
        if(prev) {
            [prev removeFromSuperview];
        }
        subview.tag = tag;
        [self.view addSubview:subview];
    }
}


- (SDKView*) topBarView {
    return [self viewByTag:FLViewControllerTopToolBarTag];
}

- (SDKView*) bottomBarView {
    return [self viewByTag:FLViewControllerBottomToolBarTag];
}

- (void) setTopBarView:(SDKView*) subview {
    FLAssertWithComment(self.isViewLoaded, @"subview not loaded");
    
    subview.frame = [self frameForTopBarView:subview];
    
    [self addViewWithTag:subview tag:FLViewControllerTopToolBarTag];
    if([subview respondsToSelector:@selector(viewControllerTitleDidChange:)]) {
        [((id)subview) viewControllerTitleDidChange:self];
    }
}

- (void) setBottomBarView:(SDKView*) subview {
    FLAssertWithComment(self.isViewLoaded, @"subview not loaded");

    subview.frame = [self frameForBottomBarView:subview];
    [self addViewWithTag:subview tag:FLViewControllerBottomToolBarTag];
    if([subview respondsToSelector:@selector(viewControllerTitleDidChange:)]) {
        [((id)subview) viewControllerTitleDidChange:self];
    }    
}

- (CGRect) frameForTopBarView:(SDKView*) subview {
    CGRect frame = subview.frame;
    frame.origin.y = self.statusBarInset;
    frame.origin.x = 0;
    frame.size.width = self.view.bounds.size.width;
    return frame;
}

- (CGRect) frameForBottomBarView:(SDKView*) subview {
    CGRect frame = subview.frame;
    frame.origin.y = FLRectGetBottom(self.view.bounds) - frame.size.height;
    frame.origin.x = 0;
    frame.size.width = self.view.bounds.size.width;
    return frame;
}

- (void) willHideViewController:(BOOL) animated {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");

    FLAutoreleaseObject(FLRetain(self));

    [[self presentationBehavior] willHideViewController:self
        fromParentViewController:self.parentViewController];
        
    id<FLViewControllerTransitionAnimation> animation = self.transitionAnimation;
    [animation beginHideAnimationForViewController:self 
                              parentViewController:self.parentViewController
                                     finishedBlock:^(id theViewController, id theParent){
                                         [[theViewController presentationBehavior] didDismissViewController:theViewController
                                            fromParentViewController:theParent];
                                         [theViewController viewControllerDidDisappear];
                                     }];
}

- (void) hideViewController:(BOOL) animated {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");

    if(self.dismissHandler) {
        self.dismissHandler(self, animated);
    } else {
        [self willHideViewController:animated];
    }
}

- (void) viewControllerDidAppear {
}

- (void) viewControllerDidDisappear {
}

- (void) viewControllerWillAppear {
}

- (void) viewControllerWillDisappear {

}

// the animation is saved and used for dismissal
// if the frame of the viewController is zero, the frame is set to the parents views
// bounds, otherwise the frame is preserved. 
- (void) showViewController:(BOOL) animated
       inHostViewController:(SDKViewController*) hostViewController {

    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");
    
    FLAssertIsNotNil(self);
    FLAssertWithComment(self != hostViewController, @"can't present yourself in yourself");
      
    FLViewControllerTransitionAnimation* animation = self.transitionAnimation;
      
    if(!animation){
        animation = [[hostViewController class] defaultTransitionAnimation];
        self.transitionAnimation = animation;
    }
    FLAssertIsNotNil(animation);
    
    id<FLPresentationBehavior> behavior = self.presentationBehavior;
    
    if(!behavior) {
        behavior = [[self class] defaultPresentationBehavior];
        self.presentationBehavior = behavior;
    }

    FLAssertIsNotNil(behavior);
                  
    if(CGRectEqualToRect(self.view.frame, CGRectZero)) {
        self.view.frame = hostViewController.view.bounds;
    }
    
    
    CGRect frame = self.view.frame;
    [behavior willPresentViewController:self inParentViewController:hostViewController];
    self.view.frame = frame; // please respect my frame
             
    [self viewControllerWillAppear];
                
    [animation beginShowAnimationForViewController:self 
        parentViewController:hostViewController 
        finishedBlock:^(id theViewController, id theParent) {
                [theViewController viewControllerDidAppear];
                [[theViewController presentationBehavior] didPresentViewController:theViewController 
                                                            inParentViewController:theParent];
            }];
}

- (void) showViewController:(BOOL) animated {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");
    
    if(!animated) {
        self.transitionAnimation = [SDKViewController defaultTransitionAnimation]; 
    }

    if(self.parentViewController) {
        [self showViewController:animated inHostViewController:self.parentViewController];
    }
    else {
        [[UIApplication visibleViewController] showChildViewController:self];
    }
}

+ (id<FLViewControllerTransitionAnimation>) defaultTransitionAnimation {
    return [FLDefaultViewControllerAnimation viewControllerTransitionAnimation];
}

- (UINavigationController*) rootNavigationController  {
    return self.navigationController;
}

- (SDKViewController*) visibleViewController {
    return self.rootNavigationController ? [self.rootNavigationController visibleViewController] : self;
}

- (void) hideViewControllerWithSender:(id) sender {
    [self hideViewController:YES];
}

@end

@implementation SDKViewController (ProgressAdditions)
- (UIActivityIndicatorView*) addActivityIndicatorView:(UIActivityIndicatorViewStyle) style {
    FLAssertWithComment([NSThread currentThread] == [NSThread mainThread], @"Not on main thread");

    UIActivityIndicatorView* spinner = FLAutorelease([[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style]);
    SDKView* superview = self.view;
    spinner.frameOptimizedForLocation = FLRectCenterRectInRect(superview.bounds, spinner.frame);
    [spinner startAnimating];
    [superview addSubview:spinner];
    return spinner;
}
@end
#endif

//@implementation SDKViewController (FLNibLoading)
//
//- (NSString*) defaultNibName {
//#if OSX
//    return [NSString stringWithFormat:@"%@-OSX", NSStringFromClass([self class])];
//#else 
//    return [NSString stringWithFormat:@"%@-iOS", NSStringFromClass([self class])];
//#endif    
//}
//
//- (id) initWithDefaultNibName {
//    return [self initWithNibName:self.defaultNibName bundle:nil];
//}
//
//- (id) initWithDefaultNibName:(NSBundle *)nibBundleOrNil {
//    return [self initWithNibName:self.defaultNibName bundle:nibBundleOrNil];
//}
//
//
//@end
