//
//  FLSimpleNotifier.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"

typedef void (^FLBlockNotifierBlock)(id sender);

@interface FLSimpleNotifier : NSObject {
@private
    NSMutableSet* _notifiers;
    BOOL _disabled;
}

@property (readwrite, assign, getter=isDisabled) BOOL disabled;

+ (id) simpleNotifier;

- (void) sendNotification:(id) sender;

- (void) receiveNotification:(id) sender;

/**
    add a child notifier.
*/
- (void) addNotifier:(FLSimpleNotifier*) notifier;

- (void) addNotifierWithTarget:(id) target action:(SEL) selector;

- (void) addNotifierWithBlock:(FLBlockNotifierBlock) block;

/**
    remove a child notifier.
*/
- (void) removeNotifier:(FLSimpleNotifier*) notifier;

/** 
    visit each notifier recursively (disabled notifiers are not visited)
    @return YES if stopped at any point (skipping disabled doesn't count as stopping)
*/
- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor;

@end

@interface FLCallbackNotifier : FLSimpleNotifier {
@private
    __weak id _target;
    SEL _action;
}

/// note that target is unretained.
@property (readwrite, weak) id target;

// always has a sender, like this - (void) myNotification:(id) sender;
@property (readwrite, assign) SEL action;

- (void) setTarget:(id) target action:(SEL) action;

- (id) initWithTarget:(id) target action:(SEL) action;

+ (id) callbackNotifier:(id) target action:(SEL) action;

- (void) removeTargetAndDisable; 

@end


@interface FLBlockNotifier : FLSimpleNotifier {
@private
    FLBlockNotifierBlock _block;
}

@property (readwrite, copy) FLBlockNotifierBlock block;

- (id) initWithNotifierBlock:(FLBlockNotifierBlock) block;

+ (id) blockNotifier:(FLBlockNotifierBlock) block;

- (void) removeBlockAndDisable;

@end

