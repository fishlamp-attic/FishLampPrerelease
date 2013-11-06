//
//  FLManualViewLayout.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/31/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLManualViewLayout.h"
#import "FishLampMinimum.h"

@implementation FLManualViewLayout

@synthesize onLayout = _onLayout;

- (id) init {
    self = [super init];
    if(self) {
        _views = [[NSMutableDictionary alloc] init];
        _frames = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    FLRelease(_onLayout);
    FLRelease(_views);
    FLRelease(_frames);
    FLSuperDealloc();
}
#endif

- (void) setView:(id) view forKey:(id) key {
    [_views setObject:view forKey:key];
}

- (CGRect) layoutFrameForKey:(id) key {
    NSValue* val = [_frames objectForKey:key];
    if(!val) {
        id view = [_views objectForKey:key];
        if(view) {
            val = [NSValue valueWithCGRect:[view frame]];
            [_frames setObject:val forKey:key];
        }
    }

    return val ? [val CGRectValue] : CGRectZero;

}

- (void) setLayoutFrame:(CGRect) frame forKey:(id) key {
    [_frames setObject:[NSValue valueWithCGRect:frame] forKey:key];
}

- (void) updateLayoutInBounds:(CGRect) bounds {
    if(_onLayout) {
        _onLayout(self, bounds);
    }
}

- (void) updateFrames {
    for(id key in _views) {
        id view = [_views objectForKey:key];
        if(view) {
            [self setLayoutFrame:[view frame] forKey:key];
        }
    }
}

- (void) applyLayout {
    for(id key in _frames) {
        id view = [_views objectForKey:key];
        NSValue* val = [_frames objectForKey:key];
        if(val) {
            [view setFrame:[val CGRectValue]];
        }
    }
}


@end
