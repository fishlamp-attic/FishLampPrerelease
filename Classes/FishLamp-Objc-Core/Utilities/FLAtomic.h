//
//  FlAtomicBitFlags.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCoreRequired.h"

#import <libkern/OSAtomic.h>
#import "_FLAtomic.h"

#define FLAtomicSet64(__INTEGER__, __NEW_INTEGER_VALUE__) \
            _FLAtomicSet64((int64_t*)&(__INTEGER__), (int64_t) __NEW_INTEGER_VALUE__)

#define FLAtomicGet64(__INTEGER__) \
            _FLAtomicGet64((int64_t*)&(__INTEGER__))

#define FLAtomicSet32(__INTEGER__, __NEW_INTEGER_VALUE__) \
            _FLAtomicSet32((int32_t*)&(__INTEGER__), (int32_t) __NEW_INTEGER_VALUE__)

#define FLAtomicGet32(__INTEGER__) \
            _FLAtomicGet32((int32_t*)&(__INTEGER__))

#define FLAtomicIncrement32(__INTEGER__) \
            OSAtomicIncrement32((int32_t*) &(__INTEGER__))

#define FLAtomicDecrement32(__INTEGER__) \
            OSAtomicDecrement32((int32_t*) &(__INTEGER__))

#define FLAtomicIncrement64(__INTEGER__) \
            OSAtomicIncrement64((int64_t*) &(__INTEGER__))

#define FLAtomicDecrement64(__INTEGER__) \
            OSAtomicDecrement64((int64_t*) &(__INTEGER__))


// for use with pointers and NSInteger, etc.
// LP64 = "Longs and Pointers are 64 bit"

#if FL_INT64

    #define FLAtomicGetInteger         FLAtomicGet64

    #define FLAtomicSetInteger         FLAtomicSet64

    #define FLAtomicIncrementInteger   FLAtomicIncrement64

    #define FLAtomicDecrementInteger   FLAtomicIncrement64

    #define fl_atomic_integer_t           int64_t

#else 

    #define FLAtomicGetInteger         FLAtomicGet32

    #define FLAtomicSetInteger         FLAtomicSet32

    #define FLAtomicIncrementInteger   FLAtomicIncrement32

    #define FLAtomicDecrementInteger   FLAtomicIncrement32

    #define fl_atomic_integer_t           int32_t

#endif


#define FLAtomicGetPointer_(__POINTER__) \
            ((void*) FLAtomicGetInteger((fl_atomic_integer_t*) &(__POINTER__)))

//#define FLAtomicGetObject_(__OBJECT__) \
//            FLBridge(id, FLAtomicGetInteger_(FLBridge(fl_atomic_integer_t*, &(__OBJECT__))))
       
#define FLAtomicSetPointer_(__POINTER__, __NEW_POINTER__) \
            FLAtomicSetInteger((fl_atomic_integer_t*) &(__POINTER__), (fl_atomic_integer_t*) __NEW_POINTER__)

//#define FLAtomicSetObject_(__OBJECT__, __NEW_OBJECT__) \
//            FLAtomicSetInteger_(FLBridge(fl_atomic_integer_t*, &(__OBJECT__)), FLBridge(fl_atomic_integer_t, __NEW_OBJECT__))




