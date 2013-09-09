/*
 *  FLObjcRuntime.h
 *  PackMule
 *
 *  Created by Mike Fullerton on 6/29/11.
 *  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
 *
 */
#import "FLCoreRequired.h"
#import <objc/runtime.h>

#import "FLRuntimeInfo.h"

#define FLRuntimeGetSelectorName(__SEL__) sel_getName(__SEL__)
#define FLSelectorsAreEqual(LHS, RHS) sel_isEqual(LHS, RHS)

typedef void (^FLRuntimeClassVisitor)(FLRuntimeInfo info, BOOL* stop);
typedef void (^FLRuntimeSelectorVisitor)(FLRuntimeInfo info, BOOL* stop);
typedef void (^FLRuntimeFilterBlock)(FLRuntimeInfo info, BOOL* passed, BOOL* stop);

extern void FLSwizzleInstanceMethod(Class c, SEL originalSelector, SEL newSelector);

extern void FLSwizzleClassMethod(Class c, SEL originalSelector, SEL newSelector);

extern int FLArgumentCountForSelector(SEL selector);

// doesn't count the first two hidden arguments so a selector like this @selector(foo:) will return 1
extern int FLArgumentCountForClassSelector(Class aClass, SEL selector);

extern NSArray* FLRuntimeMethodsForClass(Class aClass, FLRuntimeFilterBlock filterOrNil);

extern void FLRuntimeVisitEachSelectorInClassAndSuperclass(Class aClass, FLRuntimeSelectorVisitor visitor); // not including NSObject

extern BOOL FLRuntimeVisitEachSelectorInClass(Class aClass, FLRuntimeSelectorVisitor visitor);

extern BOOL FLRuntimeVisitEveryClass(FLRuntimeClassVisitor visitor);

extern NSArray* FLRuntimeAllClassesMatchingFilter(FLRuntimeFilterBlock filter);

extern NSArray* FLRuntimeClassesImplementingInstanceMethod(SEL theMethod);

extern NSArray* FLRuntimeSubclassesForClass(Class theClass);

extern BOOL FLRuntimeClassHasSubclass(Class aSuperclass, Class aSubclass);

extern BOOL FLRuntimeClassRespondsToSelector(Class aClass, SEL aSelector);

extern BOOL FLClassConformsToProtocol(Class aClass, Protocol* aProtocol);

#if DEBUG
void FLRuntimeLogMethodsForClass(Class aClass);
#endif


#if EXPERIMENTAL
@interface NSObject (FLObjcRuntime)


// http://www.cocoawithlove.com/2008/03/supersequent-implementation.html
// Lookup the next implementation of the given selector after the
// default one. Returns nil if no alternate implementation is found.
- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip;

@end

#define invokeSupersequent(...) \
    ([self getImplementationOf:_cmd \
        after:impOfCallingMethod(self, _cmd)]) \
            (self, _cmd, ##__VA_ARGS__)

#define invokeSupersequentNoParameters() \
    ([self getImplementationOf:_cmd \
        after:impOfCallingMethod(self, _cmd)]) \
            (self, _cmd)



#endif