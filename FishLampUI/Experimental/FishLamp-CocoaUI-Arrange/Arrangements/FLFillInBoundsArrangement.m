//
//  FLFillInBoundsArrangement.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFillInBoundsArrangement.h"

@implementation FLFillInBoundsArrangement

- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                           inBounds:(CGRect) bounds {

	for(id object in objects) {
		if([object isHidden])  {
			continue;
		}
		
        bounds = [self setFrame:bounds forObject:object];
	}
    
    return bounds.size;
}

@end
