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
#import "FLAsyncQueue.h"
#import "FishLampAsync.h"

@interface FLExecuteInQueueProxy : FLRetainedObject {
@private
    id<FLAsyncQueue> _queue;
}
+ (id) executeInQueueProxy:(id) object queue:(id<FLAsyncQueue>) queue;
@end

@implementation FLExecuteInQueueProxy

- (id) initWithRetainedObject:(id) object queue:(id<FLAsyncQueue>) queue {

    self = [super initWithRetainedObject:object];
    if(self) {
        _queue = FLRetain(queue);
        FLAssertNotNil(_queue);
    }
    return self;
}

+ (id) executeInQueueProxy:(id) object queue:(id<FLAsyncQueue>) queue {
    return FLAutorelease([[[self class] alloc] initWithRetainedObject:object queue:queue]);
}

#if FL_MRC
- (void)dealloc {
	[_queue release];
	[super dealloc];
}
#endif

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    __block id object = [self representedObject];
    FLAssertNotNil(object);
    FLAssertNotNil(_queue);

    if([object respondsToSelector:[anInvocation selector]]) {

        __block NSInvocation* theInvocation = FLRetain(anInvocation);
        [theInvocation retainArguments];

        FLRetainObject(object);

        [_queue queueBlock: ^{
            [theInvocation invokeWithTarget:object];
            FLReleaseWithNil(theInvocation);
            FLReleaseWithNil(object);
        }];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end


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

- (id) broadcaster {
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_listeners countByEnumeratingWithState:state objects:buffer count:len];
}

- (void) addListener:(id) listener  withRetain:(BOOL) retain  {
    if(!_listeners) {
        _listeners = [[NSMutableArray alloc] init];
    }

    id object = listener;
    if(!retain) {
        object = [FLNonretainedObjectProxy nonretainedObjectProxy:listener];
    }

//    if(withQueue) {
//        object = [FLExecuteInQueueProxy executeInQueueProxy:object queue:withQueue];
//    }

    [_listeners addObject:object];
}

- (void) addListener:(id) listener withQueue:(id<FLAsyncQueue>) queue {
    [self addListener:listener withRetain:[listener respondsToSelector:@selector(willRetainInBroadcaster)]];
}

//- (void) addListener:(id) listener {
//    [self addListener:listener withRetain:[listener respondsToSelector:@selector(isProxy)] withQueue:nil];
//}

- (void) removeListener:(id) listener {
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        id object = [_listeners objectAtIndex:i];
        if([object representedObject] == listener) {
            [_listeners removeObjectAtIndex:i];
        }
    }
}

- (void) sendMessageToListeners:(SEL) selector {
    for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
        @try {
            [[_listeners objectAtIndex:i] performOptionalSelector_fl:selector];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) sendMessageToListeners:(SEL) selector  
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

- (void) sendMessageToListeners:(SEL) selector 
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

- (void) sendMessageToListeners:(SEL) selector 
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

- (void) sendMessageToListeners:(SEL) selector 
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

- (id) broadcaster {
    dispatch_once(&_predicate, ^{
        _broadcasterProxy = [[FLBroadcasterProxy alloc] init];}
        );
    return _broadcasterProxy;
}

//- (BOOL) hasListener:(id) listener {
//    __block BOOL hasListener = NO;
//
//    FLCriticalSection(&_predicate, ^{
//        hasListener = [self.broadcaster hasListener:listener];
//    });
//
//    return hasListener;
//}

- (void) addListener:(id) listener  {
    [self.broadcaster addListener:listener];
}

- (void) removeListener:(id) listener {
    [self.broadcaster removeListener:listener];
}

- (void) sendMessageToListeners:(SEL) selector {

    [FLForegroundQueue queueBlock:^{
        [self.broadcaster sendMessageToListeners:selector];
    }];
}

- (void) sendMessageToListeners:(SEL) selector  
                     withObject:(id) object {
    [FLForegroundQueue queueBlock:^{
        [self.broadcaster sendMessageToListeners:selector withObject:object];
    }];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {
    [FLForegroundQueue queueBlock:^{
        [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2];
    }];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {
    [FLForegroundQueue queueBlock:^{
        [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2 withObject:object3];
    }];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {
    [FLForegroundQueue queueBlock:^{
        [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
    }];
}

@end
