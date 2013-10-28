//
//  FLTestAssertions.h
//  FishLampCore
//
//  Created by Mike Fullerton on 9/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"
#import "FLTestLoggingManager.h"
#import "FLPrintf.h"
#import "FLExceptions.h"
#import "NSError+FLTestable.h"

#import "FLAssertUndef.h"

extern NSException* FLLogTestException(NSException* ex);

#define FLThrowTestException(__EX__) \
            @throw FLLogTestException(__EX__)

#define FLThrowTestError(__ERROR__) \
            FL_THROW_ERROR(__ERROR__, FLThrowTestException)

#define FL_TEST_THROWER(__CODE__, __CONDITION__, __COMMENT__) \
            FLPrintf(@"Test Failure: \"%@\" %@", __CONDITION__, __COMMENT__); \
            FLThrowTestError([NSError testFailedError:__CODE__ condition:__CONDITION__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

#define FLTAssertFailed() \
            FL_ASSERT_FAILED(FL_TEST_THROWER)

#define FLTAssertFailedWithComment(__FORMAT__, ...) \
            FL_ASSERT_FAILED__WITH_COMMENT(FL_TEST_THROWER, __FORMAT__, ##__VA_ARGS__)

#define FLTAssert(__CONDITION__) \
            do { \
                if(!(__CONDITION__)) { \
                    FL_TEST_THROWER(0,  FLStringWithFormatOrNil(@"%s", #__CONDITION__), nil); \
                } \
            } while(0)

#define FLTAssertWithComment(__CONDITION__, __FORMAT__, ...) \
            do { \
                if(!(__CONDITION__)) { \
                    FL_TEST_THROWER(0, FLStringWithFormatOrNil(@"%s", #__CONDITION__), FLStringWithFormatOrNil(__FORMAT__, ##__VA_ARGS__)); \
                } \
            } while(0)

#define FLTAssertNil(__PTR__) \
            FLTAssertWithComment((__PTR__) == nil, @"expecting nil value")

#define FLTAssertNilWithComment(__PTR__, __FORMAT__, ...) \
            FLTAssertWithComment((__PTR__) == nil, __FORMAT__, ##__VA_ARGS__)

#define FLTAssertNotNil(__PTR__) \
            FLTAssertWithComment((__PTR__) != nil, @"expecting non nil value")

#define FLTAssertNotNilWithComment(__PTR__, __FORMAT__, ...) \
            FLTAssertWithComment((__PTR__) != nil, __FORMAT__, ##__VA_ARGS__)

#define FLTAssertStringIsNotEmpty(__STRING__) \
            FLTAssertWithComment([__STRING__ length] != 0, @"expecting a string with non zero length")

#define FLTAssertStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FLTAssertWithComment([__STRING__ length] != 0, __FORMAT__, ##__VA_ARGS__)

#define FLTAssertStringIsEmpty(__STRING__) \
            FLTAssertWithComment([__STRING__ length] == 0, @"expecting zero length string")

#define FLTAssertStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FLTAssertWithComment([__STRING__ length] == 0, __FORMAT__, ##__VA_ARGS__)

#define FLTAssertStringsAreEqual(a,b) \
            do { \
                NSString* __a = a; \
                NSString* __b = b; \
                FLTAssertWithComment(FLStringsAreEqual(__a, __b), @"\"%@\" != \"%@\"", __a, __b); \
            } while(0)

#define FLTAssertStringsNotEqual(a,b) \ \
            do { \
                NSString* __a = a; \
                NSString* __b = b; \
                FLTAssertWithComment(!FLStringsAreEqual(__a, __b), @"\"%@\" == \"%@\"", __a, __b); \
            } while(0)

#define FLTAssertIsKindOfClass(__OBJ__, __CLASS__) \
            FLTAssert([__OBJ__ isKindOfClass:[__CLASS__ class]])

#define FLTAssertConformsToProtocol(__OBJ__, __PROTOCOL__) \
            FLTAssert([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])

#define FLTAssertNotError(__OBJ__) \
            FLThrowIfError(__OBJ__)

#ifndef FLAssertFailed
#define FLAssertFailed FLTAssertFailed
#define FLAssertFailedWithComment FLTAssertFailedWithComment
#define FLAssert FLTAssert
#define FLAssertWithComment FLTAssertWithComment
#define FLAssertNil FLTAssertNil
#define FLAssertNilWithComment FLTAssertNilWithComment
#define FLAssertNotNil FLTAssertNotNil
#define FLAssertNotNilWithComment FLTAssertNotNilWithComment
#define FLAssertStringIsNotEmpty FLTAssertStringIsNotEmpty
#define FLAssertStringIsNotEmptyWithComment FLTAssertStringIsNotEmptyWithComment
#define FLAssertStringIsEmpty FLTAssertStringIsEmpty
#define FLAssertStringIsEmptyWithComment FLTAssertStringIsEmptyWithComment
#define FLAssertStringsAreEqual FLTAssertStringsAreEqual
#define FLAssertStringsNotEqual FLTAssertStringsNotEqual
#define FLAssertIsKindOfClass FLTAssertIsKindOfClass
#define FLAssertConformsToProtocol  FLTAssertConformsToProtocol
#define FLAssertNotError FLTAssertNotError
#endif