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

@implementation FLSelector 

@synthesize selector = _selector;
@synthesize originalSelector = _originalSelector;

- (id) init {
    return [self initWithSelector:nil argCount:-1];
}

- (id) initWithSelector:(SEL) selector  {
    return [self initWithSelector:selector argCount:-1];
}

- (id) initWithSelector:(SEL) selector  
               argCount:(NSUInteger) argCount {
               
    self = [self initWithSelector:selector];
    if(self) {
        _originalSelector = selector;
        _selector = selector;
        _argumentCount = argCount;
    }
    return self;
}

+ (id) selector:(SEL) selector {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector]);
}

+ (id) selector:(SEL) selector argCount:(NSUInteger) argCount {
    return FLAutorelease([[[self class] alloc] initWithSelector:selector argCount:argCount]);
}

#if FL_MRC
- (void) dealloc {
    [_selectorValue release];
    [_selectorString release];
    [super dealloc];
}
#endif

- (NSString*) selectorString {
    dispatch_once(&_predicates[0], ^{
        _selectorString = FLRetain(NSStringFromSelector(_originalSelector));
    });
    return _selectorString;
}

- (NSValue*) selectorValue {
    dispatch_once(&_predicates[1], ^{
        _selectorValue = FLRetain([NSValue valueWithPointer:_originalSelector]); 
    });
    return _selectorValue;
}

- (int) argumentCount {
    if(_argumentCount == -1) {
        dispatch_once(&_predicates[2], ^{
            _argumentCount = FLArgumentCountForSelector(_originalSelector);
        });
    }
    
    return _argumentCount;
}

- (id) copyWithZone:(NSZone *)zone {

    FLSelector* selector = [[FLSelector alloc] initWithSelector:self.originalSelector argCount:self.argumentCount];
    selector.selector = self.selector;
    return selector;
}

//- (BOOL)isEqual:(id)object {
//    return FLSelectorsAreEqual(_selector, [object selector]);
//}
//
//- (NSUInteger)hash {
//    return (NSUInteger) [self.selectorString hash];
//}

- (NSString*) description {
    return self.selectorString;
}

@end
