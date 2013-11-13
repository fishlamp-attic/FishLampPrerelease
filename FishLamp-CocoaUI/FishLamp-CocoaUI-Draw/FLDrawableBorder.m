//
//  FLDrawableBorder.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDrawableBorder.h"

@implementation FLDrawableBorder

@synthesize borderColor = _borderColor;
@synthesize cornerRadius = _cornerRadius;
@synthesize lineWidth = _lineWidth;

- (void) drawRect:(SDKRect) drawRect 
        withFrame:(SDKRect) frame 
         inParent:(id) parent
drawEnclosedBlock:(void (^)(void)) drawEnclosedBlock {


}

@end
