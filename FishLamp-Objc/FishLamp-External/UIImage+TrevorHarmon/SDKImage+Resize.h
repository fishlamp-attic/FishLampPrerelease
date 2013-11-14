// SDKImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the SDKImage class to support resizing/cropping
#import "FishLampMinimum.h"
#import "FLCompatibility.h"

@interface SDKImage (Resize)

#if IOS
- (SDKImage *)croppedImage:(CGRect)bounds;

- (SDKImage *)thumbnailImage:(NSInteger)thumbnailSize
		  transparentBorder:(NSUInteger)borderSize
			   cornerRadius:(NSUInteger)cornerRadius
	   interpolationQuality:(CGInterpolationQuality)quality
				 makeSquare:(BOOL) makeSquare;

- (SDKImage *)resizedImage:(CGSize)newSize
	 interpolationQuality:(CGInterpolationQuality)quality;

- (SDKImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
								  bounds:(CGSize)bounds
					interpolationQuality:(CGInterpolationQuality)quality;

#endif

- (CGRect) proportionalBoundsWithMaxSize:(CGSize) maxSize;

- (CGSize) proportionalSizeWithMaxSize:(CGSize) maxSize;

@end
