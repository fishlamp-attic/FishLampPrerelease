//
//  FLColumnArrangement.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSingleRowColumnArrangement.h"

@implementation FLSingleRowColumnArrangement

- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                         inBounds:(CGRect) bounds {
	
    CGFloat colWidth = bounds.size.width;

	id adjustableView = nil;
	for(id object in objects) {
		if([object isHidden]) {
			continue;
		}
		
        if([object arrangeableGrowMode] == FLArrangeableGrowModeFlexibleWidth) {
			FLAssertWithComment(adjustableView == nil, @"only one flexible object supported");
			adjustableView = object;
		}
        else {
            colWidth -= [self frameForObject:object].size.width;
        }
	}
		
	CGPoint origin = bounds.origin;
    
    CGFloat bottom = bounds.origin.y;

	for(id object in objects) {
		if([object isHidden]) {
			continue;
		}
		
		CGRect frame = [self frameForObject:object];
        
        frame.origin = origin;
        
        if(object == adjustableView) {
            frame.size.width = colWidth;
        }
        
        frame = [self setFrame:frame forObject:object];
	
        bottom = MAX(bottom, FLRectGetBottom(frame));
		origin.x += frame.size.width;
	}
    
    bounds.size.height = (bottom - bounds.origin.y);
    bounds.size.width = origin.x;
    return bounds.size;
}
@end
