//
//  FLSelector.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSelector.h"
#import "FLObjcRuntime.h"
#import "FishLampMinimum.h"

@implementation FLSelector 

@synthesize selector = _selector;

- (id) init {
    return [self initWithSelector:nil];
}

- (id) initWithSelector:(SEL) selector {

    self = [super init];
    if(self) {
        _selector = selector;
        _argumentCount = ULONG_MAX;
    }
    return self;
}

- (id) initWithString:(NSString*) string {
    self = [self initWithSelector:NSSelectorFromString(string)];
    if(self) {
        _name = FLRetain(string);
    }

    return self;
}

+ (id) selector:(SEL) selector {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector]);
}

+ (id) selectorWithString:(NSString*) string {
    return FLAutorelease([[[self class] alloc] initWithString:string]);
}

#if FL_MRC
- (void) dealloc {
    [_name release];
    [super dealloc];
}
#endif

- (NSString*) name {
    if(!_name) {
        _name = FLRetain(NSStringFromSelector(_selector));
    }
    return _name;
}

- (NSUInteger) argumentCount {
    if(_argumentCount == ULONG_MAX) {
        _argumentCount = FLArgumentCountForSelector(_selector);
    }
    return _argumentCount;
}

- (id) copyWithZone:(NSZone *)zone {
    return FLRetain(self);
}

- (BOOL) isEqualToSelector:(SEL) selector {
    return FLSelectorsAreEqual(selector, _selector);
}

- (BOOL) isEqual:(id)object {
    return [self.name isEqualToString:[object name]];
}

- (NSUInteger)hash {
    return (NSUInteger) [self.name hash];
}

- (NSString*) description {
    return self.name;
}

- (BOOL) willPerformOnTarget:(id) target {
    return [target respondsToSelector:_selector];
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (void) performWithTarget:(id) target {
    FLAssert(self.argumentCount == 0);
    [target performSelector:_selector];
}

- (void) performWithTarget:(id) target
                withObject:(id) object {
    FLAssert(self.argumentCount == 1);
    [target performSelector:_selector withObject:object];
}

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2 {
    FLAssert(self.argumentCount == 2);
    [target performSelector:_selector withObject:object1 withObject:object2];
}

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {
    FLAssert(self.argumentCount == 3);
    [target performSelector_fl:_selector withObject:object1 withObject:object2 withObject:object3];
}

- (void) performWithTarget:(id) target
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4 {
    FLAssert(self.argumentCount == 4);
    [target performSelector_fl:_selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
}

#pragma GCC diagnostic pop

@end
