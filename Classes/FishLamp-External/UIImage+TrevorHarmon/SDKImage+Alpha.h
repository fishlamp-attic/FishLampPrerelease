// SDKImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "FishLampMinimum.h"
#import "FLCompatibility.h"

// Helper methods for adding an alpha layer to an image
@interface SDKImage (Alpha)
- (BOOL)hasAlpha;
- (SDKImage *)imageWithAlpha;
- (SDKImage *)transparentBorderImage:(NSUInteger)borderSize;
@end
