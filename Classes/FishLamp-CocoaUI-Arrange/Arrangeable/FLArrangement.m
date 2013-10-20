//
//  FLArrangement.m
//  FishLamp
//
//  Created by Mike Fullerton on 6/6/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangement.h"

// - (UIEdgeInsets) addInnerInsetsToOuterInsets:(UIEdgeInsets) innerInsets;

@implementation FLArrangement

@synthesize outerInsets = _outerInsets;
@synthesize innerInsets = _innerInsets;
@synthesize onWillArrange = _onWillArrange;
@synthesize frameSetter = _frameSetter;

+ (id) arrangement {
	return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    self = [super init];
    if(self) {
        self.frameSetter = [FLArrangement defaultFrameSetter];
    }
    
    return self;
}

#if DEBUG
- (void) dealloc {
    FLRelease(_frameSetter);
    FLRelease(_onWillArrange);
    FLSuperDealloc();
}
#endif

- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                           inBounds:(CGRect) bounds {
    return bounds.size;
}

- (CGSize) performArrangement:(NSArray*) arrangeableFrames 
                inBounds:(CGRect) bounds {

    if(_onWillArrange) {
        _onWillArrange(self, bounds);
    }   
    
    CGSize layoutSize = [self layoutArrangeableObjects:arrangeableFrames
                                              inBounds:FLRectInsetWithEdgeInsets(bounds, self.outerInsets)];
    
    layoutSize.width += (self.outerInsets.left + self.outerInsets.right);
    layoutSize.height += (self.outerInsets.top + self.outerInsets.bottom);
    return layoutSize;
}

- (UIEdgeInsets) addInnerInsetsToOuterInsets:(UIEdgeInsets) innerInsets {
    UIEdgeInsets insets = self.outerInsets;
    insets.top += innerInsets.top;
    insets.bottom -= innerInsets.bottom;
    insets.left += innerInsets.left;
    insets.right -= innerInsets.right;
	return insets;
}

NS_INLINE
CGRect FLArrangeableStateCalcFrame(FLArrangeableState state, CGRect frame) {
    if(FLRectEqualToRect(frame, state._lastFrame)) {
        frame.origin.x -= state._lastInsets.left;
        frame.origin.y -= state._lastInsets.top;
        frame.size.width += (state._lastInsets.left + state._lastInsets.right);
        frame.size.height += (state._lastInsets.top + state._lastInsets.bottom);
    }

    return frame;
}
- (CGRect) setFrame:(CGRect) frame
          forObject:(id) object {

    FLArrangeableState state = [object arrangeableState];
    UIEdgeInsets insets = [self addInnerInsetsToOuterInsets:state._lastInsets];
    CGRect newFrame = FLRectInsetWithEdgeInsets(frame, insets);
    
    FLArrangeableGrowMode growMode = [object arrangeableGrowMode];
    
    if( growMode == FLArrangeableGrowModeGrowWidth ||
        growMode == FLArrangeableGrowModeGrowHeight) {
        CGSize size = newFrame.size;
        [object calculateArrangementSize:&size inSize:newFrame.size fillMode:growMode];
        
        newFrame.size = size;
    }
    
    if(!FLRectEqualToRect([object frame], newFrame)) {
        self.frameSetter(object, newFrame);
        state._lastInsets = insets;
        state._lastFrame = [object frame];
        [object setArrangeableState:state];
    }

    return frame;
}

- (CGRect) frameForObject:(id) object {
    return FLArrangeableStateCalcFrame([object arrangeableState], [object frame]);
}

//- (CGRect) padFrameForArrangeableFrame:(id) arrangeableFrame unpaddedRect:(CGRect) unpaddedRect {
//    
//    UIEdgeInsets padding = [self addouterInsetsToInsets:[arrangeableFrame innerInsets]];
//    unpaddedRect.origin.x += padding.left;
//    unpaddedRect.origin.y += padding.top;
//    unpaddedRect.size.width -= padding.left + padding.right;
//    unpaddedRect.size.height -= padding.top + padding.bottom;
//    return unpaddedRect;
//} 

static FLArrangementFrameSetter s_frameSetter = ^(id arrangeableFrame, CGRect frame) { 
        [arrangeableFrame setFrame:frame];
    };
    
+ (FLArrangementFrameSetter) defaultFrameSetter {
    return s_frameSetter;
}

static FLArrangementFrameSetter s_size_setter = ^(id arrangeableFrame, CGRect frame) { 
    [arrangeableFrame setFrame:FLRectOptimizedForViewSize(frame)];
};

+ (FLArrangementFrameSetter) optimizedForSizeFrameSetter {
    return s_size_setter;
}

static FLArrangementFrameSetter s_location_setter = ^(id arrangeableFrame, CGRect frame) { 
    [arrangeableFrame setFrame:FLRectOptimizedForViewLocation(frame)];
};

+ (FLArrangementFrameSetter) optimizedForLocationFrameSetter {
    return s_location_setter;
}



@end













