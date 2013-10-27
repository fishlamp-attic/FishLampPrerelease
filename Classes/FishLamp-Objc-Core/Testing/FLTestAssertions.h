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

extern NSException* FLLogTestException(NSException* ex);

#define FLThrowTestException(__EX__) \
            @throw FLLogTestException(__EX__)

#define FLThrowTestError(__ERROR__) \
            FL_THROW_ERROR(__ERROR__, FLThrowTestException)

#define FL_TEST_THROWER(__CODE__, __CONDITION__, __COMMENT__) \
            FLPrintf(@"Test Failure: \"%@\" %@", __CONDITION__, __COMMENT__); \
            FLThrowTestError([NSError testFailedError:__CODE__ condition:__CONDITION__ comment:__COMMENT__ stackTrace:FLCreateStackTrace(YES)])

#define FLTestFailed() \
            FL_ASSERT_FAILED(FL_TEST_THROWER)

#define FLTestFailedWithComment(__FORMAT__, ...) \
            FL_ASSERT_FAILED__WITH_COMMENT(FL_TEST_THROWER, __FORMAT__, ##__VA_ARGS__)

#define FLTest(__CONDITION__) \
            do { \
                if(!(__CONDITION__)) { \
                    FL_TEST_THROWER(0,  FLStringWithFormatOrNil(@"%s", #__CONDITION__), nil); \
                } \
            } while(0)

#define FLTestWithComment(__CONDITION__, __FORMAT__, ...) \
            do { \
                if(!(__CONDITION__)) { \
                    FL_TEST_THROWER(0, FLStringWithFormatOrNil(@"%s", #__CONDITION__), FLStringWithFormatOrNil(__FORMAT__, ##__VA_ARGS__)); \
                } \
            } while(0)

#define FLTestNil(__PTR__) \
            FLTestWithComment((__PTR__) == nil, @"expecting nil value")

#define FLTestNilWithComment(__PTR__, __FORMAT__, ...) \
            FLTestWithComment((__PTR__) == nil, __FORMAT__, ##__VA_ARGS__)

#define FLTestNotNil(__PTR__) \
            FLTestWithComment((__PTR__) != nil, @"expecting non nil value")

#define FLTestNotNilWithComment(__PTR__, __FORMAT__, ...) \
            FLTestWithComment((__PTR__) != nil, __FORMAT__, ##__VA_ARGS__)

#define FLTestStringIsNotEmpty(__STRING__) \
            FLTestWithComment([__STRING__ length] != 0, @"expecting a string with non zero length")

#define FLTestStringIsNotEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FLTestWithComment([__STRING__ length] != 0, __FORMAT__, ##__VA_ARGS__)

#define FLTestStringIsEmpty(__STRING__) \
            FLTestWithComment([__STRING__ length] == 0, @"expecting zero length string")

#define FLTestStringIsEmptyWithComment(__STRING__, __FORMAT__, ...) \
            FLTestWithComment([__STRING__ length] == 0, __FORMAT__, ##__VA_ARGS__)

#define FLTestStringsAreEqual(a,b) \
            do { \
                NSString* __a = a; \
                NSString* __b = b; \
                FLTestWithComment(FLStringsAreEqual(__a, __b), @"\"%@\" != \"%@\"", __a, __b); \
            } while(0)

#define FLTestStringsNotEqual(a,b) \ \
            do { \
                NSString* __a = a; \
                NSString* __b = b; \
                FLTestWithComment(!FLStringsAreEqual(__a, __b), @"\"%@\" == \"%@\"", __a, __b); \
            } while(0)

#define FLTestIsKindOfClass(__OBJ__, __CLASS__) \
            FLTest([__OBJ__ isKindOfClass:[__CLASS__ class]])

#define FLTestConformsToProcol(__OBJ__, __PROTOCOL__) \
            FLTest([__OBJ__ conformsToProtocol:@protocol(__PROTOCOL__)])

