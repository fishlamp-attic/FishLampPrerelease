//
//  FLStatusBarViewController.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStatusBarViewController.h"
#import "FLStatusBarView.h"
#import "FLView.h"
#import "FLFlipTransition.h"
#import "FLPopInAnimation.h"
#import "FLFadeAnimation.h"

#if REFACTOR

@implementation FLStatusBarViewController

- (id) init {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _stack = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_stack release];
    [super dealloc];
}
#endif


- (void)loadView {
    FLView* rootView = FLAutorelease([[FLView alloc] initWithFrame:CGRectMake(0,0,100,100)]);
    rootView.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
    
    rootView.wantsLayer = YES;
    rootView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setView:rootView];
}


- (void) addStatusView:(SDKView*) view 
               animated:(BOOL) animated
               completion:(void (^)()) completion {


    SDKView* rootView = self.view;
    view.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable;
    view.frame = rootView.bounds;
    [rootView addSubview:view];

    if(animated) {
       completion = FLCopyWithAutorelease(completion);

//        SDKView* lastView = [_stack lastObject];
//        if(lastView) {
//            FLFlipTransition* fuckyoupieceofshit = [FLFlipTransition transitionWithViewToShow:view viewToHide:lastView flipDirection:FLAnimationDirectionUp];
//            [fuckyoupieceofshit startAnimating:completion];
//        }
//        else {
//            [[FLPopInAnimation popInAnimation] startAnimating:view completion:completion];
//        }
    }   
    else {
        if(completion) {
            completion();
        }

    }
}               

- (void) setStatusView:(SDKView*) view 
              animated:(BOOL) animated 
              completion:(void (^)()) completion {

   completion = FLCopyWithAutorelease(completion);

    __unsafe_unretained id SELF = self;
    [SELF addStatusView:view animated:animated completion:^{
        [self removeAllStatusViewsAnimated:NO completion:nil];

        [_stack addObject:view];
        
        if(completion) {
            completion();
        }
    }];
}              

- (void) pushStatusView:(SDKView*) view 
               animated:(BOOL) animated 
               completion:(void (^)()) completion{

   completion = FLCopyWithAutorelease(completion);

    __unsafe_unretained id SELF = self;
    [SELF addStatusView:view animated:animated completion:^{
        [_stack addObject:view];

        if(completion) {
            completion();
        }
    }];
}               
               
- (void) popStatusViewAnimated:(BOOL) animated completion:(void (^)()) completion {

    SDKView* toHide = [_stack removeLastObject_fl];
            
    if(animated) {
        if(_stack.count >= 2) {
            SDKView* toShow = [_stack lastObject];
            [[FLFlipTransition transitionWithViewToShow:toShow viewToHide:toHide flipDirection:FLAnimationDirectionDown] startTransition:completion];
        }
        else {
        
           completion = FLCopyWithAutorelease(completion);
        
            [[FLFadeOutAnimation fadeOutAnimation] startAnimating:toHide completion:^(FLPromisedResult result) {
                [toHide removeFromSuperview];

                if(completion) {
                    completion();
                }
            }];
        }
    }
    else {
        [toHide removeFromSuperview];
        
        if(completion) {
            completion();
        }
    }
}

- (void) removeAllStatusViewsAnimated:(BOOL) animated completion:(void (^)()) completion{
    for(SDKView* view in _stack) {
        [view removeFromSuperview];
    }
    [_stack removeAllObjects];
    
    if(completion) {
        completion();
    }
}

//- (void) flipToNextNotificationViewWithDirection:(FLAnimationDirection) direction 
//                                        nextView:(SDKView*) nextView
//                                      completion:(void (^)()) completion {
//
//    completion = FLCopyWithAutorelease(completion);
//
//    FLFlipTransition* animation = [FLFlipTransition transitionWithViewToShow:nextView 
//                                                       viewToHide:self.notificationView];
//                                              
//    [animation startAnimating:^(FLPromisedResult result) {
//        [self.notificationView removeFromSuperview];
//        self.notificationView = nextView;
//        if(completion) {
//            completion();
//        }
//    }];
//}
//
//- (void) setNotificationView:(SDKView*) notificationView 
//                    animated:(BOOL) animated 
//                  completion:(void (^)()) completion {
//    
//    notificationView.frame = self.notificationViewEnclosure.bounds;
//    if(self.notificationView) {
//        if(animated) {
//            [self flipToNextNotificationViewWithDirection:FLAnimationDirectionDown nextView:notificationView completion:completion];
//        }
//        else {
//            [self.notificationView removeFromSuperview];
//            self.notificationView = notificationView;
//            [self.notificationViewEnclosure addSubview:notificationView];
//            
//            if(completion) completion();
//        }
//    }
//    else {
//        self.notificationView = notificationView;
//        [self.notificationViewEnclosure addSubview:notificationView];
//        if(completion) completion();
//    }
//}
//
//- (void) hideNotificationViewAnimated:(BOOL) animated 
//                  completion:(void (^)()) completion {
//
//    [self.notificationView removeFromSuperview];
//    self.notificationView = nil;
//    if(completion) completion();
//
//}                  


@end
#endif
