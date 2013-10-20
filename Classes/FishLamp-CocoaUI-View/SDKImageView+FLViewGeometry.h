//
//	SDKImageView+FLViewGeometry.h
//	FishLamp
//
//	Created by Mike Fullerton on 10/17/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "SDKView+FLViewGeometry.h"

@interface SDKImageView (FLViewGeometryUtils)
// return YES is frame was changed.
- (BOOL) resizeToImageSize;
- (void) resizeProportionally:(CGSize) maxSize;
@end

