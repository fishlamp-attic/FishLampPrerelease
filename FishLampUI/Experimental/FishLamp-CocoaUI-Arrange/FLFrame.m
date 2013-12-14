//
//  FLFrame.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFrame.h"

@implementation FLFrame

@synthesize controlState = _controlState;
@synthesize frame = _frame;
@synthesize hidden = _hidden;
@synthesize arrangeableWeight = _arrangeableWeight;
@synthesize arrangeableGrowMode = _arrangeableGrowMode;
@synthesize arrangeableInsets = _arrangeableInsets;
@synthesize arrangeableState = _arrangeableState;

- (CGRect) arrangeableFrame {
    return self.frame;
}

- (void) setArrangeableFrame:(CGRect) frame {
    self.frame = frame;
}

- (id) initWithFrame:(CGRect) rect {
    self = [super init];
    if(self) {
        self.frame = rect;
    }
    return self;
}

- (id) init {
    self = [self initWithFrame:CGRectZero];
    if(self) {
    }
    return self;
}

- (void) didChangeHidden {
}

- (void) setHidden:(BOOL) hidden {
    if(self.isHidden != hidden) {
        self.hidden = hidden;
        [self didChangeHidden];
    }
}

- (BOOL) pointIsInside:(CGPoint)point {
	return CGRectContainsPoint(self.frame, point);
}	

- (CGRect) frameOptimizedForLocation {
	return FLRectOptimizedForViewLocation(self.frame);
}

- (void) setFrameOptimizedForLocation:(CGRect) frame {
	self.frame = FLRectOptimizedForViewLocation(frame);
}

- (CGRect) frameOptimizedForSize {
	return FLRectOptimizedForViewSize(self.frame);
}

- (void) setFrameOptimizedForSize:(CGRect) frame {
	self.frame = FLRectOptimizedForViewSize(frame);
}

- (BOOL) isFrameOptimized {
	return FLRectIsOptimizedForView(self.frame);
}

- (void) moveFrameBy:(CGPoint) offset {
	self.frame = FLRectMoveWithPoint(self.frame, offset);
}

- (void) didChangeFrame {
}

- (void) setFrame:(CGRect) frame {

    if(!CGRectEqualToRect(self.frame, frame)) {
        _frame = frame;
        [self didChangeFrame];
    }
}

- (BOOL) isHighlighted {
	return FLTestBits(_controlState, FLControlStateHighlighted);
}

- (void) setHighlighted:(BOOL) highlighted {
    FLSetOrClearBits(_controlState, FLControlStateHighlighted, highlighted);
}

- (BOOL) isSelected {
	return FLTestBits(_controlState, FLControlStateSelected);
}

- (BOOL) isDoubleSelected {
	return FLTestBits(_controlState, FLControlStateDoubleSelected);
}

- (void) setSelected:(BOOL) selected {
    FLSetOrClearBits(_controlState, FLControlStateSelected, selected);
}

- (void) setDoubleSelected:(BOOL) selected {
    FLSetOrClearBits(_controlState, FLControlStateDoubleSelected, selected);
}

- (BOOL) isDisabled {
	return FLTestBits(_controlState, FLControlStateDisabled);
}

- (void) setDisabled:(BOOL) disabled {
    FLSetOrClearBits(_controlState, FLControlStateDisabled, disabled);
}

- (void) calculateArrangementSize:(CGSize*) outSize
                           inSize:(CGSize) inSize
                         fillMode:(FLArrangeableGrowMode) growMode {
}

@end
