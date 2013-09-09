//
//  FLSelectorUtils.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSelectorPerforming.h"
#import "FLObjcRuntime.h"
#import "FLAssertions.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"


BOOL FLPerformSelector(id target, SEL selector, id __strong * arguments, int argCount) {

    FLAssertWithComment(FLArgumentCountForClassSelector([target class], selector) == argCount, @"@selector(%@) arg count is %d, should be: %d", NSStringFromSelector(selector), argCount, FLArgumentCountForClassSelector([target class], selector));

    if([target respondsToSelector:selector]) {
        [target performSelector_fl:selector withArguments:arguments argumumentCount:argCount];
        return YES;
    }
    return NO;
}

BOOL FLPerformSelector0(id target, SEL selector) {
    if([target respondsToSelector:selector]) {
        [target performSelector:selector];
        return YES;
    }
    return NO;
} 

BOOL FLPerformSelector1(id target, SEL selector, id object) {
    if([target respondsToSelector:selector]) {
        [target performSelector:selector withObject:object];
        return YES;
    }
    return NO;
} 

BOOL FLPerformSelector2(id target, SEL selector, id object1, id object2) {
    if([target respondsToSelector:selector]) {
        [target performSelector:selector withObject:object1 withObject:object2];
        return YES;
    }

    return NO;
} 

BOOL FLPerformSelector3(id target, SEL selector, id object1, id object2, id object3) {
    if([target respondsToSelector:selector]) {
        [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3];
        return YES;
    }

    return NO;
} 

BOOL FLPerformSelector4(id target, SEL selector, id object1, id object2, id object3, id object4) {
    if([target respondsToSelector:selector]) {
        [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3  withObject:object4];
        return YES;
    }

    return NO;
} 

BOOL FLPerformSelectorOnMainThread0(id target, SEL selector) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector:selector];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [target performSelector:selector];
            });
        }
        
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread1(id target, SEL selector, id object) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector:selector withObject:object];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [target performSelector:selector withObject:object];
            });
        }
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread2(id target, SEL selector, id object1, id object2) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector:selector withObject:object1 withObject:object2];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [target performSelector:selector withObject:object1 withObject:object2];
            });
        }
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread3(id target, SEL selector, id object1, id object2, id object3) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3];
            });
        }
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread4(id target, SEL selector, id object1, id object2, id object3, id object4) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
            });
        }
        return YES;
    }
    return NO;
}

// this is fatallay flawed - could be sending an array f
//extern BOOL FLPerformSelectorOnMainThread(id target, SEL selector, id __strong * arguments, int argCount);

//BOOL FLPerformSelectorOnMainThread(id target, SEL selector, NSArray* arguments) {
//
//     FLAssertWithComment(FLArgumentCountForClassSelector([target class], selector) == argCount, @"@selector(%@) arg count is %d, should be: %d", NSStringFromSelector(selector), argCount, FLArgumentCountForClassSelector([target class], selector));
//    
//    if([target respondsToSelector:selector]) {
//        if([NSThread currentThread] == [NSThread mainThread]) {
//            [target performSelector:selector withArguments:arguments argumumentCount:argCount];
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [target performSelector:selector withArguments:arguments argumumentCount:argCount];
//            });
//        }
//        return YES;
//    }
//    return NO;
//}

#pragma GCC diagnostic pop
