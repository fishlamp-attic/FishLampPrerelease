//
//	FLGeometry.m
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRectGeometry.h"

#if DEBUG
#define __INLINES__
#include "FLRectGeometry_Inlines.h"
#include "FLRectOptimize_Inlines.h"
#undef __INLINES__
#endif

CGRect FLRectFillRectInRectProportionally(CGRect container, CGRect containee) {
	CGFloat horizScale = container.size.width / containee.size.width;
	CGFloat vertScale = container.size.height / containee.size.height;
	
	CGFloat scale = MAX(horizScale, vertScale);
	
	containee.size.width *= scale;
	containee.size.height *= scale;
	
	return containee;
}

CGRect FLRectFitInRectInRectProportionally(CGRect container, CGRect containee) {
	CGFloat horizScale = container.size.width / containee.size.width;
	CGFloat vertScale = container.size.height / containee.size.height;
	
	CGFloat scale = MIN(vertScale, horizScale);
	
	containee.size.width *= scale;
	containee.size.height *= scale;
	
	return containee;
}

CGRect FLRectEnsureRectInRect(CGRect container, CGRect containee) {
	if(containee.origin.x < container.origin.x) {
		containee.origin.x = container.origin.x;
	}
	else if(FLRectGetRight(containee) > FLRectGetRight(container)) {
		containee.origin.x = FLRectGetRight(container) - containee.size.width;
	}
	
	if(containee.origin.y < container.origin.y) {
		containee.origin.y = container.origin.y;
	}
	else if(FLRectGetBottom(containee) > FLRectGetBottom(container)) {
		containee.origin.y = FLRectGetBottom(container) - containee.size.height;
	}
	
	return containee;
}

#if DEBUG

#if IOS
    #undef CGRectInset
#else
    #undef NSRectInset
#endif
 
CGRect FLRectInset(CGRect rect, CGFloat dx, CGFloat dy) {
    FLAssertWithComment(rect.size.width >= (dx * 2), @"trying to inset too narrow of a rect");
    FLAssertWithComment(rect.size.height >= (dy * 2), @"trying to inset too short of a rect");
    
#if IOS
    return CGRectInset(rect, dx, dy);
#else
    return NSInsetRect(rect, dx, dy);
#endif

}

#endif

