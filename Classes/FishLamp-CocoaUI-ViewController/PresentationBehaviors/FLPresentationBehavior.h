//
//  FLViewControllerPresentationLayer.h
//  FishLamp-iOS
//
//  Created by Mike Fullerton on 5/12/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

@protocol FLPresentationBehavior <NSObject>

// TODO: remove this. This is a hack used by floating view controller. Floating
// should actually be a presentation behavior itself. When it is, remove this flag.
@property (readonly, assign, nonatomic) BOOL canAutoDismissDontUseThis;

- (void) willPresentViewController:(SDKViewController*) viewController
            inParentViewController:(SDKViewController*) parentViewController;

- (void) didPresentViewController:(SDKViewController*) viewController
           inParentViewController:(SDKViewController*) parentViewController;

- (void) willHideViewController:(SDKViewController*) viewController
          fromParentViewController:(SDKViewController*) parentViewController;

- (void) didDismissViewController:(SDKViewController*) viewController
         fromParentViewController:(SDKViewController*) parentViewController;

@end





