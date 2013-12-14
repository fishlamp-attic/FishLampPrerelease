//
//  FLUnretained.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/16/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUnretained.h"
#import "FLDeallocNotifier.h"

@implementation FLUnretained

//- (void) setToNil:(FLDeletedObjectReference*) sender {
//    FLAssertWithComment(sender.deletedObject == _object, @"message sent to wrong unretained?");
//    self.object = nil;
//    _deadObject = sender.deletedObject;
//}

- (id) object {
    return _weakRef.object;
}

- (FLSimpleNotifier*) notifier {
    return _weakRef;
}

#if FL_MRC
- (void) dealloc {
    [_weakRef release];
    [super dealloc];
}
#endif

- (void) setObject:(id) object {
    _deadObject = object;
    _weakRef.object = object;
}

- (id) init {
    _weakRef = [FLWeakReference new];
    return self;
}

- (id) initWithObject:(id) object {
    self = [self init];
    if(self) {
        self.object = object;
    }
    return self;
}

+ (id) unretained:(id) object {
	return FLAutorelease([[[self class] alloc] initWithObject:object]);
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    id myObject = self.object;
    if (myObject ) {
        [invocation setTarget:myObject];
        [invocation invoke];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel  {
    return [self.object methodSignatureForSelector:sel];
}

- (BOOL) isEqual:(id) object {
    
    id myObject = self.object;
    
    if(self == object || myObject == object) {
        return YES;
    }
    
    id theObject = object;
    if([object isKindOfClass:[FLUnretained class]]) {
        theObject = [object object];
    
        if( theObject == myObject ) {
            return YES;
        }
    }

    if(myObject) {
        return theObject ? [myObject isEqual:theObject] : NO;
    }
    else if(_deadObject && theObject == _deadObject) {
        return YES;
    }

    return NO;
}

- (NSUInteger)hash {
    return _weakRef.hash;
}

- (NSString*) description {
    id myObject = self.object;
    return myObject ? [myObject description] : @"(NULL)";
}

@end

@implementation NSObject (FLUnretained)
- (id) unretained {
    return [FLUnretained unretained:self];
}
@end


