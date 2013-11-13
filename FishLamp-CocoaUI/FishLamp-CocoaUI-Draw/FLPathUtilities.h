//
//	FLPathUtilities.h
//	FishLamp
//
//	Created by Mike Fullerton on 3/16/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

extern void FLCreateRectPathWithCornerRadii(CGMutablePathRef path, SDKRect rect, CGFloat topLeft, CGFloat topRight, CGFloat bottomRight, CGFloat bottomLeft);

NS_INLINE 
void FLCreateRectPath(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius) {
	FLCreateRectPathWithCornerRadii(path, rect, cornerRadius, cornerRadius, cornerRadius, cornerRadius);
}

#define FLCreateRectPath(path, rect, cornerRadius) FLCreateRectPathWithCornerRadii(path, rect, cornerRadius, cornerRadius, cornerRadius, cornerRadius )

extern void FLCreateRectPathWithTopArrow(CGMutablePathRef path, SDKRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius);
extern void FLCreateRectPathWithRightArrow(CGMutablePathRef path, SDKRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius);
extern void FLCreateRectPathWithBottomArrow(CGMutablePathRef path, SDKRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius);
extern void FLCreateRectPathWithLeftArrow(CGMutablePathRef path, SDKRect rect, CGPoint arrowPoint, CGFloat arrowSize, CGFloat cornerRadius);

extern void FLCreatePartialRectPathTop(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius);
extern void FLCreatePartialRectPathLeft(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius);
extern void FLCreatePartialRectPathRight(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius);
extern void FLCreatePartialRectPathBottom(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius);

extern void FLCreateRectPathBackButtonShape(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius, CGFloat pointSize);
extern void FLCreateRectPathForwardButtonShape(CGMutablePathRef path, SDKRect rect, CGFloat cornerRadius, CGFloat pointSize);

typedef enum {
    FLTriangleCornerUpperLeft,
    FLTriangleCornerUpperRight,
    FLTriangleCornerBottomRight,
    FLTriangleCornerBottomLeft
} FLTriangleCorner;

extern void FLSetPathToTriangleInRectCorner(CGMutablePathRef path, 
    SDKRect rect, 
    FLTriangleCorner cornerInRect);