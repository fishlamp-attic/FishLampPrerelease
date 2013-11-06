//
//  FLThemeManager.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLThemeManager.h"
#import "FLXmlParser.h"
#import "FLParsedXmlElement.h"
#import "FLObjectDescriber.h"
#import "FLXmlObjectBuilder.h"
#import "FLObjcRuntime.h"
#import "NSObject+FLTheme.h"
#import "FLJsonParser.h"
#import "FLJsonObjectBuilder.h"

NSString* FLThemeChangedNotificationKey = @"FLThemeChangedNotificationKey";
NSString* FLThemeManagerKey = @"FLThemeManagerKey";

@interface FLThemeManager ()
@property (readwrite, strong, nonatomic) NSArray* themes;
@end    

@interface FLTheme ()
+ (void) setCurrentTheme:(FLTheme*) theme;
@end
    
@implementation NSObject (FLThemeManager)
//- (void) newAwakeFromNib {
//    [self newAwakeFromNib]; // call original awakeFromNib
//    if([self isThemable]) {
//        [self themeDidChange:[FLTheme currentTheme]];
//    }
//}
@end        
    
@implementation FLThemeManager 

FLSynthesizeSingleton(FLThemeManager)

@synthesize currentTheme = _currentTheme;
@synthesize themes = _themes;
@synthesize enable = _enabled;

- (id) init {
    self = [super init];
    if(self) {
        _themes = [[NSMutableArray alloc] init];
//        FLSwizzleInstanceMethod([NSObject class],@selector(awakeFromNib), @selector(newAwakeFromNib));
	}
	return self;
}


#if FL_MRC
- (void) dealloc {
    [_themes release];
    [_currentTheme release];
	[super dealloc];
}
#endif

- (void) setEnable:(BOOL) enable {
    if(enable != _enabled) {
        _enabled = enable;
        if(_enabled) {
            [FLTheme setCurrentTheme:_currentTheme];
        }
        else {
            [FLTheme setCurrentTheme:nil];
        }
            
        [[NSNotificationCenter defaultCenter] postNotificationName:FLThemeChangedNotificationKey 
                                                            object:self 
                                                          userInfo:[NSDictionary dictionaryWithObject:self forKey:FLThemeManagerKey]];
    }
}

- (FLTheme*) currentTheme {
    return [FLTheme currentTheme];
}

- (void) setCurrentTheme:(FLTheme*) theme {

    if(theme != _currentTheme) {
        FLSetObjectWithRetain(_currentTheme, theme);
        
        if(self.isEnabled) {
            [FLTheme setCurrentTheme:theme];
            [[NSNotificationCenter defaultCenter] postNotificationName:FLThemeChangedNotificationKey 
                                                                object:self 
                                                              userInfo:[NSDictionary dictionaryWithObject:self forKey:FLThemeManagerKey]];
        }
    }
}

- (void) addThemesWithArray:(NSArray*) themes {
    [_themes addObjectsFromArray:themes];
}

- (void) addTheme:(FLTheme*) theme {
    [_themes addObject:theme];
}

- (NSArray*) loadThemesFromBundleXmlFile:(NSString*) fileName  themeClass:(Class) themeClass {

    NSURL* fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"json"];
    
    id object = [[FLJsonParser jsonParser] parseFileAtURL:fileURL];
    if(object) {
    
        FLJsonObjectBuilder* builder = [FLJsonObjectBuilder jsonObjectBuilder];
    
        NSArray* outThemes = [builder arrayOfObjectsFromJSON:[object objectForKey:@"themes"] expectedRootObjectClass:themeClass];
    
//        NSArray* themes = [object objectForKey:@"themes"];
//        NSMutableArray* outThemes = [NSMutableArray array];
//        FLObjectDescriber* themeType = [FLPropertyDescriber propertyDescriber:@"theme" objectClass:themeClass];
//        
//        for(NSDictionary* themeDictionary in themes) {
//            [outThemes addObject:[builder objectFromJSON:themeDictionary withTypeDesc:themeType]];
//        }
        
        
        return outThemes;
    }   


