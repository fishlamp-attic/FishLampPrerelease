//
//  FLFrame.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLArrangeable.h"
#import "FLControlState.h"

@interface FLFrame : NSObject<FLArrangeable> {
@private
    CGRect _frame;
    FLControlState _controlState;
    BOOL _hidden;
    
    FLArrangeableWeight _arrangeableWeight;
    FLArrangeableGrowMode _arrangeableGrowMode;
    UIEdgeInsets _arrangeableInsets;
    FLArrangeableState _arrangeableState;
}

@property (readwrite, assign, nonatomic) CGRect frame;

@property (readwrite, assign, nonatomic) FLControlState controlState;

@property (readwrite, assign, nonatomic, getter=isSelected) BOOL selected;

@property (readwrite, assign, nonatomic, getter=isDoubleSelected) BOOL doubleSelected;

@property (readwrite, assign, nonatomic, getter=isHighlighted) BOOL highlighted; 

@property (readwrite, assign, nonatomic, getter=isDisabled) BOOL disabled; 

@property (readonly, nonatomic) BOOL isFrameOptimized;

@property (readwrite, assign, nonatomic) CGRect frameOptimizedForLocation;

@property (readwrite, assign, nonatomic) CGRect frameOptimizedForSize;

@property (readwrite, assign, nonatomic, getter=isHidden) BOOL hidden; 

- (id) initWithFrame:(CGRect) frame;

- (void) moveFrameBy:(CGPoint) offset;

- (BOOL) pointIsInside:(CGPoint)point;

- (void) didChangeFrame;

- (void) didChangeHidden;

@end
