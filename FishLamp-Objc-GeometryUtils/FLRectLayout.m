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

#if DEBUG
#define __INLINES__
#import "FLRectLayout_Inlines.h"
#undef __INLINES__
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
																				
