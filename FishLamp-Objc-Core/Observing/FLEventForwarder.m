//
//  FLEventForwarder.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLEventForwarder.h"
#import "FLAsyncMessageBroadcaster.h"

@implementation FLEventForwarder

@synthesize targetObject = _targetObject;

- (id) initWithTargetObject:(id) targetObject {
    _targetObject = FLRetain(targetObject);
    return self;
}

#if FL_MRC
- (void)dealloc {
	[_targetObject release];
	[super dealloc];
}
#endif

- (id) notifyForTargetObject {
    return [[_targetObject listeners] notify];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id object = [self targetObject];
    if([object respondsToSelector:[anInvocation selector]]) {
    // first object itself
        [anInvocation invokeWithTarget:object];
    }
    else {
    // then notifiers
        [anInvocation invokeWithTarget:[self notifyForTargetObject]];
    }
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {

    id object = [self targetObject];

    NSMethodSignature* sig = [object methodSignatureForSelector:selector];
    if(!sig) {
    // first object itself
        sig = [[self notifyForTargetObject] methodSignatureForSelector:selector];
    }
    if(!sig) {
    // then notifiers
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    return YES; // [[self representedObject] respondsToSelector:aSelector];
}


@end
