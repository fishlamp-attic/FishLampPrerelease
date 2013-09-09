//
//	CGRect.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLMath.h"
#import "FLPointGeometry.h"
#import "FLCompatibility.h"

#if DEBUG
    #define CGRectInset             FLRectInset
#else
    #define FLRectInset             CGRectInset
#endif

#define FLRectMake                  CGRectMake
//#define FLRectIntegral(r)           

NS_INLINE
CGRect FLRectIntegral(CGRect r) {
    r.origin.x = floor(r.origin.x);
    r.origin.y = floor(r.origin.y);
    r.size.width = ceil(r.size.width);
    r.size.height = ceil(r.size.height);
    return r;
}

#define FLRectGetMidX               CGRectGetMidX
#define FLRectGetMidY               CGRectGetMidY
#define FLRectEqualToRect           CGRectEqualToRect

#define FLRectMakeIntegral(__x__, __y__, __width__, __height__) \
	 FLRectIntegral(FLRectMake(__x__,__y__,__width__,__height__))

#define FLRectIsTaller(__lhs__, __rhs__) ((__lhs__).size.height > (__rhs___).size.height)
#define FLRectIsWider(__lhs__, __rhs__) ((__lhs__).size.width > (__rhs__).size.width)
#define FLRectGetLeft(__rect__) ((__rect__)).origin.x
#define FLRectGetTop(__rect__) ((__rect__)).origin.y
#define FLRectGetTopLeft(__rect__) (__rect__).origin

#if IOS
    #define FLRectInsetWithEdgeInsets   UIEdgeInsetsInsetRect
#endif    


//#if OSX
//    #if DEBUG
//        #define NSRectInset             FLRectInset
//    #else
//        #define FLRectInset             NSRectInset
//    #endif
//    
//    #define FLStringFromRect         NSStringFromRect
//    #define FLRectFromString            NSRectFromString
//    #define FLRectMake                  NSMakeRect
//    #define FLRectIntegral              NSIntegralRect
//    #define FLRectGetMidX               NSMidX
//    #define FLRectGetMidY               NSMidY
//    #define FLRectEqualToRect           NSEqualRects
//    #define CGRectZero                  NSZeroRect
//    
//#endif



#if DEBUG

extern BOOL FLRectIsIntegral(CGRect r);

// centering
extern CGRect FLRectCenterOnPoint(CGRect rect, CGPoint point);
extern CGRect FLRectCenterOnPointVertically(CGRect rect, CGPoint point);
extern CGRect FLRectCenterOnPointHorizontally(CGRect rect, CGPoint point);

extern CGPoint FLRectGetCenter(CGRect rect);
extern CGRect FLRectCenterRectInRect(CGRect container, CGRect containee);
extern CGRect FLRectCenterRectInRectVertically(CGRect container, CGRect containee);
extern CGRect FLRectCenterRectInRectHorizontally(CGRect container, CGRect containee);

// justification
extern CGRect FLRectJustifyRectInRectRight(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectLeft(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectTop(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectBottom(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectTopLeft(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectTopRight(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectBottomRight(CGRect container, CGRect containee);
extern CGRect FLRectJustifyRectInRectBottomLeft(CGRect container, CGRect containee);

// inset
// this is a debugging only function that asserts that you're insetting with a reasonable
// value. Debug only. Ship calls CGRectInset/NSRectInset
extern CGRect FLRectInset(CGRect rect, CGFloat dx, CGFloat dy);

extern CGRect FLRectInsetTop(CGRect inRect, CGFloat delta);
extern CGRect FLRectInsetBottom(CGRect inRect, CGFloat delta);
extern CGRect FLRectInsetLeft(CGRect inRect, CGFloat delta);
extern CGRect FLRectInsetRight(CGRect inRect, CGFloat delta);
#if OSX
extern CGRect FLRectInsetWithEdgeInsets(CGRect inRect, UIEdgeInsets insets);
#endif

// layout
extern CGRect FLRectAlignRectsHorizonally(CGRect left, CGRect right);
extern CGRect FLRectAlignRectVertically(CGRect top, CGRect bottom);
extern CGRect FLRectPositionRectInRectVerticallyBottomThird(CGRect container, CGRect containee);
extern CGRect FLRectPositionRectInRectVerticallyTopThird(CGRect container, CGRect containee);
//	This scales the containee rect to completely fill the container.
//	The containee rect is scaled proportionally so if it has a different
//	aspect ratio than the container, it WILL be larger than the container rect.
extern CGRect FLRectFillRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect FLRectFitInRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect FLRectEnsureRectInRect(CGRect container, CGRect containee);

// size
extern CGRect FLRectSetHeight(CGRect rect, CGFloat height);
extern CGRect FLRectAddHeight(CGRect rect, CGFloat height);
extern CGRect FLRectSetWidth(CGRect rect, CGFloat width);
extern CGRect FLRectAddWidth(CGRect rect, CGFloat width);
extern CGRect FLRectSetSize(CGRect rect, CGFloat width, CGFloat height);
extern CGRect FLRectAddSize(CGRect rect, CGFloat width, CGFloat height);
extern CGRect FLRectAddSizeWithSize(CGRect rect, CGSize size);
extern CGRect FLRectSetSizeWithSize(CGRect rect, CGSize size);
extern CGRect FLRectScale(CGRect rect, CGFloat scaleFactor);

// location
extern CGRect FLRectSetTop(CGRect rect, CGFloat top);
extern CGRect FLRectSetLeft(CGRect rect, CGFloat left);

// edges and corners
extern CGFloat FLRectGetRight(CGRect rect);
extern CGFloat FLRectGetBottom(CGRect rect);
extern CGPoint FLRectGetTopRight(CGRect rect);
extern CGPoint FLRectGetBottomRight(CGRect rect);
extern CGPoint FLRectGetBottomLeft(CGRect rect);

// location
extern CGRect FLRectSetOrigin(CGRect rect, CGFloat x, CGFloat y);
extern CGRect FLRectSetOriginWithPoint(CGRect rect, CGPoint origin);
extern CGRect FLRectMoveWithPoint(CGRect rect, CGPoint delta);
extern CGRect FLRectMoveVertically(CGRect rect, CGFloat delta);
extern CGRect FLRectMoveHorizontally(CGRect rect, CGFloat delta);
extern CGRect FLRectMove(CGRect rect, CGFloat xDelta, CGFloat yDelta);

// construction
extern CGRect FLRectMakeWithSize(CGSize size);
extern CGRect FLRectMakeWithWidthAndHeight(CGFloat width, CGFloat height);

// misc
extern BOOL FLRectEnclosesRect(CGRect container, CGRect containee);
extern CGRect FLRectRotate90Degrees(CGRect rect);


#else

#define __INLINES__
#include "FLRectGeometry_Inlines.h"
#undef __INLINES__

//	This scales the containee rect to completely fill the container.
//	The containee rect is scaled proportionally so if it has a different
//	aspect ratio than the container, it WILL be larger than the container rect.
extern CGRect FLRectFillRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect FLRectFitInRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect FLRectEnsureRectInRect(CGRect container, CGRect containee);

#endif

