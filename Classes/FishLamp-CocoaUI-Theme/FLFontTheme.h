//
//  FLFontTheme.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectDescriber.h"
#import "FLModelObject.h"

//#import "FLStringDisplayStyle.h"

@interface FLFontTheme : FLModelObject {
@private
    NSString* _familyName;
    NSNumber* _defaultSize;
    NSNumber* _smallSize;
    NSNumber* _bigSize;
    NSNumber* _headerSize;
    SDKColor* _selectedColor;
    SDKColor* _highlightedColor;
    SDKColor* _disabledColor;
    SDKColor* _enabledColor;
    SDKColor* _hoverColor;
}

@property (readwrite, strong, nonatomic) NSString* familyName;
@property (readwrite, strong, nonatomic) NSNumber* defaultSize;
@property (readwrite, strong, nonatomic) NSNumber* smallSize;
@property (readwrite, strong, nonatomic) NSNumber* bigSize;
@property (readwrite, strong, nonatomic) NSNumber* headerSize;
@property (readwrite, strong, nonatomic) SDKColor* selectedColor;
@property (readwrite, strong, nonatomic) SDKColor* highlightedColor;
@property (readwrite, strong, nonatomic) SDKColor* disabledColor;
@property (readwrite, strong, nonatomic) SDKColor* enabledColor;
@property (readwrite, strong, nonatomic) SDKColor* hoverColor;

- (SDKFont*) fontWithSize:(CGFloat) size;
- (SDKFont*) boldFontWithSize:(CGFloat) size;

- (SDKFont*) themeFontWithIBFont:(SDKFont*) font;

@end

@interface SDKFont (FLAdditions) 
- (BOOL) isBold;
@end