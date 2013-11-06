//
//  FLArgumentList.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArgumentList.h"

@interface FLArgumentList ()
@end

@implementation FLArgumentList
@synthesize count = _count;

- (id) initWithArgumentCount:(int) count arguments:(id[]) arguments {
    
    self = [super init];
    if(self) {
        _count = count;
        if(_count) {
            for(int i = 0; i < count; i++) {
                FLSetObjectWithRetain(_arguments[i], arguments[i]);
            }
        }
    }

    return self;
}                  

//#define callVardicMethodSafely(values...) ({ values *v = { values }; _actualFunction(values, sizeof(v) / sizeof(*v)); })


- (id) initWithArgument:(id) object1 {
    return [self initWithArgumentCount:1 arguments:(id[]) { object1 }];
}

- (id) initWithArgument:(id) object1 withObject:object2 {
    return [self initWithArgumentCount:2 arguments:(id[]) { object1, object2 }];
}

- (id) initWithArgument:(id) object1 withObject:object2 withObject:object3 {
    return [self initWithArgumentCount:3 arguments:(id[]) { object1, object2, object3 }];
}

- (id) init {
    return [self initWithArgumentCount:0 arguments:nil];
}

#if FL_MRC
- (void) dealloc {
    for(int i = 0; i < FLArgumentListMaxArgumentCount; i++) {
        [_arguments[i] release];
    }
    [super dealloc];
}
#endif

- (id) argument:(NSUInteger) argIndex {
    return _arguments[argIndex];
}

- (id) argument {
    return _arguments[0];
}

- (void) setArgument:(id) object atIndex:(NSUInteger) argIndex {
    FLSetObjectWithRetain(_arguments[argIndex], object);
}

#define InitArguments(__OBJ__, __FIRST__) \
        if(__FIRST__) { \
            va_list valist; \
            va_start(valist, __FIRST__); \
            [__OBJ__ setArguments:__FIRST__ valist:valist]; \
            va_end(valist); \
        }

- (void) setArguments:(id) first valist:(va_list) valist {
    FLSetObjectWithRetain(_arguments[_count++], first);
    id obj = nil;
    while ((obj = va_arg(valist, id))) { 
        FLAssertWithComment(_count < FLArgumentListMaxArgumentCount, @"too many arguments");
        FLSetObjectWithRetain(_arguments[_count++], obj);
    }
}

- (id) initWithFirstArgument:(id) arg valist:(va_list) valist {
    self = [super init];
    if(self) {
        [self setArguments:arg valist:valist];
    }
    return self;
}

- (id) initWithArguments:(id) argument, ... {
    self = [super init];
    if(self) {
        InitArguments(self, argument);
    }
    return self;
}

+ (id) argumentListWithArguments:(id) argument, ... {
    FLArgumentList* list = FLAutorelease([[[self class] alloc] init]);
    InitArguments(list, argument);
    return list;
}

+ (id) argumentList:(id) argument1 {
    return FLAutorelease([[[self class] alloc] initWithArgument:argument1]);
}

+ (id) argumentList:(id) argument1 withObject:(id) argument2 {
    return FLAutorelease([[[self class] alloc] initWithArgument:argument1 withObject:argument2]);
}

+ (id) argumentList:(id) argument1 withObject:(id) argument2 withObject:(id) argument3 {
    return FLAutorelease([[[self class] alloc] initWithArgument:argument1 withObject:argument2 withObject:argument3]);
}

+ (id) argumentListWithArgumentCount:(int) count arguments:(id[]) arguments {
    return FLAutorelease([[[self class] alloc] initWithArgumentCount:count arguments:arguments]);
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(id __unsafe_unretained [])buffer 
                                    count:(NSUInteger)len {
	unsigned long currentIndex = state->state;
    if(currentIndex >= _count) {
		return 0;
	}
	
    state->state = MIN(_count - 1, currentIndex + len);

    NSUInteger count = state->state - currentIndex;

    int bufferIndex = 0;
    for(int i = currentIndex; i < count; i++) {
        buffer[bufferIndex] = _arguments[i];
    }

    state->itemsPtr = buffer;
    
    // this is an immutable object, so it will never be mutated
    static unsigned long s_mutations = 0;
    
	state->mutationsPtr = &s_mutations;
	return count;
}

@end
