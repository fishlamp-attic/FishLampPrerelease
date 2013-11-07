//
//  FLViewControllerStack.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 1/21/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewControllerStack.h"

@implementation FLViewControllerStack

@synthesize viewControllers = _viewControllers;
@synthesize rootViewController = _rootViewController;

- (id) init {
    if((self = [super init])) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) _addViewController:(FLViewController*) viewController {
    [self addChildViewController:viewController];

#if IOS
    viewController.dismissHandler = ^(FLViewController* controller, BOOL animated) {
        FLViewControllerStack* stack = controller.viewControllerStack;
        if(stack.viewControllers.count == 1) {
            [stack hideViewController:animated];
        }
        else {
            [stack popViewControllerAnimated:YES];
        }
    };
#endif
    
    [_viewControllers addObject:viewController];
}

- (id) initWithRootViewController:(FLViewController*) rootViewController {
    if((self = [super init])) {
        _viewControllers = [[NSMutableArray alloc] init];
        FLSetObjectWithRetain(_rootViewController, rootViewController);
        [self _addViewController:_rootViewController];
    }
    
    return self;
}

+ (FLViewControllerStack*) viewControllerStack:(FLViewController*) rootViewController {
    return FLAutorelease([[FLViewControllerStack alloc] initWithRootViewController:rootViewController]);
}

- (void) dealloc {
    FLRelease(_rootViewController);
    FLRelease(_viewControllers);
    FLSuperDealloc();
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for(FLViewController* controller in _viewControllers) {
        if([controller isViewLoaded]) {
            controller.view.frame = self.view.bounds;
        }
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
#if IOS
    self.view.backgroundColor = [SDKColor clearColor];
   	self.view.layer.shadowColor = [SDKColor blackColor].CGColor;
#else 
    self.view.wantsLayer = YES;
#endif    
	self.view.layer.shadowOpacity = .8;
	self.view.layer.shadowRadius = 20.0;
	self.view.layer.shadowOffset = CGSizeMake(0,3);
#if IOS
    self.view.clipsToBounds = NO;
#endif
    
    _rootViewController.view.frame = self.view.bounds;
   
    [self.view addSubview:_rootViewController.view];
}  

- (void)pushViewController:(FLCompatibleViewController *)viewController 
             withAnimation:(id<FLViewControllerTransitionAnimation>) animation {
    
    FLAssertIsNotNil(_rootViewController);
    FLAssertIsNotNil(_viewControllers);
    
#if IOS    
    if(!animation) {
        animation = [[self class] defaultTransitionAnimation];
    }

    FLAssertIsNotNil(viewController);
    FLAssertIsNotNil(animation);
    
    FLCompatibleViewController* parent =  _viewControllers.lastObject;
        
    if(viewController.transitionAnimation != animation) {
        viewController.transitionAnimation = animation;
    }
    [self _addViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
    [viewController willBePushedOnViewControllerStack:self];
    [self.view layoutIfNeeded];
    
    [animation beginShowAnimationForViewController:viewController
     parentViewController:parent
        finishedBlock:^(FLViewController* theViewController, id theParent){
            if(theParent != self) {
                [[theParent view] removeFromSuperview];
            }
            [theViewController wasPushedOnViewControllerStack:self];
            }];
#endif    

}

- (void) pushViewController:(FLViewController *)viewController {
    [self pushViewController:viewController withAnimation:nil];
}

- (FLViewController*) visibleViewController	 {
    return _viewControllers.lastObject;
}

- (void) visitViewControllers:(FLViewControllerStackVisitor) visitor {
    if(visitor) {
        BOOL stop = NO;
        
        for(FLViewController* viewController in _viewControllers.reverseObjectEnumerator) {
            visitor(viewController, &stop);
            
            if(stop) {
                break;
            }
        }
    }
}

- (void) visitViewControllersStartingWithViewController:(FLViewController*) aViewController 
                                                visitor:(FLViewControllerStackVisitor) visitor {
    if(visitor) {
        BOOL foundIt = NO;
        BOOL stop = NO;
        
        for(FLViewController* viewController in _viewControllers) {
            if(viewController == aViewController) {
                foundIt = YES;
            }
        
            if(foundIt) {
                visitor(viewController, &stop);
            }
            
            if(stop) {
                break;
            }
        }
    }
}                                                

- (void) _removeViewController:(FLViewController*) viewController {
#if IOS
    for(int i = _viewControllers.count - 1; i >=0; i--) {
        if([_viewControllers objectAtIndex:i] == viewController) {
            viewController.transitionAnimation = nil;
            viewController.dismissHandler = nil;
            [viewController removeFromParentViewController];
            [viewController.view removeFromSuperview];
            [_viewControllers removeObjectAtIndex:i];
            break;
        }
    }
#endif    
}

- (void) popViewControllerAnimated:(BOOL) animated
{
#if IOS
    FLAssertWithComment(_viewControllers.count, @"no controllers on stack");
    
    if(_viewControllers.count) {
        id<FLViewControllerTransitionAnimation> animation = animated ? 
            [[_viewControllers lastObject] transitionAnimation] :
            [[self class] defaultTransitionAnimation];
    
        [self popViewControllerWithAnimation:animation]; 
    }
#endif
}

- (void) popViewControllerWithAnimation:(id<FLViewControllerTransitionAnimation>) animation {
    FLAssertIsNotNil(animation);
#if IOS
    FLViewController* visibleController = self.visibleViewController;
    
    FLViewController* parent = [self parentControllerForController:visibleController];
    FLAssertIsNotNil(parent);

    if(parent != visibleController) {
        [visibleController willBePoppedFromViewControllerStack:self];
        parent.view.frame = self.view.bounds;
        [self.view insertSubview:parent.view belowSubview:visibleController.view];
        [self.view layoutIfNeeded];

        [animation beginHideAnimationForViewController:visibleController 
            parentViewController:parent 
            finishedBlock:^(id theViewController, id theParent){
                    [self _removeViewController:theViewController];
                    [theViewController wasPoppedFromViewControllerStack:self];
                }];
    
    }
#endif
}

- (void) popToViewController:(FLViewController*) viewController 
               withAnimation:(id<FLViewControllerTransitionAnimation>) animation {
    FLAssertIsImplemented();
}

- (FLViewController*) parentControllerForController:(FLViewController*) aController {
    FLViewController* last = nil;
    for(FLViewController* viewController in _viewControllers) {
        if(viewController == aController) {
            return last;
        }
        
        last = viewController;
    }

    return nil;
}
	
- (BOOL) containsViewController:(FLViewController*) aController {
    for(FLViewController* viewController in _viewControllers) {
        if(viewController == aController) {
            return YES;
        }
    }

    return NO;
}

- (FLViewControllerStack*) viewControllerStack {
    return self;
}

@end

@implementation SDKViewController (FLViewControllerStack)

- (void) willBePushedOnViewControllerStack:(FLViewControllerStack*) controller {
}

- (void) wasPushedOnViewControllerStack:(FLViewControllerStack*) controller {
}

- (void) wasPoppedFromViewControllerStack:(FLViewControllerStack*) controller {
}

- (void) willBePoppedFromViewControllerStack:(FLViewControllerStack*) controller {
}

- (FLViewControllerStack*) viewControllerStack {
    return self.parentViewController.viewControllerStack;
}

@end                                                                              

