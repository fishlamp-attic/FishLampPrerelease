//
//	FLRectLayout.m
//	FishLamp
//
//	Created by Mike Fullerton on 2/13/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRectLayout.h"
#import "FLRectGeometry.h"

#ifdef FL_SHIP_ONLY_INLINE
#undef FL_SHIP_ONLY_INLINE
#define FL_SHIP_ONLY_INLINE
#endif

const struct FLRectLayout FLRectLayoutNone = {	FLRectLayoutHorizontalNone,	 FLRectLayoutVerticalNone, {0,0,0,0} };
const struct FLRectLayout FLRectLayoutFill = {	FLRectLayoutHorizontalFill, FLRectLayoutVerticalFill, {0,0,0,0}};
const struct FLRectLayout FLRectLayoutCentered = { FLRectLayoutHorizontalCentered, FLRectLayoutVerticalCentered, {0,0,0,0}};
const struct FLRectLayout FLRectLayoutAspectFit = {	FLRectLayoutHorizontalFit, FLRectLayoutVerticalFit, {0,0,0,0} };
const struct FLRectLayout FLRectLayoutCenteredTop = {	FLRectLayoutHorizontalCentered, FLRectLayoutVerticalTop, {0,0,0,0} };
const struct FLRectLayout FLRectLayoutCenteredBottom = {	FLRectLayoutHorizontalCentered, FLRectLayoutVerticalBottom, {0,0,0,0} };

CGRect FLRectLayoutRectVerticallyInRect(
        CGRect containerRect,
        CGRect containeeRect,
		FLRectLayout contentMode ) {
	
    switch(contentMode.vertical) {
		case FLRectLayoutVerticalTop:
			containeeRect = FLRectSetTop(containeeRect, contentMode.insets.top);
			break;
		
		case FLRectLayoutVerticalFill:
			containeeRect.origin.y = containerRect.origin.y;
			containeeRect.size.height = containerRect.size.height;

			containeeRect = FLRectInsetTop(containeeRect, contentMode.insets.top);
			containeeRect = FLRectInsetBottom(containeeRect, contentMode.insets.bottom);
		break;

		case FLRectLayoutVerticalCentered:
			containeeRect = FLRectCenterRectInRectVertically(containerRect, containeeRect);
			break;
		
		case FLRectLayoutVerticalTopThird:
			containeeRect.origin.y = (containerRect.size.height	 * 0.33) - (containeeRect.size.height * 0.5f);
			break;
   
		case FLRectLayoutVerticalBottomThird:
			containeeRect.origin.y = ((containerRect.size.height * 0.33) * 2.0f) - (containeeRect.size.height * 0.5f);
			break;
				 
		case FLRectLayoutVerticalBottom:
			containeeRect.origin.y = containerRect.size.height - containeeRect.size.height - contentMode.insets.top;
			break;
			
		case FLRectLayoutVerticalNone:
			break;
            
        case FLRectLayoutVerticalFit:
            break;
	
	}	
	
    return containeeRect;
}


CGRect FLRectLayoutRectHorizonallyInRect(
	CGRect containerRect,
	CGRect containeeRect,
	FLRectLayout contentMode)
{
	switch(contentMode.horizontal) {
		case FLRectLayoutHorizontalLeftThird:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.33f) - (containeeRect.size.width * 0.5f));
			break;

		case FLRectLayoutHorizontalLeftQuarter:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.25f) - (containeeRect.size.width * 0.5f));
			break;
		
		case FLRectLayoutHorizontalLeft:
			containeeRect.origin.x = containerRect.origin.x + contentMode.insets.left;
			break;

		case FLRectLayoutHorizontalRightThird:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.66f) - (containeeRect.size.width * 0.5f));
			break;

		case FLRectLayoutHorizontalRightQuarter:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.75f) - (containeeRect.size.width * 0.5f));
			break;

		case FLRectLayoutHorizontalRight:
			containeeRect.origin.x = FLRectGetRight(containerRect) - containeeRect.size.width - contentMode.insets.right;
			break;

		case FLRectLayoutHorizontalCentered:
			containeeRect = FLRectCenterRectInRectHorizontally(containerRect, containeeRect);
			break;

		case FLRectLayoutHorizontalNone:
			break;
			
		case FLRectLayoutHorizontalFill:
			containeeRect.size.width = (containerRect.size.width - contentMode.insets.left - contentMode.insets.right);
			containeeRect = FLRectCenterRectInRectHorizontally(containerRect, containeeRect);
			break;
            
        case FLRectLayoutHorizontalFit:
        break;
		
	}

    return containeeRect;
}
																				
FL_SHIP_ONLY_INLINE
BOOL FLRectLayoutsAreEqual(FLRectLayout lhs, FLRectLayout rhs)
{
	return  lhs.horizontal == rhs.horizontal && 
            lhs.vertical == rhs.vertical &&
            UIEdgeInsetsEqualToEdgeInsets(lhs.insets, rhs.insets);

}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutMake(	FLRectLayoutHorizontal horizontalLayout, 
									FLRectLayoutVertical verticalLayout)
{
	FLRectLayout loc;
	loc.horizontal = horizontalLayout;
	loc.vertical = verticalLayout;
	loc.insets = UIEdgeInsetsZero;
	return loc;
}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutMakeWithInsets(	FLRectLayoutHorizontal horizontalLayout,
                                            FLRectLayoutVertical verticalLayout,
                                            UIEdgeInsets insets)
{
	FLRectLayout loc;
	loc.horizontal = horizontalLayout;
	loc.vertical = verticalLayout;
	loc.insets = insets;
	return loc;
}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutSetVertical(FLRectLayout rectLayout, FLRectLayoutVertical vertical)
{
	rectLayout.vertical = vertical;
	return rectLayout;
}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutSetHorizontal(FLRectLayout loc, FLRectLayoutHorizontal horizontal)
{
	loc.horizontal = horizontal;
	return loc;
}

FL_SHIP_ONLY_INLINE
BOOL FLRectLayoutIsValid(FLRectLayout loc)
{
	return	loc.horizontal >= FLRectLayoutHorizontalNone && loc.vertical >= FLRectLayoutVerticalNone;
}

FL_SHIP_ONLY_INLINE
BOOL FLRectLayoutNotNone(FLRectLayout loc)
{
	return	loc.horizontal > FLRectLayoutHorizontalNone || loc.vertical > FLRectLayoutVerticalNone;
}

FL_SHIP_ONLY_INLINE
CGRect FLRectLayoutRectInRect(
	CGRect containerRect,
	CGRect containeeRect,
    FLRectLayout rectLayout)
{
	return FLRectLayoutRectHorizonallyInRect(
		containerRect,
		FLRectLayoutRectVerticallyInRect(containerRect, containeeRect, rectLayout),
		rectLayout);
}
