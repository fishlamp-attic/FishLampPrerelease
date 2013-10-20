//
//	SDKImageView+FLViewGeometry.m
//	FishLamp
//
//	Created by Mike Fullerton on 10/17/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "SDKImageView+FLViewGeometry.h"
#import "SDKImage+Resize.h"

@implementation SDKImageView (FLViewGeometryUtils)

- (BOOL) resizeToImageSize {
	return FLViewSetFrame(self, FLRectSetSizeWithSize(self.frame, self.image.size));
}

- (CGRect) frameSizedToFitInSuperview:(BOOL) centerInSuperview
{
	SDKImage* image = self.image;
	if(image && self.superview)
	{
		CGRect superviewBounds = self.superview.bounds;
		CGRect newFrame = FLRectFitInRectInRectProportionally(
			FLRectMakeWithSize(superviewBounds.size), 
			FLRectMakeWithSize(image.size));
			
		if(centerInSuperview)
		{
			newFrame = FLRectCenterRectInRect(superviewBounds, newFrame);
		}
		
		return newFrame;
	}
	
	return CGRectZero;
}

- (void) resizeProportionally:(CGSize) maxSize
{
//	  [self setViewSizeToImageSize];
	CGRect newBounds = [self.image proportionalBoundsWithMaxSize:maxSize];
	FLViewSetFrame(self, CGRectIntegral(FLRectSetSizeWithSize(self.frame, newBounds.size)));
}

@end