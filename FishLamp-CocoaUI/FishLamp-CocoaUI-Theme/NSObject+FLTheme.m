//
//  NSObject+Theming.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSObject+FLTheme.h"
#import "FLTheme.h"

//@property (readonly, strong, nonatomic) FLThemeChangedListener* themeAdaptor;


@implementation NSObject (Themes)

FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, themeAdaptorObject, setThemeAdaptorObject, FLThemeChangedListener*)

- (BOOL) isThemable {
    return [[self class] themeSelector] != nil;
}

- (FLThemeChangedListener*) themeAdaptor {
    
    SEL classSelector = [[self class] themeSelector];
    if(classSelector) {
        FLThemeChangedListener* adaptor = [self themeAdaptorObject];
        if(!adaptor) {
            adaptor = [FLThemeChangedListener themeChangedListener:self withSelector:classSelector];
            [self setThemeAdaptorObject:adaptor];
        }
        return adaptor;    
    }
    
    return nil;

}

- (SEL) themeSelector {
    FLAssertNotNilWithComment([[self class] themeSelector], @"Class is not themeable. Override \"+ (SEL) themeSelector\"");
    return [[self themeAdaptor] targetThemeSelector];
}

- (void) setThemeSelector:(SEL) selector {
    FLAssertNotNilWithComment([[self class] themeSelector], @"Class is not themeable. Override \"+ (SEL) themeSelector\"");
    
    if(!selector) {
        selector = [[self class] themeSelector];
    }

    [[self themeAdaptor] setTargetThemeSelector:selector];
}

- (void) setThemeSelectorString:(NSString*) string {
    FLAssertNotNilWithComment([[self class] themeSelector], @"Class is not themeable. Override \"+ (SEL) themeSelector\"");

    if(FLStringIsNotEmpty(string)) {
        [self setThemeSelector:NSSelectorFromString(string)];
    }
    else {
        [self setThemeSelector:[[self class] themeSelector]];
    }
}

- (NSString*) themeSelectorString {
    SEL sel = [self themeSelector];
    return sel ? NSStringFromSelector(sel) : nil;
}

+ (SEL) themeSelector {
    return nil;
}

- (SEL) willApplyTheme:(id) theme withSelector:(SEL) selector {
    return selector;
}

- (void) themeDidChange:(id) theme {
    [theme applyThemeToObject:self];
}

@end
