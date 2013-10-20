//
//  SDKView+FLArrangement.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 7/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLArrangeable.h"
#import "FLArrangeableContainer.h"
#import "NSObject+FLArrangeable.h"

@interface SDKView (FLArrangeableContainer)
@property (readwrite, retain, nonatomic) FLArrangement* arrangement;
@end

@interface SDKView (FLArrangeable)
@property (readwrite, assign, nonatomic) UIEdgeInsets innerInsets;
@property (readwrite, assign, nonatomic) FLArrangeableGrowMode arrangeableGrowMode;
@property (readwrite, assign, nonatomic) FLArrangeableWeight arrangeableWeight;
@property (readwrite, assign, nonatomic) FLArrangeableState arrangeableState;
@end

@interface SDKView (FLArrangeableUtils)

- (id) lastSubviewByWeight:(FLArrangeableWeight) weight;

- (void) layoutSubviewsWithArrangement:(FLArrangement*) arrangement
                        adjustViewSize:(BOOL) adjustSize;

- (void) insertSubview:(SDKView*) view
 withArrangeableWeight:(FLArrangeableWeight) weight;

- (void) calculateArrangementSize:(CGSize*) outSize
                           inSize:(CGSize) inSize
                         fillMode:(FLArrangeableGrowMode) fillMode;
@end

@interface SDKView (FLMiscUtils)
- (void) visitSubviews:(void (^)(id view)) visitor;
- (CGRect) layoutBounds;
@end
