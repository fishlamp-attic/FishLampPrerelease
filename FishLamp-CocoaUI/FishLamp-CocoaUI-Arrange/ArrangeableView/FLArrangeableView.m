//
//  FLArrangeableView.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 7/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangeableView.h"

@implementation FLArrangeableView

@synthesize arrangeableState = _arrangeableState;
@synthesize arrangeableInsets = _arrangeableInsets;
@synthesize arrangeableGrowMode = _arrangeableGrowMode;
@synthesize arrangeableWeight = _arrangeableWeight;
@synthesize arrangement = _arrangement;

@dynamic bounds;
@dynamic arrangeables;
@dynamic hidden;
@dynamic arrangeableFrame;

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.autoresizesSubviews = NO;
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_arrangement release];
    [super dealloc];
}
#endif


@end
