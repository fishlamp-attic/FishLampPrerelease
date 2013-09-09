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

#define FLTest(__CONDITION__) \
            FL_ASSERT(FL_TEST_THROWER, __CONDITION__)

#define FLTestWithComment(__CONDITION__, __FORMAT__, ...) \
            FL_ASSERT_WITH_COMMENT(FL_TEST_THROWER, __CONDITION__, __FORMAT__, ##__VA_ARGS__)

#define FLTestIsNil(__PTR__) \
            FL_ASSERT_IS_NIL(FL_TEST_THROWER, __PTR__)

#define FLTestIsNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NIL_WITH_COMMENT(FL_TEST_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLTestIsNotNil(__PTR__) \
            FL_ASSERT_IS_NOT_NIL(FL_TEST_THROWER, __PTR__)

#define FLTestIsNotNilWithComment(__PTR__, __FORMAT__, ...) \
            FL_ASSERT_IS_NOT_NIL_WITH_COMMENT(FL_TEST_THROWER, __PTR__, __FORMAT__, ##__VA_ARGS__)

#define FLTestStringIsNotEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_NOT_EMPTY(FL_TEST_THROWER, __STRING__)

#define FLTestStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_NOT_EMPTY_WITH_COMMENT(FL_TEST_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLTestStringIsEmpty(__STRING__) \
            FL_ASSERT_STRING_IS_EMPTY(FL_TEST_THROWER, __STRING__)

#define FLTestStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FL_ASSERT_STRING_IS_EMPTY_WITH_COMMENT(FL_TEST_THROWER, __STRING__, __FORMAT__, ##__VA_ARGS__)

#define FLTestStringsAreEqual(a,b) \
            FLTest(FLStringsAreEqual(a,b));

#define FLTestStringsNotEqual(a,b) \
            FLTest(!FLStringsAreEqual(a,b));

#define FLTestIsKindOfClass(__OBJ__, __CLASS__) \
            FLTest([__OBJ__ isKindOfClass:[__CLASS__ class]])

#define FLTestConformsToProcol(__OBJ__, __PROTOCOL__) \
            FLTest([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])

