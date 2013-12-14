//
//  FLTheme.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Foundation/Foundation.h>
#import "FLObjectDescriber.h"
#import "FLThemeChangedListener.h"
#import "FLFontTheme.h"
#import "FLAttributedString.h"

@interface FLTheme : NSObject {
@private
    NSString* _themeName;
    FLStringDisplayStyle* _applicationTextStyle;
    FLStringDisplayStyle* _headlineTextStyle;
    FLStringDisplayStyle* _bigTextStyle;
    
}
@property (readwrite, strong, nonatomic) NSString* themeName;
@property (readwrite, strong, nonatomic) FLStringDisplayStyle* applicationTextStyle;
@property (readwrite, strong, nonatomic) FLStringDisplayStyle* headlineTextStyle;
@property (readwrite, strong, nonatomic) FLStringDisplayStyle* bigTextStyle;

- (void) applyThemeToObject:(id) object;

+ (FLTheme*) currentTheme;
@end



