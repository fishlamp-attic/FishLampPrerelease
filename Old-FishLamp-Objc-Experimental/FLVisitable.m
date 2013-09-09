//
//  FLVisitable.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/12/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLVisitable.h"

@interface FLVisitable ()
@property (readwrite, strong) NSArray* iterationList;
@end


@implementation NSObject (FLVisitable)
- (BOOL) isVisitable {
    return NO;
}
- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor {
    return NO;
}
@end

@implementation NSArray (FLVisitable)

- (BOOL) isVisitable {
    return YES;
}

- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor {
    __block BOOL didStop = NO;

// i don't think a container should be visited
//    visitor(self, &stop);
//    
//    if(stop) {
//        return YES;
//    }
    
    [self enumerateObjectsUsingBlock: ^(id object, NSUInteger idx, BOOL* stop) {
        if([object isVisitable]) {
            if([object visit:visitor]) {
                *stop = YES;
                didStop = YES;
            }
        }
    }];
    
    return didStop;
}
@end

@implementation NSDictionary (FLVisitable)

- (BOOL) isVisitable {
    return YES;
}

- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor {
    __block BOOL didStop = NO;

// i don't think a container should be visited
//    visitor(self, &stop);
//    
//    if(stop) {
//        return YES;
//    }
    
    [self enumerateKeysAndObjectsUsingBlock: ^(id key, id object, BOOL* stop) {
        if([object isVisitable]) {
            if([object visit:visitor]) {
                *stop = YES;
                didStop = YES;
            }
        }
    }];
    
    return didStop;
}
@end




@implementation FLVisitable

@synthesize visitable = _visitable;
@synthesize iterationList = _iterationList;

- (id) init {
    self = [super init];
    if(self) {
        self.visitable = YES;
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_iterationList release];
    [_children release];
    [super dealloc];
}
#endif

- (void) addVisitable:(id) object {

    FLAssertIsNotNil(object);

    @synchronized(self) {
        if(!_children) {
            _children = [[NSMutableArray alloc] init];
        }
        
        [_children addObject:object];
        self.iterationList = nil;
    }
}

- (void) removeVisitable:(id) object {
    @synchronized(self) {
        [_children removeObject:object];
        self.iterationList = nil;
    }
}

- (NSArray*) iterationSafeList {
    NSArray* iterationList = self.iterationList;
    if(!iterationList  && _children) {
        @synchronized(self) {
            iterationList = self.iterationList;
            if(!iterationList && _children) {
                iterationList = FLAutorelease([_children copy]);
                self.iterationList = iterationList;
            }
        }
    }
    
    return FLAutorelease(FLRetain(iterationList));
}

- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor {
    
    if(self.isVisitable) {
        BOOL stop = NO;
        visitor(self, &stop);

        if(stop) {
            return YES;
        }
        NSArray* list = [self iterationSafeList];
        if(list && [list visit:visitor]) {
            return YES;
        }
    }
    
    return NO;
}

@end

