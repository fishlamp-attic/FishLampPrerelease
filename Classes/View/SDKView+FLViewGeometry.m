//
//	SDKView+FLViewGeometry.m
//	FishLamp
//
//	Created by Mike Fullerton on 10/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKView+FLViewGeometry.h"

@implementation SDKView (FLViewGeometry)

+ (id) viewWithFrame:(CGRect) frame {
    return FLAutorelease([[[self class] alloc] initWithFrame:frame]);
}

- (void) moveBy:(CGPoint) delta {
	if(delta.x != 0.0f || delta.y != 0.0f) {
		CGRect frame = self.frame;
		frame.origin.x += delta.x;
		frame.origin.y += delta.y;
		self.frame = frame;
	}
}

- (void) moveBy:(CGFloat) x y:(CGFloat)y {
	if(x != 0.0f || y != 0.0f) {
		CGRect frame = self.frame;
		frame.origin.x += x;
		frame.origin.y += y;
		self.newFrame = frame;
	}
}

- (void) resize:(CGSize) newSize {
	self.newFrame = FLRectSetSizeWithSize(self.frame, newSize);
}

- (void) moveTo:(CGPoint) newOrigin {
	self.newFrame = FLRectSetOrigin(self.frame, newOrigin.x, newOrigin.y);
}

- (void) moveTo:(CGFloat) left top:(CGFloat) top {
	self.newFrame = FLRectSetOrigin(self.frame, left, top);
}

#if DEBUG
+ (void) warnIfNonIntegralFramesInViewHierarchy:(SDKView*) view {
	while(view) {
		if(!FLRectIsIntegral(view.frame)) {
			FLLog(@"Warning a view of type '%@' has non-integral frame: %@", 
				NSStringFromClass([view class]),
				NSStringFromCGRect(view.frame));
		}		 
		view = view.superview;
	}
}

#if IOS
- (SDKColor*) debugBackgroundColor {
    return self.backgroundColor;
}

- (void) setDebugBackgroundColor:(SDKColor*) color {
    self.backgroundColor = color;
}
#endif

#endif

- (CGRect) frameOptimizedForLocation {
	return FLRectOptimizedForViewLocation(self.frame);
}

- (void) setFrameOptimizedForLocation:(CGRect) frame {
	self.newFrame = FLRectOptimizedForViewLocation(frame);
}

- (CGRect) frameOptimizedForSize {
	return FLRectOptimizedForViewSize(self.frame);
}

- (void) setFrameOptimizedForSize:(CGRect) frame {
	self.newFrame = FLRectOptimizedForViewSize(frame);
}

- (BOOL) isFrameOptimized {
	return FLRectIsOptimizedForView(self.frame);
}

- (CGRect) newFrame {
	return self.frame;
}

- (void) setNewFrame:(CGRect) newFrame {
#if DEBUG
	if(!FLRectIsIntegral(newFrame)) {
		FLLog(@"Warning setting non-integral rect in view: %@", NSStringFromCGRect(newFrame));
	}
#endif	  

	if(!CGRectEqualToRect(newFrame, self.frame)) {
		self.frame = newFrame;
	}
	
#if DEBUG
	[SDKView warnIfNonIntegralFramesInViewHierarchy:self];
#endif
}

- (BOOL) setFrameIfChanged:(CGRect) newFrame {
	
    if(!CGRectEqualToRect(newFrame, self.frame)) {
		self.frame = newFrame;
		return YES;
	}
	
	return NO;
}

- (BOOL) setBoundsIfChanged:(CGRect) newBounds {
	
    if(!CGRectEqualToRect(newBounds, self.bounds)) {
		self.bounds = newBounds;
		return YES;
	}
	
	return NO;
}
#if DEBUG
//- (NSMutableString*) debugDescription
//{	  
//	  NSMutableString* str = [super debugDescription];
//	  [str appendFormat:@"\nview bounds: %@\nview frame: %@\nsuperview bounds: %@", 
//			  NSStringFromCGRect(self.bounds), 
//			  NSStringFromCGRect(self.frame), 
//			  NSStringFromCGRect(self.superview.bounds)];
//	  return str;
//}
#endif

- (CGRect) frameSizedToFitInSuperview:(BOOL) centerInSuperview {
	return self.superview ? self.superview.bounds : CGRectZero;
}

- (CGSize) sizeThatFitsInSuperview {
	return self.superview ? [self frameSizedToFitInSuperview:NO].size : CGSizeZero;
}

- (BOOL) setViewSizeToFitInSuperview:(BOOL) centerInSuperview {
	if(self.superview) {
		return [self setFrameIfChanged:[self frameSizedToFitInSuperview:centerInSuperview]];
	}
	
	return NO;
}

- (BOOL) setViewSizeToContentSize {
	return NO;
}

- (id) objectByMoniker:(id) aMoniker {
    id outObj = [self objectByMoniker:aMoniker];
    if(!outObj) {
        for(SDKView* view in self.subviews) {
            outObj = [view objectByMoniker:aMoniker];
            if(outObj) {
                break;
            }
        }
    }

    return outObj;
}

@end
