//
//  FLRightJustifiedColumnArrangement.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRightJustifiedColumnArrangement.h"

@implementation FLRightJustifiedColumnArrangement 

- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                           inBounds:(CGRect) bounds {

	CGPoint topRight = FLRectGetTopRight(bounds);
   
    CGFloat bottom = bounds.origin.y ;

	for(id object in objects.reverseObjectEnumerator) {
		if([object isHidden]) {
			continue;
		}
		
        CGRect frame = [self frameForObject:object];
        
        topRight.x -= frame.size.width;
	
        frame = [self setFrame:frame forObject:object];

        bottom = MAX(bottom, FLRectGetBottom(frame));
    }
    
    bounds.size.height = (bottom - bounds.origin.y);
    return bounds.size;
}


@end