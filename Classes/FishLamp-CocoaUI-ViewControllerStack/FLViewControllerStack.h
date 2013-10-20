//
//  FLViewControllerStack.h
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 1/21/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCocoaUIRequired.h"
#import "FLViewController.h"

typedef void (^FLViewControllerStackVisitor)(FLViewController* viewController, BOOL* stop);

@interface FLViewControllerStack : FLViewController {
@private
    NSMutableArray* _viewControllers;
    FLViewController* _rootViewController;
}

// this is the bottom view controller. Think of it as the bottom viewController in the
// stack. 
@property (readonly, retain, nonatomic) FLViewController* rootViewController;

// the leaf most viewController in the stack (see comment in FLViewController+FLAdditions.h
@property (readonly, strong, nonatomic) FLViewController* visibleViewController;

@property (readwrite, retain, nonatomic) NSArray* viewControllers;

- (id) initWithRootViewController:(FLViewController*) rootViewController;

+ (FLViewControllerStack*) viewControllerStack:(FLViewController*) rootViewController;

- (void) pushViewController:(FLViewController *)viewController 
             withAnimation:(id<FLViewControllerTransitionAnimation>) animation;

- (void) pushViewController:(FLViewController *)viewController;

- (void) popViewControllerAnimated:(BOOL) animated; // YES uses the animation in the view controller.
    
- (void) popViewControllerWithAnimation:(id<FLViewControllerTransitionAnimation>) animation;	

- (void) popToViewController:(FLViewController*) viewController
               withAnimation:(id<FLViewControllerTransitionAnimation>) animation;

- (FLViewController*) parentControllerForController:(FLViewController*) controller;
	
- (BOOL) containsViewController:(FLViewController*) controller;	   

- (void) visitViewControllers:(FLViewControllerStackVisitor) visitor; // backwards from top

// this visits view controllers in back to front order starting with viewController
- (void) visitViewControllersStartingWithViewController:(FLViewController*) viewController 
                                                visitor:(FLViewControllerStackVisitor) visitor;

@end

@interface SDKViewController (FLViewControllerStack)
- (void) willBePushedOnViewControllerStack:(FLViewControllerStack*) controller;
- (void) wasPushedOnViewControllerStack:(FLViewControllerStack*) controller;

- (void) willBePoppedFromViewControllerStack:(FLViewControllerStack*) controller;
- (void) wasPoppedFromViewControllerStack:(FLViewControllerStack*) controller;

@property (readonly, assign, nonatomic) FLViewControllerStack* viewControllerStack;

@end





        