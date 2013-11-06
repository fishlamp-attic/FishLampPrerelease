//
//  FLThemeChangedListener.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Foundation/Foundation.h>
#import "FLNotificationListener.h"

@interface FLThemeChangedListener : FLNotificationListener {
@private
    SEL _targetThemeSelector;
}
@property (readwrite, assign, nonatomic) SEL targetThemeSelector;

- (id) initWithTarget:(id) target withSelector:(SEL) selector;
+ (id) themeChangedListener:(id) target withSelector:(SEL) selector;
@end

