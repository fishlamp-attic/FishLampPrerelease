//
//  FLAutoPositionedViewController.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 3/23/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAutoPositionedViewController.h"
#import "FLViewContentsDescriptor.h"
#import "FLViewController.h"

#if IOS
#import "FLKeyboardManager.h"
#endif

@implementation  SDKView (FLAutoPositionedViewController) 

- (void) overrideViewPositionIfNeeded:(FLRectLayout*) position {
}

@end


@interface FLAutoPositionedViewController ()
@end

@implementation FLAutoPositionedViewController

@synthesize viewPosition = _viewPosition;
@synthesize viewAlpha = _viewAlpha;

- (id) init {
    self = [super init];
    if(self) {
        self.viewPosition = FLRectLayoutCentered;   
    }
    return self;   
}

+ (CGSize) defaultAutoPostionedViewSize {
    return CGSizeMake(200,200);
}

- (BOOL) viewEnclosesStatusBar {
    return NO;
}

- (void) viewMayOverridePosition {
    [self.view overrideViewPositionIfNeeded:&_viewPosition];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self viewMayOverridePosition];
}

- (void) viewWillAppear:(BOOL) animated {
    [self updateViewSizeAndPosition:self.parentViewController.view.bounds];
    [super viewWillAppear:animated];
}

- (void) viewControllerWillAppear {
    [super viewControllerWillAppear];
    [self updateViewSizeAndPosition:self.parentViewController.view.bounds];
}

#if IOS
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateViewSizeAndPosition:self.parentViewController.view.bounds];
}
#endif

- (void) updateViewSizeAndPosition {
    [self updateViewSizeAndPosition:self.parentViewController.view.bounds];
}

- (void) updateViewSizeAndPosition:(CGRect) inBounds {
    [self sizeToFitInBounds:inBounds];
    self.view.frame = FLRectOptimizedForViewLocation(
        FLRectLayoutRectInRect([self contentViewFrameInBounds:inBounds],
        self.view.frame, self.viewPosition));
}

- (void) sizeToFitInBounds:(CGRect) bounds {
#if IOS
    [self.view sizeToFit];
#endif
}

- (CGRect) maxVisibleRect:(BOOL) adjustingForKeyboard {

	if(self.view.superview) {

		CGRect maxVisibleRect = self.view.superview.bounds;
		maxVisibleRect.origin.y = self.contentViewInsetTop; 
		maxVisibleRect.size.height -= (maxVisibleRect.origin.y);

		maxVisibleRect.origin.x = self.contentViewInsetLeft; 
		maxVisibleRect.size.width -= (maxVisibleRect.origin.x);
		maxVisibleRect.size.width -= self.contentViewInsetRight;

#if OSX 
        maxVisibleRect.size.height -= self.contentViewInsetBottom;
#else        
		CGRect keyboardRect = CGRectZero;
		if(adjustingForKeyboard) {
			keyboardRect = FLRectJustifyRectInRectBottom(maxVisibleRect, [[FLKeyboardManager instance] keyboardRectForView:self.view.superview]);
		}

        if(adjustingForKeyboard){
            maxVisibleRect.size.height -= keyboardRect.size.height;
        }
        else {
            maxVisibleRect.size.height -= self.contentViewInsetBottom;
        }
        
#endif         
		return maxVisibleRect;
	}
	
	return CGRectZero;
}

- (SDKView*) createAutoPositionedViewWithFrame:(CGRect) frame {
    return nil;
}

- (SDKView*) createView {
    return [self createAutoPositionedViewWithFrame:FLRectMakeWithSize([[self class] defaultAutoPostionedViewSize])];
}
@end
