//
//  FLArrangement.h
//  FishLamp
//
//  Created by Mike Fullerton on 6/6/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

#import "FLCocoaUIRequired.h"
#import "FLArrangeable.h"
#import "FLArrangeableContainer.h"
#import "FLEdgeInsets.h"

@class FLArrangement;

typedef void (^FLArrangementWillLayoutBlock)(id arrangement, CGRect bounds);
typedef void (^FLArrangementFrameSetter)(id view, CGRect newFrame); 

@interface FLArrangement : NSObject {
@private
	UIEdgeInsets _outerInsets;
	UIEdgeInsets _innerInsets;
    
    FLArrangementWillLayoutBlock _onWillArrange;
    FLArrangementFrameSetter _frameSetter;
}

@property (readwrite, assign, nonatomic) UIEdgeInsets outerInsets;

@property (readwrite, assign, nonatomic) UIEdgeInsets innerInsets;

@property (readwrite, copy, nonatomic) FLArrangementFrameSetter frameSetter;
 
@property (readwrite, copy, nonatomic) FLArrangementWillLayoutBlock onWillArrange;

+ (id) arrangement;

// each item must implement methods in FLArrangeable
- (CGSize) performArrangement:(NSArray*) arrayOfArrangeabeFrames
                     inBounds:(CGRect) bounds;

// utils for subclasses.

- (CGRect) setFrame:(CGRect) frame
          forObject:(id) object;

- (CGRect) frameForObject:(id) object;

// override point. Returns size of new bounds - can be same size as input bounds.
// each item must implement methods in FLArrangeable
- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                           inBounds:(CGRect) bounds;

+ (FLArrangementFrameSetter) defaultFrameSetter;

// these may only make sense on IOS??

+ (FLArrangementFrameSetter) optimizedForSizeFrameSetter;

+ (FLArrangementFrameSetter) optimizedForLocationFrameSetter;

@end






