//
//  SDKView+FLArrangement.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 7/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKView+FLArrangeable.h"
#import "FLArrangeable.h"
#import "FLArrangement.h"
#import "FLRectGeometry.h"

@implementation SDKView (FLArrangeableContainer)
FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, arrangement, setArrangement, FLArrangement*);
@end

@implementation SDKView (FLArrangeable)

// these are actually defined in NSObject+FLArrangeable.h/.m

@dynamic innerInsets;
@dynamic arrangeableGrowMode;
@dynamic arrangeableWeight;
@dynamic arrangeableState;

- (CGRect) arrangeableFrame {
    return self.frame;
}

- (void) setArrangeableFrame:(CGRect) frame {
    self.frame = frame;
}

@end


@implementation SDKView (FLArrangeableUtils)

- (id) lastSubviewByWeight:(FLArrangeableWeight) weight {
    return [NSObject lastSubframeByWeight:weight subframes:self.subviews];
}

- (void) layoutSubviewsWithArrangement:(FLArrangement*) arrangement
                        adjustViewSize:(BOOL) adjustSize {
    NSArray* subviews = self.subviews;
    if(arrangement) {
        CGRect bounds = self.bounds;
        bounds.size = [arrangement performArrangement:subviews inBounds:bounds];
        if(adjustSize) {
            self.bounds = bounds;
        }
    }

    for(id subview in subviews) {
        [subview layoutSubviewsWithArrangement:[subview arrangement]
                                  adjustViewSize:YES];
    }
}

- (void) insertSubview:(SDKView*) view
  withArrangeableWeight:(FLArrangeableWeight) weight {
    SDKView* subview = [self lastSubviewByWeight:weight];
    if(subview) {
        [self insertSubview:view aboveSubview:subview];
    }
    else {
        [self addSubview:view];
    }
}



- (void) calculateArrangementSize:(CGSize*) outSize
                           inSize:(CGSize) inSize
                         fillMode:(FLArrangeableGrowMode) fillMode {
}


- (NSArray*) arrangeables {
    return self.subviews;
}

@end

@implementation SDKView (FLMiscUtils)

- (CGRect) layoutBounds {

//    return FLRectInset

// TODO this isn't right.
    return FLRectInsetWithEdgeInsets(self.bounds, self.innerInsets);
}

-(void) visitSubviews:(void (^)(id view)) visitor {
	for(SDKView* view in self.subviews) {
		if(!view.isHidden) {
			[view visitSubviews:visitor];
			visitor(view);
		}
	}
}

@end
