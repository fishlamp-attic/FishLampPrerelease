//
//  FLManualViewLayout.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/31/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLGeometry.h"

@class FLManualViewLayout;

typedef void (^FLManualViewLayoutBlock)(FLManualViewLayout* layout, CGRect inBounds);

@interface FLManualViewLayout : NSObject {
@private
    NSMutableDictionary* _views;
    NSMutableDictionary* _frames;
    FLManualViewLayoutBlock _onLayout;
}

@property (readwrite, copy, nonatomic) FLManualViewLayoutBlock onLayout;

- (void) setView:(id) view forKey:(id) key;

- (CGRect) layoutFrameForKey:(id) key;
- (void) setLayoutFrame:(CGRect) frame forKey:(id) key;

- (void) updateFrames;
- (void) updateLayoutInBounds:(CGRect) bounds;
- (void) applyLayout;

@end