////
////  FLObjectPool.h
////  FishLampCocoa
////
////  Created by Mike Fullerton on 12/20/12.
////  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
////
//
//#import "FishLampMinimum.h"
//
//@class FLObjectPool;
//@class FLFifoAsyncQueue;
//
//@protocol FLPoolable <NSObject>
//@property (readonly, strong) FLObjectPool* objectPool;
//- (void) releaseToPool;
//@end
//
//@interface FLObjectPool : NSObject {
//@private
//    NSMutableArray* _objects;
//    Class _objectClass;
//    FLFifoAsyncQueue* _fifoQueue;
//}
//
//- (id) initWithClass:(Class) aClass;
//
//+ (id) objectPoolForClass:(Class) aClass;
//
//- (id) pooledObject;
//
//- (void) addObjectToPool:(id) object;
//
//- (void) stockPool:(NSArray*) withObjects;
//
//@end
//
//extern void FLReleasePooledObject(id __strong * object);
