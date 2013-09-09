//  FLConfirmations.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
// this is meant to be included by FLAssertions.h

#import "FL_ASSERT.h"

#define FL_CONFIRM_THROWER(__CODE__, __REASON__, __COMMENT__) \
            FLThrowError([FLAssertionFailedError assertionFailedError:__CODE__ reason:__REASON__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

#define FLConfirmationFailed() \
            FL_ASSERT_FAILED(FL_CONFIRM_THROWER)

#define FLConfirmationFailedWithComment(__FORMAT__, ...) \
            FL_ASSERT_FAILED__WITH_COMMENT(FL_CONFIRM_THROWER, __FORMAT__, ##__VA_ARGS__)

#define FLConfirm(__CONDITION__) \
            FL_ASSERT(FL_CONFIRM_THROWER, __CONDITION__)

#define FLConfirmWithComment(__CONDITION__, __FORMAT__, ...) \
            FL_ASSERT_WITH_COMMENT(FL_CONFIRM_THROWER, __CONDITION__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmIsNil(__PTR__) \
            FL_ASSERT_IS_NIL(FL_CONFIRM_THROWER, __PTR__)

#define FLConfirmIsNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NIL_WITH_COMMENT(FL_CONFIRM_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmIsNotNil(__PTR__) \
            FL_ASSERT_IS_NOT_NIL(FL_CONFIRM_THROWER, __PTR__)

#define FLConfirmIsNotNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(FL_CONFIRM_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmStringIsNotEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_NOT_EMPTY(FL_CONFIRM_THROWER, __STRING__)

#define FLConfirmStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_CONFIRM_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmStringIsEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_EMPTY(FL_CONFIRM_THROWER, __STRING__)

#define FLConfirmStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_CONFIRM_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLConfirmStringsAreEqual(a,b) \
            FLConfirm(FLStringsAreEqual(a,b));

#define FLConfirmStringsNotEqual(a,b) \
            FLConfirm(!FLStringsAreEqual(a,b));

#define FLConfirmIsKindOfClass(__OBJ__, __CLASS__) \
            FLConfirm([__OBJ__ isKindOfClass:[__CLASS__ class]])

#define FLConfirmConformsToProcol(__OBJ__, __PROTOCOL__) \
            FLConfirm([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])

#define FLConfirmNotNil \
            FLConfirmIsNotNil

#define FLConfirmNotNilWithComment \
            FLConfirmIsNotNilWithComment

#define FLConfirmNil \
            FLConfirmIsNil

#define FLConfirmNilWithComment \
            FLConfirmIsNilWithComment


/*

//#import "FLStackTrace.h"

#define FLThrowConfirmationFailure(__CODE__, __REASON__, __COMMENT__) \
            FLThrowError([FLAssertionFailedError assertionFailedError:__CODE__ reason:__REASON__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

/// @brief: Assert that any condition is true
#define FLConfirm(__CONDITION__) \
    if((__CONDITION__) == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureCondition, FLStringWithFormatOrNil(@"(%s) != YES", #__CONDITION__), nil)

/// @brief: Assert that any condition is true
#define FLConfirmWithComment(__CONDITION__, __COMMENT__, ...) \
    if((__CONDITION__) == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureCondition, FLStringWithFormatOrNil(@"(%s) != YES", #__CONDITION__), FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__))


NS_INLINE BOOL __FLConfirmationDidFail() { return NO; }


/// @brief: This will throw an diction failure exception
#define FLConfirmationFailure() \
            FLConfirm(__FLConfirmationDidFail())       

/// @brief: This will throw an diction failure exception
#define FLConfirmationFailedWithComment(__COMMENT__, ...) \
            FLConfirmWithComment(__FLConfirmationDidFail(), __COMMENT__, ##__VA_ARGS__)
                                         

/// @brief: Assert a pointer is nil
#define FLConfirmIsNil(__CONDITION__) \
    if((__CONDITION__) != nil) \
        FLThrowConfirmationFailure( FLAssertionFailureIsNotNil, \
                                            FLStringWithFormatOrNil(@"\"%s != nil\"", #__CONDITION__), \
                                            @"Assertion Failure")

/// @brief: Assert a pointer is nil
#define FLConfirmIsNilWithComment(__CONDITION__, __COMMENT__, ...) \
    if((__CONDITION__) != nil) \
        FLThrowConfirmationFailure( FLAssertionFailureIsNotNil, \
                                            FLStringWithFormatOrNil(@"\"%s != nil\"", #__CONDITION__), \
                                            FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a pointer is NOT nil
#define FLConfirmIsNotNil(__CONDITION__) \
    if((__CONDITION__) == nil) \
        FLThrowConfirmationFailure( FLAssertionFailureIsNil, \
                                            FLStringWithFormatOrNil(@"\"%s == nil\"", #__CONDITION__), \
                                            @"Assertion Failure")


/// @brief: Assert a pointer is NOT nil
#define FLConfirmIsNotNilWithComment(__CONDITION__, __COMMENT__, ...) \
    if((__CONDITION__) == nil) \
        FLThrowConfirmationFailure( FLAssertionFailureIsNil, \
                                            FLStringWithFormatOrNil(@"\"%s == nil\"", #__CONDITION__), \
                                            FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a string is empty (either nil or of length 0)
/// empty is either nil or of zero length
#define FLConfirmStringIsNotEmpty(__STRING__) \
    if(FLStringIsEmpty(__STRING__)) \
        FLThrowConfirmationFailure(FLAssertionFailureIsEmpty, FLStringWithFormatOrNil(@"String unexpectedly empty: %s", #__STRING__), nil) 

/// @brief: Assert a string is empty (either nil or of length 0)
/// empty is either nil or of zero length
#define FLConfirmStringIsNotEmptyWithComment(__STRING__, __COMMENT__, ...) \
    if(FLStringIsEmpty(__STRING__)) \
        FLThrowConfirmationFailure(FLAssertionFailureIsEmpty, FLStringWithFormatOrNil(@"String unexpectedly empty: %s", #__STRING__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert a string is NOT empty
/// empty is either nil or of zero length
#define FLConfirmStringIsEmpty(__STRING__) \
    if((FLStringIsNotEmpty(__STRING__)) \
        FLThrowConfirmationFailure(FLAssertionFailureIsNotEmpty, FLStringWithFormatOrNil(@"String unexpectedly not empty: %s", #__STRING__), nil) 


/// @brief: Assert a string is NOT empty
/// empty is either nil or of zero length
#define FLConfirmStringIsEmptyWithComment(__STRING__, __COMMENT__, ...) \
    if((FLStringIsNotEmpty(__STRING__)) \
        FLThrowConfirmationFailure(FLAssertionFailureIsNotEmpty, FLStringWithFormatOrNil(@"String unexpectedly not empty: %s", #__STRING__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 


/// @brief: Assert values are equal
/// a value is anything that can be compared with ==
#define FLConfirmAreEqual(__LHS__, __RHS__) \
    if((__LHS__) != (__RHS__)) \
        FLThrowConfirmationFailure(FLAssertionFailureAreNotEqual, FLStringWithFormatOrNil(@"%sis unexpectedly not equal to %s", #__LHS__, #__RHS__), nil) 

/// @brief: Assert values are equal
/// a value is anything that can be compared with ==
#define FLConfirmAreEqualWithComment(__LHS__, __RHS__, __COMMENT__, ...) \
    if((__LHS__) != (__RHS__)) \
        FLThrowConfirmationFailure(FLAssertionFailureAreNotEqual, FLStringWithFormatOrNil(@"%sis unexpectedly not equal to %s", #__LHS__, #__RHS__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert values are NOT equal
/// a value is anything that can be compared with !=
#define FLConfirmAreNotEqual(__LHS__, __RHS__) \
    if((__LHS__) == (__RHS__)) \
        FLThrowConfirmationFailure(FLAssertionFailureAreEqual, FLStringWithFormatOrNil(@"%sis unexpectedly equal to %s", #__LHS__, #__RHS__), nil) 

/// @brief: Assert values are NOT equal
/// a value is anything that can be compared with !=
#define FLConfirmAreNotEqualWithComment(__LHS__, __RHS__, __COMMENT__, ...) \
    if((__LHS__) == (__RHS__)) \
        FLThrowConfirmationFailure(FLAssertionFailureAreEqual, FLStringWithFormatOrNil(@"%sis unexpectedly equal to %s", #__LHS__, #__RHS__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert objects are equal
/// this uses [NSObject isEqual] for the comparison
#define FLConfirmObjectsAreEqual(__LHS__, __RHS__) \
    if([(__LHS__) isEqual:(__RHS__)] == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureAreNotEqual, FLStringWithFormatOrNil(@"%sis unexpectedly not equal to %s", #__LHS__, #__RHS__), nil) 

/// @brief: Assert objects are equal
/// this uses [NSObject isEqual] for the comparison
#define FLConfirmObjectsAreEqualWithComment(__LHS__, __RHS__, __COMMENT__, ...) \
    if([(__LHS__) isEqual:(__RHS__)] == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureAreNotEqual, FLStringWithFormatOrNil(@"%sis unexpectedly not equal to %s", #__LHS__, #__RHS__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert objects are not equal
/// this uses [NSObject isEqual] for the comparison
#define FLConfirmObjectsAreNotEqual(__LHS__, __RHS__) \
    if([(__LHS__) isEqual:(__RHS__)] == YES) \
        FLThrowConfirmationFailure(FLAssertionFailureAreEqual, FLStringWithFormatOrNil(@"%sis unexpectedly equal to %s", #__LHS__, #__RHS__), nil) 

/// @brief: Assert objects are not equal
/// this uses [NSObject isEqual] for the comparison
#define FLConfirmObjectsAreNotEqualWithComment(__LHS__, __RHS__, __COMMENT__, ...) \
    if([(__LHS__) isEqual:(__RHS__)] == YES) \
        FLThrowConfirmationFailure(FLAssertionFailureAreEqual, FLStringWithFormatOrNil(@"%sis unexpectedly equal to %s", #__LHS__, #__RHS__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 

/// @brief: Assert an object is kind of class
#define FLConfirmIsKindOfClass(__LHS__, __RHS__) \
    if([__LHS__ isKindOfClass:NSClassFromString(@#__RHS__)] == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureAreEqual, FLStringWithFormatOrNil(@"%sis unexpectedly not kind of class %s", #__LHS__, #__RHS__), nil) 

/// @brief: Assert an object is kind of class
#define FLConfirmIsKindOfClassWithComment(__LHS__, __RHS__, __COMMENT__, ...) \
    if([__LHS__ isKindOfClass:NSClassFromString(@#__RHS__)] == NO) \
        FLThrowConfirmationFailure(FLAssertionFailureAreEqual, FLStringWithFormatOrNil(@"%sis unexpectedly not kind of class %s", #__LHS__, #__RHS__),  FLStringWithFormatOrNil(__COMMENT__, ##__VA_ARGS__)) 


*/