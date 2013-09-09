//
//  FLObjectMessage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectMessage.h"

@interface FLObjectMessage ()
@property (readwrite, strong, nonatomic) id parameter1;
@property (readwrite, strong, nonatomic) id parameter2;
@property (readwrite, strong, nonatomic) id parameter3;
@end

@implementation FLObjectMessage 

@synthesize parameter1 = _parameter1;
@synthesize parameter2 = _parameter2;
@synthesize parameter3 = _parameter3;
@synthesize selector = _selector;
@synthesize parameterCount = _parameterCount;

- (id) initWithSelector:(SEL) selector 
             withObject:(id) object1 
             withObject:(id) object2 
             withObject:(id) object3 
         parameterCount:(NSInteger) parameterCount {

    self = [super init];
    if(self) {
        self.parameter1 = object1;
        self.parameter2 = object2;
        self.parameter3 = object3;
        _selector = selector;
        _parameterCount = parameterCount;
    }
    return self;
}

- (id) initWithSelector:(SEL) selector {
    return [self initWithSelector:selector withObject:nil withObject:nil withObject:nil parameterCount:0];
}

- (id) initWithSelector:(SEL) selector withObject:(id) object1 {
    return [self initWithSelector:selector withObject:object1 withObject:nil withObject:nil parameterCount:1];
}

- (id) initWithSelector:(SEL) selector withObject:(id) object1 withObject:(id) object2 {
    return [self initWithSelector:selector withObject:object1 withObject:object2 withObject:nil parameterCount:2];
}

- (id) initWithSelector:(SEL) selector withObject:(id) object1 withObject:(id) object2 withObject:(id) object3 {
    return [self initWithSelector:selector withObject:object1 withObject:object2 withObject:object3 parameterCount:3];
}

+ (id) objectMessage:(SEL) selector {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector]);
}

+ (id) objectMessage:(SEL) selector withObject:(id) object  {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector withObject:object]);
}

+ (id) objectMessage:(SEL) selector withObject:(id) object1 withObject:(id) object2  {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector withObject:object1 withObject:object2]);
}

+ (id) objectMessage:(SEL) selector withObject:(id) object1 withObject:(id) object2  withObject:(id) object3 {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector withObject:object1 withObject:object2 withObject:object3]);
}

+ (id) eventKey {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_parameter1 release];
    [_parameter2 release];
    [_parameter3 release];
    [super dealloc];
}
#endif

- (void) releaseToCache {

}

- (void) performOnTarget:(id) target {

    id args[4] = {
        _parameter1,
        _parameter2,
        _parameter3,
        nil
    };

    FLPerformSelector(target, self.selector, args, self.parameterCount);
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@", NSStringFromSelector(self.selector)];
}

@end

@implementation NSObject (FLObjectMessage)

- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener {
    [FLRetainWithAutorelease(listener) receiveObjectMessage:FLRetainWithAutorelease(message)];
}

- (void) receiveObjectMessage:(FLObjectMessage*) message {
    [message performOnTarget:self];
    [message releaseToCache];
}
@end

@implementation NSArray (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener {
    for(id object in self) {
        [object sendObjectMessage:message toListener:listener];
    }
}
@end

@implementation NSDictionary (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener {
    for(id object in [self objectEnumerator]) {
        [object sendObjectMessage:message toListener:listener];
    }
}
@end

@implementation NSSet (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener {
    for(id object in self) {
        [object sendObjectMessage:message toListener:listener];
    }
}
@end

#import "FLOrderedCollection.h"

@implementation FLOrderedCollection (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener {
    for(id object in [self forwardObjectEnumerator]) {
        [object sendObjectMessage:message toListener:listener];
    }
}
@end

