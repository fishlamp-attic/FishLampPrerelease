//
//  FLSimpleNotifier.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSimpleNotifier.h"
#import "FLDeallocNotifier.h"

@implementation FLSimpleNotifier

@synthesize disabled = _disabled;

- (void) sendNotification:(id) sender {
    if(!self.isDisabled) {
        [self receiveNotification:sender];

        [self visit:^(FLSimpleNotifier* notifier, BOOL* stop) {
            [notifier sendNotification:sender];
        }];
    }
}

- (void) receiveNotification:(id) sender {
}

+ (id) simpleNotifier {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) addNotifier:(FLSimpleNotifier*) notifier {

    FLAssertIsNotNil(notifier);

    @synchronized(self) {
        if(!_notifiers) {
            _notifiers = [[NSMutableSet alloc] init];
        }
        [_notifiers addObject:notifier];
    }

//TODO : add this back

//    [notifier addDeallocNotifierBlock:^(FLDeletedObjectReference* sender) {
//        [self removeNotifier:sender.deletedObject];
//    }];
}

- (void) addNotifierWithTarget:(id) target action:(SEL) selector {
    [self addNotifier:[FLCallbackNotifier callbackNotifier:target action:selector]];
}

- (void) addNotifierWithBlock:(FLBlockNotifierBlock) block {
    [self addNotifier:[FLBlockNotifier blockNotifier:block]];
}

- (void) removeNotifier:(FLSimpleNotifier*) notifier {
    @synchronized(self) {
        [_notifiers removeObject:notifier];
    }
}

- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor {

    BOOL stop = NO;
    for(FLSimpleNotifier* value in _notifiers) {
        @try {
            visitor(value, &stop);
        }
        @catch(NSException* ex) {
            FLConfirmationFailureWithComment(@"do not throw exceptions from notifiers");
        }
        
        if(stop) {
            break;
        }
    }
    
    return stop;
}

#if FL_MRC
- (void) dealloc {
    [_notifiers release];
    [super dealloc];
}
#endif

/*
- (void) visitEachChild:(void (^)(FLSimpleNotifier* notifier, BOOL* stop)) visitor {

    if(!self.isDisabled) {
        NSInteger current = 0;
        BOOL started = NO;
        
        while(!stop) {
            id notifier = nil;
            
            // TODO is there a way to do this without locking?
            // Would it be faster to lock once for the whole loop? But then we could deadlock.
            // Or maybe copying the list would be faster?
            // Or maybe allowing mutations while iterating is less important than speed.
            @synchronized(self) {
            
                NSUInteger count = _notifiers.count;
                if(count == 0) {
                    break;
                }
                
                if(!started || current > count) {
                    current = count - 1;
                    started = YES;
                }
                
                if(current-- >= 0) {
                    notifier = [_notifiers objectAtIndex:current];
                }
            }
        
            if(!notifier) {
                break;
            }

            if([notifier visitEach:visitor]) {
                *stop = YES;
            }
        }
    }
}
*/

@end

@implementation FLCallbackNotifier

@synthesize target = _target;
@synthesize action = _action;

//- (id) target {
//    return _target.object;
//}
//
//- (void) setTarget:(id) target {
//    _target.object = target;
//}

- (void) setTarget:(id) target action:(SEL) action {
//    _target.object = target;
//
    _target = target;
    _action = action;
}

- (id) initWithTarget:(id) target action:(SEL) action {
    self = [super init];
    if(self) {
//        _target = [[FLWeakReference alloc] initWithObject:target];
//        _action = action;
        [self setTarget:target action:action];
    }
    return self;
}

- (void) receiveNotification:(id) sender {
    id target = self.target;
    FLPerformSelector1(target, _action, sender);
}

+ (id) callbackNotifier:(id) target action:(SEL) action {
    return FLAutorelease([[[self class] alloc] initWithTarget:target action:action]);
}

- (void) removeTargetAndDisable {
    _target = nil;
    _action = nil;
    self.disabled = YES;
}

//#if FL_MRC
//- (void) dealloc {
//    [_target release];
//    [super dealloc];
//}
//#endif


@end

@implementation FLBlockNotifier

@synthesize block = _block;

- (id) initWithNotifierBlock:(FLBlockNotifierBlock) block {
    self = [super init];
    if(self) {
        self.block = block;
    }
    return self;
}

+ (id) blockNotifier:(FLBlockNotifierBlock) block {
    return FLAutorelease([[[self class] alloc] initWithNotifierBlock:block]);
}

- (void) receiveNotification:(id) sender {
    if(_block) {
        _block(sender);
    }
}

#if FL_MRC
- (void) dealloc {
    [_block release];
    [super dealloc];
}
#endif

- (void) removeBlockAndDisable {
    self.block = nil;
    self.disabled = YES;
}

@end







