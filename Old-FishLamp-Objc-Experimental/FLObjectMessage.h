//
//  FLObjectMessage.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Foundation/Foundation.h>


@interface FLObjectMessage : NSObject {
@private
    SEL _selector;
    id _parameter1;
    id _parameter2;
    id _parameter3;
    NSInteger _parameterCount;
}

@property (readonly, assign, nonatomic) SEL selector;
@property (readonly, strong, nonatomic) id parameter1;
@property (readonly, strong, nonatomic) id parameter2;
@property (readonly, strong, nonatomic) id parameter3;
@property (readonly, assign, nonatomic) NSInteger parameterCount;

- (id) initWithSelector:(SEL) selector;
- (id) initWithSelector:(SEL) selector withObject:(id) object1;
- (id) initWithSelector:(SEL) selector withObject:(id) object1 withObject:(id) object2;
- (id) initWithSelector:(SEL) selector withObject:(id) object1 withObject:(id) object2 withObject:(id) object3;

+ (id) objectMessage:(SEL) selector;
+ (id) objectMessage:(SEL) selector withObject:(id) object;
+ (id) objectMessage:(SEL) selector withObject:(id) object1 withObject:(id) object2;
+ (id) objectMessage:(SEL) selector withObject:(id) object1 withObject:(id) object2 withObject:(id) object3;

- (void) performOnTarget:(id) target;

- (void) releaseToCache;
@end

@interface NSObject (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener;
- (void) receiveObjectMessage:(FLObjectMessage*) message;
@end

@interface NSArray (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener;
@end

@interface NSDictionary (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener;
@end

@interface NSSet (FLObjectMessage)
- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener;
@end

//#import "FLOrderedCollection.h"
//
//@interface FLOrderedCollection (FLObjectMessage)
//- (void) sendObjectMessage:(FLObjectMessage*) message toListener:(id) listener;
//@end
