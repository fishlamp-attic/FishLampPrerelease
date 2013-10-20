//
//  FLThemeManager.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLTheme.h"

extern NSString* FLThemeChangedNotificationKey;
extern NSString* FLThemeManagerKey;

@interface FLThemeManager : NSObject{
@private
    id _currentTheme;
    NSMutableArray* _themes;
    BOOL _enabled;
}
@property (readwrite, assign, nonatomic, getter=isEnabled) BOOL enable;
@property (readwrite, strong, nonatomic) id currentTheme;
@property (readonly, strong, nonatomic) NSArray* themes;

FLSingletonProperty(FLThemeManager);

- (void) addTheme:(FLTheme*) theme;
- (void) addThemesWithArray:(NSArray*) themes;

- (NSArray*) loadThemesFromBundleXmlFile:(NSString*) fileName  themeClass:(Class) themeClass;
- (NSArray*) loadThemesFromBundleJsonFile:(NSString*) fileName  themeClass:(Class) themeClass;

- (NSError*) loadThemesFromBundle;

@end

//@interface FLThemeHandler : NSObject
//- (NSNumber*) smallFontSize;
//- (NSNumber*) applicationFontSize;
//- (NSNumber*) header1FontSize;
//- (NSNumber*) header2FontSize;
//
//
//- (NSString*) fontFamilyName;
//- (NSFont*) applicationFont:(CGFloat) fontSize;
//- (NSFont*) boldApplicationFont:(CGFloat) fontSize;
//@end

