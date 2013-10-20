//
//  SDKView+FLEnabled.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

@interface SDKView (FLEnabled)

- (void) disableSubviews:(BOOL)disable
                  filter:(BOOL (^)(SDKView *v))filter;

- (void) disableSubviews:(BOOL)disable
                  ofType:(Class)type;

- (void) disableSubviews:(BOOL)disable
              inTagRange:(NSRange)range;

- (void) disableSubviews:(BOOL)disable
                startTag:(NSInteger)start
                  endTag:(NSInteger)end;

- (void) disableSubviews:(BOOL)disable
                withTags:(NSArray *)tags;

- (void) disableSubviews:(BOOL)disable
                  ofType:(Class)type
              inTagRange:(NSRange)range;

- (void) disableSubviews:(BOOL)disable
                  ofType:(Class)type
                withTags:(NSArray *)tags;

- (void) disableSubviews:(BOOL)disable;

@end
