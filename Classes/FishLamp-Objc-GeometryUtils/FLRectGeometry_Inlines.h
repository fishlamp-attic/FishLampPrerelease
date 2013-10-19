#ifdef __INLINES__

    #define FLRectMake                  CGRectMake
    #define FLRectGetMidX               CGRectGetMidX
    #define FLRectGetMidY               CGRectGetMidY
    #define FLRectEqualToRect           CGRectEqualToRect
    #define FLRectIsTaller(__lhs__, __rhs__) ((__lhs__).size.height > (__rhs___).size.height)
    #define FLRectIsWider(__lhs__, __rhs__) ((__lhs__).size.width > (__rhs__).size.width)
    #define FLRectGetLeft(__rect__) ((__rect__)).origin.x
    #define FLRectGetTop(__rect__) ((__rect__)).origin.y
    #define FLRectGetTopLeft(__rect__) (__rect__).origin


FL_SHIP_ONLY_INLINE 
CGRect FLRectCenterOnPoint(CGRect rect, CGPoint point) {
	rect.origin.x = point.x - (rect.size.width * 0.5f);
	rect.origin.y = point.y - (rect.size.height * 0.5f);
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectCenterOnPointHorizontally(CGRect rect, CGPoint point) {
	rect.origin.x = point.x - (rect.size.width * 0.5f);
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectCenterOnPointVertically(CGRect rect, CGPoint point) {
	rect.origin.y = point.y - (rect.size.height * 0.5f);
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGPoint FLRectGetCenter(CGRect rect) {
	return FLPointMake(FLRectGetMidX(rect), FLRectGetMidY(rect));
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectCenterRectInRect(CGRect container, CGRect containee) {
	containee.origin.x = FLRectGetMidX(container) - (containee.size.width * 0.5f);
	containee.origin.y = FLRectGetMidY(container) - (containee.size.height * 0.5f);
    return containee;
}

FL_SHIP_ONLY_INLINE
CGRect FLRectCenterRectInRectVertically(CGRect container, CGRect containee) {
	containee.origin.y = FLRectGetMidY(container) - (containee.size.height * 0.5f);
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectCenterRectInRectHorizontally(CGRect container, CGRect containee) {
	containee.origin.x = FLRectGetMidX(container) - (containee.size.width * 0.5f);
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectRight(CGRect container, CGRect containee) {
	containee.origin.x = container.origin.x + container.size.width - containee.size.width;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectLeft(CGRect container, CGRect containee) {
	containee.origin.x = container.origin.x;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectTop(CGRect container, CGRect containee) {
	containee.origin.y = container.origin.y;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectBottom(CGRect container, CGRect containee) {
	containee.origin.y = (container.origin.y + container.size.height) - containee.size.height;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectTopLeft(CGRect container, CGRect containee) {
	containee.origin.y = container.origin.y;
	containee.origin.x = container.origin.x;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectTopRight(CGRect container, CGRect containee) {
	containee.origin.y = container.origin.y;
	containee.origin.x = container.origin.x + container.size.width - containee.size.width;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectBottomRight(CGRect container, CGRect containee) {
	containee.origin.y = container.origin.y + container.size.height - containee.size.height;
	containee.origin.x = container.origin.x + container.size.width - containee.size.width;
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectJustifyRectInRectBottomLeft(CGRect container, CGRect containee) {
	containee.origin.y = container.origin.y + container.size.height - containee.size.height;
	containee.origin.x = container.origin.x;
	return containee;
}

#if OSX
FL_SHIP_ONLY_INLINE 
CGRect FLRectInsetWithEdgeInsets(CGRect inRect, UIEdgeInsets insets) {
	inRect.size.height -= (insets.top + insets.bottom);
    inRect.size.width -= (insets.left + insets.right);
    inRect.origin.x += insets.left;
    inRect.origin.y += insets.top;
    return inRect;
}
#endif

FL_SHIP_ONLY_INLINE 
CGRect FLRectInsetTop(CGRect inRect, CGFloat delta) {
	inRect.size.height -= delta;
	inRect.origin.y += delta;
	return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectInsetBottom(CGRect inRect, CGFloat delta) {
		inRect.size.height -= delta;
	return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectInsetLeft(CGRect inRect, CGFloat delta) {
	inRect.size.width -= delta;
	inRect.origin.x += delta;
	return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectInsetRight(CGRect inRect, CGFloat delta) {
	inRect.size.width -= delta;
	return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectAlignRectsHorizonally(CGRect left, CGRect right) {
	right.origin.x = left.origin.x + left.size.width;
	return right;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetHeight(CGRect rect, CGFloat height) {
	rect.size.height = height;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectAddHeight(CGRect rect, CGFloat height) {
	rect.size.height += height;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetWidth(CGRect rect, CGFloat width) {
	rect.size.width = width;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectAddWidth(CGRect rect, CGFloat width) {
	rect.size.width += width;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetTop(CGRect rect, CGFloat top) {
	rect.origin.y = top;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetLeft(CGRect rect, CGFloat left) {
	rect.origin.x = left;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectAlignRectVertically(CGRect top, CGRect bottom) {
	bottom.origin.y = (top.origin.y + top.size.height);
	return bottom;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectRotate90Degrees(CGRect rect) {
	return FLRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectPositionRectInRectVerticallyBottomThird(CGRect container, CGRect containee) {
	containee.origin.y = ((container.size.height / 3)*2) - (containee.size.height/2);
	return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectPositionRectInRectVerticallyTopThird(CGRect container, CGRect containee) {
	containee.origin.y = (container.size.height / 3) - (containee.size.height/2);
	return containee;
}

FL_SHIP_ONLY_INLINE 
BOOL FLRectEnclosesRect(CGRect container, CGRect containee)  {
	return	containee.origin.x >= container.origin.x &&
			containee.origin.y >= container.origin.y &&
			(containee.origin.x + containee.size.width) <= (container.origin.x + container.size.width) &&
			(containee.origin.y + containee.size.height) <= (container.origin.y + container.size.height);
}

FL_SHIP_ONLY_INLINE 
CGFloat FLRectGetRight(CGRect rect) {
	return rect.origin.x + rect.size.width;
}

FL_SHIP_ONLY_INLINE 
CGFloat FLRectGetBottom(CGRect rect) {
	return rect.origin.y + rect.size.height;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectMoveWithPoint(CGRect rect, CGPoint delta) {
	rect.origin.x += delta.x;
	rect.origin.y += delta.y;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectMoveVertically(CGRect rect, CGFloat delta) {
	rect.origin.y += delta;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectMoveHorizontally(CGRect rect, CGFloat delta) {
	rect.origin.x += delta;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectMove(CGRect rect, CGFloat xDelta, CGFloat yDelta) {
	rect.origin.x += xDelta;
	rect.origin.y += yDelta;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGPoint FLRectGetTopRight(CGRect rect) {
	return FLPointMake(rect.origin.x + rect.size.width, rect.origin.y);
}

FL_SHIP_ONLY_INLINE 
CGPoint FLRectGetBottomRight(CGRect rect) {
	return FLPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

FL_SHIP_ONLY_INLINE 
CGPoint FLRectGetBottomLeft(CGRect rect) {
	return FLPointMake(rect.origin.x, rect.origin.y + rect.size.height);
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetOrigin(CGRect rect, CGFloat x, CGFloat y) {
	rect.origin.x = x;
	rect.origin.y = y;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetOriginWithPoint(CGRect rect, CGPoint origin) {
	rect.origin = origin;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetSize(CGRect rect, CGFloat width, CGFloat height) {
	rect.size.width = width;
	rect.size.height = height;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectAddSize(CGRect rect, CGFloat width, CGFloat height) {
	rect.size.width += width;
	rect.size.height += height;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectAddSizeWithSize(CGRect rect, CGSize size) {
	rect.size.width += size.width;
	rect.size.height += size.height;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectSetSizeWithSize(CGRect rect, CGSize size) {
	rect.size = size;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectScale(CGRect rect, CGFloat scaleFactor) {
	rect.size.width *= scaleFactor;
	rect.size.height *= scaleFactor;
	return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectMakeWithSize(CGSize size) {	
	return FLRectMake(0,0,size.width, size.height);
}

FL_SHIP_ONLY_INLINE 
CGRect FLRectMakeWithWidthAndHeight(CGFloat width, CGFloat height) {	
	return FLRectMake(0,0,width, height);
}

#endif



