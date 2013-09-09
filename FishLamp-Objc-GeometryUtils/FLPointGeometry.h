//
//	CGPoint.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCocoaRequired.h"
#define FLCoordinateIntegral(__coordinate__) (CGFloat) round(__coordinate__)

#define FLPointMake             CGPointMake
#define FLPointEqualToPoint     CGPointEqualToPoint
#define FLPointsAreEqual        CGPointEqualToPoint

//#if IOS
//
//#else
//    #define FLPointFromString       NSPointFromString
//    #define FLStringFromPoint       NSStringFromPoint
//    #define FLPointMake             CGPointMake
//#endif


NS_INLINE
BOOL FLPointIsIntegral(CGPoint p) {
	return FLIsIntegralValue(p.x) && FLIsIntegralValue(p.y); 
}

NS_INLINE
CGPoint FLPointIntegral(CGPoint pt) {
	pt.x = FLCoordinateIntegral(pt.x);
	pt.y = FLCoordinateIntegral(pt.y);
	return pt;
}

NS_INLINE
CGPoint FLPointInvert(CGPoint pt) {
	pt.x *= (CGFloat)-1.0;
	pt.y *= (CGFloat)-1.0;
	return pt;
}

#define FLPointMakeIntegral(__x__, __y__) \
	FLPointMake(FLCoordinateIntegral(__x__), FLCoordinateIntegral(__y__))


NS_INLINE 
CGFloat FLDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return (CGFloat) sqrt(dx*dx + dy*dy );
}

NS_INLINE
BOOL FLPointIsEmpty(CGPoint pt) {
	return FLFloatEqualToZero(pt.x) && FLFloatEqualToZero(pt.y);
}

NS_INLINE
CGPoint FLPointAddPointToPoint(CGPoint pt, CGPoint addToPoint) {
	pt.x += addToPoint.x;
	pt.y += addToPoint.y;
	return pt;
}

NS_INLINE
CGPoint FLPointSubtractPointFromPoint(CGPoint point, CGPoint subtractFromPoint) {
	point.x -= subtractFromPoint.x;
	point.y -= subtractFromPoint.y;
	return point;
}


NS_INLINE
CGPoint FLPointSwapCoordinates(CGPoint pt) {
	return FLPointMake(pt.y, pt.x);
}

NS_INLINE
CGPoint FLPointScale(CGPoint pt, CGFloat scale) {
	pt.x *= scale;
	pt.y *= scale;
	
	return pt;
}

NS_INLINE
CGPoint FLPointMove(CGPoint pt, CGFloat xDelta, CGFloat yDelta) {
	pt.x += xDelta;
	pt.y += yDelta;
	return pt;
}