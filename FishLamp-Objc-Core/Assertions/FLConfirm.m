//
//  FLConfirmations.m
//  FishLampCore
//
//  Created by Mike Fullerton on 2/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLConfirm.h"
#import "FLAssert.h"

/*
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
*/

#if VA_ARG_EXPERIMENTAL

#define callVardicMethodSafely(values...) ({ values *v = { values }; _actualFunction(values, sizeof(v) / sizeof(*v)); })

#define kMaxSize 20
NSString* func(id condition, ...) {
    
    NSString* first = nil;

    void* fake_list[kMaxSize];
    NSUInteger count = 0;
    va_list valist; 
    va_start(valist, condition); 
    void* obj = nil;
    while ((obj = va_arg(valist, void*))) { 
        if(count == 0) {
            first = FLBridge(id, obj);
        }
        else {
            FLAssert(count < kMaxSize);
            fake_list[count] = obj;
        }
        count++;
    }
    va_end(valist); 

    if(count == 0) {
        return condition;
    }
    NSString* formattedString = first;
    if(count > 1) {
        formattedString = FLAutorelease([[NSString alloc] initWithFormat:first arguments: (void*) fake_list]);
    }
 
    return [NSString stringWithFormat:@"%@ (%@)", condition, formattedString];
}    

#define YO(FOO, ...) if(FOO) func([NSString stringWithCString:#FOO encoding:NSASCIIStringEncoding], ##__VA_ARGS__)


void test() {
    YO(1 == 1);
    YO(1 == 1, @"HI");
    YO(1 == 1, @"HI %@", @"THERE");
    YO(1 == 1, @"HI %@ %d %f", @"THERE", 4, 2.5);
}

#endif

//void FLThrowConfirmationFailedException(FLAssertionFailure failure, NSString* description, NSString* comment, FLStackTrace* stackTrace) {
//    
////    test();
//
//    FLThrowException([NSException exceptionWithError:[NSError errorWithDomain:FLAssertionFailureErrorDomain 
//            code:failure
//            userInfo:nil
//            reason:description
//            comment:comment 
//            stackTrace:stackTrace]]); 
//}
//
//BOOL __FLConfirmationDidFail() {
//    return YES;
//}
//

#if DEPRECATED
/// @brief: Assert a BOOL is true
/// the is the same as AssertYes
#define FLConfirmIsTrue(__BOOL__) \
    if((__BOOL__) == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureIsFalse, FLStringWithFormatOrNil(@"Condition unexpectedly false: %s", #__BOOL__), nil) 

/// @brief: Assert a BOOL is true
/// the is the same as AssertYes
#define FLConfirmIsTrueWithComment(__BOOL__, __COMMENT__, ...) \
    if((__BOOL__) == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureIsFalse, FLStringWithFormatOrNil(@"Condition unexpectedly false: %s", #__BOOL__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 
            
/// @brief: Assert a BOOL is false
/// this is the same as AssertNo
#define FLConfirmIsFalse(__BOOL__) \
    if((__BOOL__) == YES) \
        FLThrowConfirmationFailure(FLAssertionFailureIsTrue, FLStringWithFormatOrNil(@"Condition unexpectedly true: %s", #__BOOL__), nil) 

/// @brief: Assert a BOOL is false
/// this is the same as AssertNo
#define FLConfirmIsFalseWithComment(__BOOL__, __COMMENT__, ...) \
    if((__BOOL__) == YES) \
        FLThrowConfirmationFailure(FLAssertionFailureIsTrue, FLStringWithFormatOrNil(@"Condition unexpectedly true: %s", #__BOOL__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a BOOL is YES
/// this is the same as AssertTrue
#define FLConfirmIsYes(__BOOL__) \
    if((__BOOL__) == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureIsFalse, FLStringWithFormatOrNil(@"Condition unexpectedly NO: %s", #__BOOL__), nil) 

/// @brief: Assert a BOOL is YES
/// this is the same as AssertTrue
#define FLConfirmIsYesWithComment(__BOOL__, __COMMENT__, ...) \
    if((__BOOL__) == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureIsFalse, FLStringWithFormatOrNil(@"Condition unexpectedly NO: %s", #__BOOL__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a BOOL is NO
/// this is the same as AssertNO
#define FLConfirmIsNo(__BOOL__) \
    if((__BOOL__) == YES) \
        FLThrowConfirmationFailure(FLAssertionFailureIsTrue, FLStringWithFormatOrNil(@"Condition unexpectedly YES: %s", #__BOOL__), nil) 

/// @brief: Assert a BOOL is NO
/// this is the same as AssertNO
#define FLConfirmIsNoWithComment(__BOOL__, __COMMENT__, ...) \
    if((__BOOL__) == YES) \
        FLThrowConfirmationFailure(FLAssertionFailureIsTrue, FLStringWithFormatOrNil(@"Condition unexpectedly YES: %s", #__BOOL__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert code is implemented
#define FLConfirmIsImplemented() \
        FLThrowConfirmationFailure(FLAssertionFailureNotImplemented, nil, nil) 

/// @brief: Assert code is implemented
#define FLConfirmIsImplementedWithComment(__COMMENT__, ...) \
        FLThrowConfirmationFailure(FLAssertionFailureNotImplemented, nil,  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert if the code isn't fixed
#define FLConfirmIsFixed() \
        FLThrowConfirmationFailure(FLAssertionFailureFixMe, nil, nil) 

/// @brief: Assert if the code isn't fixed
#define FLConfirmIsFixedWithComment(__COMMENT__, ...) \
        FLThrowConfirmationFailure(FLAssertionFailureFixMe, nil,  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assertion fails because there's known bug here
#define FLConfirmIsBug() \
        FLThrowConfirmationFailure(FLAssertionFailureBug, nil, nil) 

/// @brief: Assertion fails because there's known bug here
#define FLConfirmIsBugWithComment(__COMMENT__, ...) \
        FLThrowConfirmationFailure(FLAssertionFailureBug, nil,  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: clients of this code must override this
#define FLConfirmIsOverridden() \
        FLThrowConfirmationFailure(FLAssertionFailureRequiredOverride, nil, nil) 

/// @brief: clients of this code must override this
#define FLConfirmIsOverriddenWithComment(__COMMENT__, ...) \
        FLThrowConfirmationFailure(FLAssertionFailureRequiredOverride, nil,  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 


#endif