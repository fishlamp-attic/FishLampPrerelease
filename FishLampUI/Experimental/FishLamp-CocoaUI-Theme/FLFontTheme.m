//
//  FLFontTheme.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFontTheme.h"


@implementation FLFontTheme 

@synthesize familyName = _familyName;
@synthesize defaultSize = _defaultSize;
@synthesize smallSize = _smallSize;
@synthesize bigSize = _bigSize;
@synthesize headerSize = _headerSize;
@synthesize selectedColor = _selectedColor;
@synthesize highlightedColor = _highlightedColor;
@synthesize disabledColor = _disabledColor;
@synthesize enabledColor = _enabledColor;
@synthesize hoverColor = _hoverColor;

#if FL_MRC
- (void) dealloc {
    [_hoverColor release];
    [_highlightedColor release];
    [_selectedColor release];
    [_disabledColor release];
    [_enabledColor release];
    [_familyName release];
    [_defaultSize release];
    [_smallSize release];
    [_bigSize release];
    [_headerSize release];
	[super dealloc];
}
#endif

- (SDKFont*) fontWithSize:(CGFloat) size {
    return [SDKFont fontWithName:[NSString stringWithFormat:@"%@", _familyName] size:size];
}

- (SDKFont*) boldFontWithSize:(CGFloat) size {
    return [SDKFont fontWithName:[NSString stringWithFormat:@"%@-Bold", _familyName] size:size];
}

- (SDKFont*) themeFontWithIBFont:(SDKFont*) font {
    
    CGFloat pointSize = font.pointSize;
    if(FLFloatEqualToFloat(pointSize, [NSFont systemFontSize]) && _defaultSize) {
        pointSize = _defaultSize.floatValue;
    }

    NSFont* outFont = nil;
    if(font.isBold) {
        outFont =  [self boldFontWithSize:pointSize];
    }
    else {
        outFont = [self fontWithSize:pointSize];
    }
    
    FLAssertNotNil(outFont);
    
    return outFont;
}

@end


@implementation SDKFont (FLAdditions) 
- (BOOL) isBold {
    return [[self fontName] rangeOfString:@"Bold"].length > 0;
}


@end