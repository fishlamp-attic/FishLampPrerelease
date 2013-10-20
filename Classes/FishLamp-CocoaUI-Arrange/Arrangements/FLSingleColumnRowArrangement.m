//
//  FLSingleRowColumnArrangement.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSingleColumnRowArrangement.h"

@implementation FLSingleColumnRowArrangement

- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                           inBounds:(CGRect) bounds {

	CGFloat top = bounds.origin.y;
    
	for(id object in objects) {	
		if([object isHidden])  {
			continue;
		}
        
        CGRect frame = [object frameForObject:object];
        frame.origin = FLPointMake(bounds.origin.x, top);
        frame.size = CGSizeMake(bounds.size.width, frame.size.height);

        [object setArrangeableFrame:frame];
        
                        
//        CGSize size = [object calculateSizeInArrangementSize:CGSizeMake(width, [object frame].size.height) hint:[object arrangeableGrowMode]];
//        
//        setFrame(object, FLRectMake(left, top, size.width, size.height));
					
		top = FLRectGetBottom([object arrangeableFrame]);
    }
    
	return CGSizeMake(bounds.size.width, top - bounds.origin.y);
}

@end
