//
//  FLBroadcaster.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBroadcaster.h"
#import "FLSelectorPerforming.h"
#import "FLAtomic.h"

@implementation FLBroadcasterProxy

- (id) init {	
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_listeners release];
	[super dealloc];
}
#endif

- (NSArray*) array {
    return _listeners;
}

- (BOOL) hasListener:(id) listener {
    return [_listeners containsObject:listener];
}

- (id) notify {
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_listeners countByEnumeratingWithState:state objects:buffer count:len];
}

- (void) addListener:(id) listener {
    if(!_listeners) {
        _listeners = [[NSMutableArray alloc] init];
    }

    if([listener conformsToProtocol:@protocol(FLObjectProxy)]) {
        [_listeners addObject:listener];
    }
    else {
        [_listeners addObject:[FLNonretainedObjectProxy nonretainedObjectProxy:listener]];
    }
}

- (void) removeListener:(id) listener {
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        id object = [_listeners objectAtIndex:i];
        if([object representedObject] == listener) {
            [_listeners removeObjectAtIndex:i];
        }
    }
}

- (void) notify:(SEL) selector {
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        @try {
            [[_listeners objectAtIndex:i] performOptionalSelector_fl:selector];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) notify:(SEL) selector  
                     withObject:(id) object {
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        @try {
            [[_listeners objectAtIndex:i] performOptionalSelector_fl:selector
                                                   withObject:object];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) notify:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {

    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        @try {
            [[_listeners objectAtIndex:i] performOptionalSelector_fl:selector
                                                       withObject:object1
                                                       withObject:object2];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) notify:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        @try {
            [[_listeners objectAtIndex:i] performOptionalSelector_fl:selector
                                                       withObject:object1
                                                       withObject:object2
                                                       withObject:object3];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) notify:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {

    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        @try {
            [[_listeners objectAtIndex:i] performOptionalSelector_fl:selector
                                                       withObject:object1
                                                       withObject:object2
                                                       withObject:object3
                                                       withObject:object4];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    BOOL listenerHandled = NO;
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        id listener = [_listeners objectAtIndex:i];
        if([listener respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:listener];
            listenerHandled = YES;
        }
    }
    if(!listenerHandled) {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL) respondsToSelector:(SEL) selector {

    for(id listener in _listeners) {
        if([listener respondsToSelector:selector]) {
            return YES;
        }
    }

    return NO;
}

@end

@interface FLBroadcaster ()
@end

@implementation FLBroadcaster

#if FL_MRC
- (void)dealloc {
	[_broadcasterProxy release];
	[super dealloc];
}
#endif

- (id) notify {
    dispatch_once(&_predicate, ^{
        _broadcasterProxy = [[FLBroadcasterProxy alloc] init];}
        );
    return _broadcasterProxy;
}

- (BOOL) hasListener:(id) listener {
    __block BOOL hasListener = NO;

    FLAtomicBlock(&_predicate, ^{
        hasListener = [self.notify hasListener:listener];
    });

    return hasListener;
}

- (void) addListener:(id) listener {
    FLAtomicBlock(&_predicate, ^{
        [self.notify addListener:listener];
    });
}

- (void) removeListener:(id) listener {
    FLAtomicBlock(&_predicate, ^{
        [self.notify removeListener:listener];
    });
}

- (void) notify:(SEL) selector {
    FLAtomicBlock(&_predicate, ^{
        [self.notify notify:selector];
    });
}

- (void) notify:(SEL) selector  
                     withObject:(id) object {
    FLAtomicBlock(&_predicate, ^{
        [self.notify notify:selector withObject:object];
    });
}

- (void) notify:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {
    FLAtomicBlock(&_predicate, ^{
        [self.notify notify:selector withObject:object1 withObject:object2];
    });
}

- (void) notify:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {
    FLAtomicBlock(&_predicate, ^{
        [self.notify notify:selector withObject:object1 withObject:object2 withObject:object3];
    });
}

- (void) notify:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {
    FLAtomicBlock(&_predicate, ^{
        [self.notify notify:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
    });
}

@end