//    FLParsedXmlElement* xml = [[FLXmlParser xmlParser] parseFileAtURL:fileURL];
//    if(xml) {
//        
//        FLObjectDescriber* themeType = [FLPropertyDescriber propertyDescriber:@"theme" objectClass:themeClass];
//        
//        return [[FLXmlObjectBuilder xmlObjectBuilder] objectsFromXML:xml withTypeDesc:themeType];
//    }   
//    
    return nil;
}

- (NSArray*) loadThemesFromBundleJsonFile:(NSString*) fileName  themeClass:(Class) themeClass {

    NSURL* fileURL = [[NSBundle mainBundle] URLForResource:[fileName stringByDeletingPathExtension] withExtension:@"json"];
    
    id object = [[FLJsonParser jsonParser] parseFileAtURL:fileURL];
    if(object) {
    
        FLJsonObjectBuilder* builder = [FLJsonObjectBuilder jsonObjectBuilder];
    
        NSArray* outThemes = [builder arrayOfObjectsFromJSON:[object objectForKey:@"themes"] expectedRootObjectClass:themeClass];
    
//        NSArray* themes = [object objectForKey:@"themes"];
//        NSMutableArray* outThemes = [NSMutableArray array];
//        FLObjectDescriber* themeType = [FLPropertyDescriber propertyDescriber:@"theme" objectClass:themeClass];
//        
//        for(NSDictionary* themeDictionary in themes) {
//            [outThemes addObject:[builder objectFromJSON:themeDictionary withTypeDesc:themeType]];
//        }
        
        
        return outThemes;
    }   


//    FLParsedXmlElement* xml = [[FLXmlParser xmlParser] parseFileAtURL:fileURL];
//    if(xml) {
//        
//        FLObjectDescriber* themeType = [FLPropertyDescriber propertyDescriber:@"theme" objectClass:themeClass];
//        
//        return [[FLXmlObjectBuilder xmlObjectBuilder] objectsFromXML:xml withTypeDesc:themeType];
//    }   
//    
    return nil;
}

#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (void) applyThemeToObject:(id) object {
    if(self.isEnabled) {
        SEL selector = [object themeSelector];
        if(selector) {
            [self performSelector:selector withObject:object];
        }
    }
}

- (NSError*) loadThemesFromBundle {
    @try {
        NSString* principleThemeClass = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FLPrincipleThemeClass"];

        if(principleThemeClass) {

            NSString* themeFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FLThemeFile"];
            if(!themeFile) {
                themeFile = @"themes";
            }
            Class themeClass = NSClassFromString(principleThemeClass);
        
            NSArray* themes = [[FLThemeManager instance] loadThemesFromBundleJsonFile:themeFile themeClass:themeClass];
            if(themes) {
                [[FLThemeManager instance] addThemesWithArray:themes];
                [[FLThemeManager instance] setCurrentTheme:[themes objectAtIndex:0]];
            }
        }
        
        NSNumber* useTheme = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FLEnableThemes"];
        if(useTheme) {
            [FLThemeManager instance].enable = useTheme.boolValue;
        }

    }
    @catch(NSException* ex) {
        return ex.error;
    }
    
    return nil;
}


@end

//@implementation FLThemeHandler
//
//- (NSString*) fontFamilyName {
//    return @"Verdana";
//}
//
//- (NSFont*) applicationFont:(CGFloat) fontSize {
//    SDKFont* font = [SDKFont fontWithName:@"Verdana-Regular" size:fontSize];
//    FLAssertNotNil(font);
//    return font;
//}
//
//- (SDKFont *)boldApplicationFont:(CGFloat)fontSize {
//    SDKFont* font = [SDKFont fontWithName:@"Verdand-Bold" size:fontSize];
//    FLAssertNotNil(font);
//    return font;
//}
//
//- (NSNumber*) smallFontSize {
//    return [NSNumber numberWithInt:10];
//}
//- (NSNumber*) applicationFontSize {
//    return [NSNumber numberWithInt:12];
//}
//
//- (NSNumber*) header1FontSize{
//    return [NSNumber numberWithInt:14];
//}
//- (NSNumber*) header2FontSize {
//    return [NSNumber numberWithInt:16];
//}
//
//
//@end




