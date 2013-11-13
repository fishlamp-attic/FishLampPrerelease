//	SDKPoint.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "CGRectGeometry+FLAdditions.h"

#define NSPointIsIntegral(p) \
            NSPointFromCGPoint((CGPointIsIntegral(NSPointToCGPoint(pt)))

#define NSPointIntegral(pt) \
            NSPointFromCGPoint((CGPointIntegral(NSPointToCGPoint(pt)))

#define NSPointInvert(pt) \
            NSPointFromCGPoint(CGPointInvert(NSPointToCGPoint(pt)))

#define NSPointMakeIntegral(__x__, __y__) \
            NSPointFromCGPoint(CGPointMakeIntegal(__x__, __y__))

#define  FLDistanceBetweenTwoPoints(point1, point2) \
            CGDistanceBetweenTwoPoints(NSPointToCGPoint(point1), NSPointToCGPoint(point2))

#define NSPointIsEmpty(pt) \
            NSPointIsEmpty(NSPointToCGPoint(pt))

#define NSPointAddPointToPoint(pt, addToPoint) \
            NSPointFromCGPoint(CGPointAddPointToPoint(NSPointToCGPoint(pt), (CGPoint)addToPoint))

#define NSPointSubtractPointFromPoint(point, subtractFromPoint) \
            NSPointFromCGPoint(CGPointSubtractPointFromPoint(NSPointToCGPoint(pt), (CGPoint)addToPoint))

#define NSPointSwapCoordinates(pt) \
            NSPointFromCGPoint(CGPointSwapCoordinates(NSPointToCGPoint(pt)))

#define NSPointScale(pt, scale) \
            NSPointFromCGPoint(CGPointScale(NSPointToCGPoint(pt), scale))

#define NSPointMove(pt, xDelta, yDelta) \
            NSPointFromCGPoint(NSPointMove(NSPointToCGPoint(pt), xDelta, yDelta))
