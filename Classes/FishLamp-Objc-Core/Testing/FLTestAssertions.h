//
//  FLTestAssertions.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FL_ASSERT.h"
#import "FLAssertions.h"
#import "FLExceptions.h"

extern NSException* FLLogTestException(NSException* ex);

#define FLThrowTestException(__EX__) \
            @throw FLLogTestException(__EX__)

#define FLThrowTestError(__ERROR__) \
            FL_THROW_ERROR(__ERROR__, FLThrowTestException)

#define FL_TEST_THROWER(__CODE__, __REASON__, __COMMENT__) \
            FLThrowTestError([FLAssertionFailedError assertionFailedError:__CODE__ reason:__REASON__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

#define FLTestFailed() \
            FL_ASSERT_FAILED(FL_TEST_THROWER)

#define FLTestFailedWithComment(__FORMAT__, ...) \
            FL_ASSERT_FAILED__WITH_COMMENT(FL_TEST_THROWER, __FORMAT__, ##__VA_ARGS__)

#define FLEnsure(__CONDITION__) \
            FL_ASSERT(FL_TEST_THROWER, __CONDITION__)

#define FLEnsureWithComment(__CONDITION__, __FORMAT__, ...) \
            FL_ASSERT_WITH_COMMENT(FL_TEST_THROWER, __CONDITION__, __FORMAT__, ##__VA_ARGS__)

#define FLEnsureNil(__PTR__) \
            FL_ASSERT_IS_NIL(FL_TEST_THROWER, __PTR__)

#define FLEnsureNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NIL_WITH_COMMENT(FL_TEST_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLEnsureNotNil(__PTR__) \
            FL_ASSERT_IS_NOT_NIL(FL_TEST_THROWER, __PTR__)

#define FLEnsureNotNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(FL_TEST_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLEnsureStringIsNotEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_NOT_EMPTY(FL_TEST_THROWER, __STRING__)

#define FLEnsureStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_TEST_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLEnsureStringIsEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_EMPTY(FL_TEST_THROWER, __STRING__)

#define FLEnsureStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_TEST_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLEnsureStringsAreEqual(a,b) \
            FLEnsureWithComment(FLStringsAreEqual(a,b), @"\"%@\" != \"%@\"", a, b)

#define FLEnsureStringsNotEqual(a,b) \
            FLEnsure(!FLStringsAreEqual(a,b));

#define FLEnsureIsKindOfClass(__OBJ__, __CLASS__) \
            FLEnsure([__OBJ__ isKindOfClass:[__CLASS__ class]])

#define FLEnsureConformsToProcol(__OBJ__, __PROTOCOL__) \
            FLEnsure([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])

