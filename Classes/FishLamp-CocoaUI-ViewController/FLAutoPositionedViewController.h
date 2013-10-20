//
//  FLAutoPositionedViewController.h
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 3/23/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

@interface SDKView (FLAutoPositionedViewController)
- (void) overrideViewPositionIfNeeded:(FLRectLayout*) position; // does nothing by default.
@end

@interface FLAutoPositionedViewController : FLCompatibleViewController {
@private
    FLRectLayout _viewPosition;
    CGFloat _viewAlpha;
}

// default view size, this is the size the view will START with
// but it'll probably be adusted by the view.
+ (CGSize) defaultAutoPostionedViewSize;

// this is passed onto the view. 
@property (readwrite, assign, nonatomic) CGFloat viewAlpha;

// this tells us how and where to position the view.
@property (readwrite, assign, nonatomic) FLRectLayout viewPosition;

// this will resize and reposition the view.
- (void) updateViewSizeAndPosition; // gets bounds from parentSuperviewController.view
- (void) updateViewSizeAndPosition:(CGRect) inBounds;


// override these.
- (void) sizeToFitInBounds:(CGRect) bounds;
- (SDKView*) createAutoPositionedViewWithFrame:(CGRect) frame;

// this is the bounds that the view will be shown in, adjusted for contents
// of view determined by FLViewContentsDescriptor.
- (CGRect) maxVisibleRect:(BOOL) adjustingForKeyboard;

- (void) viewMayOverridePosition;

@end
