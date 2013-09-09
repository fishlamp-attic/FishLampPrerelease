//
//  _FLContentMode.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#ifdef __INLINES__

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

#endif