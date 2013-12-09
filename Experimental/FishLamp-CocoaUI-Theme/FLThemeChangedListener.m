//
//  FLThemeChangedListener.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLThemeChangedListener.h"
#import "FLThemeManager.h"
#import "NSObject+FLTheme.h"

@implementation FLThemeChangedListener

@synthesize targetThemeSelector = _targetThemeSelector;

- (id) initWithTarget:(id) target 
         withSelector:(SEL) selector {

	self = [super initWithEventName:FLThemeChangedNotificationKey sender:[FLThemeManager instance] parameterKey:FLThemeManagerKey];

	if(self) {
        [self setTarget:target action:@selector(themeDidChange:)];
        self.targetThemeSelector = selector;
	}
	return self;
}

+ (id) themeChangedListener:(id) target withSelector:(SEL) selector {
    return FLAutorelease([[[self class] alloc] initWithTarget:target withSelector:selector]);
}

@end

