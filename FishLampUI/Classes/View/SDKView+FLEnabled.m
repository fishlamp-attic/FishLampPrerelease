//
//  SDKView+FLEnabled.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKView+FLEnabled.h"

@implementation SDKView (FLEnabled)

- (void) disableSubviews:(BOOL)disable
                  filter:(BOOL (^)(SDKView *v))filter
{
    if (!filter) {
        filter = ^BOOL (SDKView *v) { return YES; };
    }

    for (SDKView *v in self.subviews) {
        [v disableSubviews:disable filter:filter];
        if (filter(v) && [v respondsToSelector:@selector(setEnabled:)]) {
            ((NSControl *) v).enabled = !disable;
        }
    }
}

- (void) disableSubviews:(BOOL)disable
                  ofType:(Class)type
{
    [self disableSubviews:disable
                   filter:^BOOL (SDKView *v) {
                       return [v isKindOfClass:type];
                   }];
}

- (void) disableSubviews:(BOOL)disable
              inTagRange:(NSRange)range
{
    [self disableSubviews:disable
                   filter:^BOOL (SDKView *v) {
                       return NSLocationInRange(v.tag, range);
                   }];
}

- (void) disableSubviews:(BOOL)disable
                startTag:(NSInteger)start
                  endTag:(NSInteger)end
{
    [self disableSubviews:disable
               inTagRange:NSMakeRange(start, (end - start + 1))];
}

- (void) disableSubviews:(BOOL)disable
                withTags:(NSArray *)tags
{
    [self disableSubviews:disable
                   filter:^BOOL (SDKView *v) {
                       return [tags containsObject:[NSNumber numberWithInteger:v.tag]];
                   }];
}

- (void) disableSubviews:(BOOL)disable
                  ofType:(Class)type
              inTagRange:(NSRange)range
{
    [self disableSubviews:disable
                   filter:^BOOL (SDKView *v) {
                       return [v isKindOfClass:type] && NSLocationInRange(v.tag, range);
                   }];
}

- (void) disableSubviews:(BOOL)disable
                  ofType:(Class)type
                withTags:(NSArray *)tags
{
    [self disableSubviews:disable
                   filter:^BOOL (SDKView *v) {
                       return [v isKindOfClass:type] &&
                              [tags containsObject:[NSNumber numberWithInteger:v.tag]];
                   }];
}

- (void) disableSubviews:(BOOL)disable
{
    [self disableSubviews:disable filter:nil];
}

@end
