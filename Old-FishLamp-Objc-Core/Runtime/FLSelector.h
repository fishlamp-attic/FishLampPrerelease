//
//  FLSelector.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/13/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

@interface FLSelector : NSObject<NSCopying> {
@private
    SEL _originalSelector;
    SEL _selector;
    int _argumentCount;
    NSString* _selectorString;
    NSValue* _selectorValue;
    
    dispatch_once_t _predicates[3];
}

@property (readonly, nonatomic) SEL originalSelector;
@property (readwrite, nonatomic) SEL selector;

@property (readonly, assign) int argumentCount;
@property (readonly, strong) NSString* selectorString;
@property (readonly, strong) NSValue* selectorValue;


- (id) initWithSelector:(SEL) selector;
- (id) initWithSelector:(SEL) selector argCount:(NSUInteger) argCount;
+ (id) selector:(SEL) selector;
+ (id) selector:(SEL) selector argCount:(NSUInteger) argCount;

@end