//
//  FLDynamicObject.m
//  FLTools
//
//  Created by Mike Fullerton on 5/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDynamicObject.h"

@implementation FLDynamicObject

@synthesize dataDictionary = _dataDictionary;

- (NSMutableDictionary*) dataDictionary {
    if(!_dataDictionary) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataDictionary;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation setTarget:self.dataDictionary];
    [invocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.dataDictionary methodSignatureForSelector:sel];
}

//+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector {
//
//   return [NSMutableDictionary instanceMethodSignatureForSelector:selector];
// 
//}
//+ (NSMethodSignature )methodSignatureForSelector:(SEL)selector {
//
//    return [NSMutableDictionary methodSignatureForSelector:selector];
//    
////  if      (selector ==  @selector(object)) return [[[NSMethodSignature]] signatureWithObjCTypes:"@@:"];
//// else return [super methodSignatureForSelector:(SEL)selector];
//}

- (id) initWithDictionary:(NSMutableDictionary*) dictionary {
    self.dataDictionary = dictionary;
    return self;
}

+ (id) dynamicObject:(NSMutableDictionary*) dictionary {
    return autorelease_([[[self class] alloc] initWithDictionary:dictionary]);
}

+ (id) dynamicObject {
    return autorelease_([[[self class] alloc] init]);
}

- (id) init {
    return self;
}

//+ (BOOL)respondsToSelector:(SEL)aSelector {
//    return YES;
//}
//
//- (BOOL)respondsToSelector:(SEL)aSelector {
//    return YES;
//}

- (void) dealloc {
    release_(_dataDictionary);
    super_dealloc_();
}   

//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
//    return [self.dataDictionary countByEnumeratingWithState:state objects:buffer count:len];
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    id copy = [[self class] alloc] init];
//    [copy setDataDictionary:[self.dataDictionary mutableCopy]];
//    return copy;
//}
//
//- (id)mutableCopyWithZone:(NSZone *)zone {
//    return [self copyWithZone:zone];
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [self.dataDictionary encodeWithCoder:aCoder];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    _dataDictionary = [[NSMutableDictionary alloc] init];
//    [_dataDictionary initWithCoder:aDecoder];
//    return self;
//}


@end

