//  FLTestCase.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestCase.h"
#import "FLStringUtils.h"
#import "FLTestable.h"
#import "FLSelectorPerforming.h"

//#define FLTestCaseFlagBrokenString              @"_broken"
//#define FLTestCaseFlagVerboseString             @"_debug"
//#define FLTestCaseFlagExpectingExceptionString  @"_exception"

@interface FLTestCase ()
@property (readwrite, strong, nonatomic) NSString* testCaseName;
@property (readwrite, assign, nonatomic) SEL testCaseSelector;
@property (readwrite, copy, nonatomic) FLTestBlock testCaseBlock;
@property (readwrite, assign, nonatomic) id testCaseTarget;
@property (readwrite, strong, nonatomic) NSString* disabledReason;
@end

typedef enum {
    FLTestCaseFlagNone                  = 0,
    FLTestCaseFlagDisabled              = (1 << 1),
//    FLTestCaseFlagBroken                = (1 << 2),
//    FLTestCaseFlagDebug                 = (1 << 3),
//    FLTestCaseFlagExpectingException    = (1 << 4),
} FLTestCaseFlag;

typedef struct {
    __unsafe_unretained NSString* name;
    long flag;
} FLTestCaseFlagPair;

FLTestCaseFlagPair s_flagPairs[] = {
    { FLTestCaseFlagOffString,  FLTestCaseFlagDisabled},
//    { FLTestCaseOrderFirstString, FLTestCaseOrderFirst},
//    { FLTestCaseOrderLastString,  FLTestCaseOrderLast},
//    { FLTestCaseFlagBroken, FLTestCaseFlagBrokenString },
//    { FLTestCaseFlagDebug, FLTestCaseFlagVerboseString },
//    { FLTestCaseFlagExpectingException, FLTestCaseFlagExpectingExceptionString }
};

@implementation FLTestCase
@synthesize disabled = _disabled;
@synthesize disabledReason = _disabledReason;
@synthesize testCaseBlock = _testCaseBlock;
@synthesize testCaseSelector = _testCaseSelector;
@synthesize testCaseTarget = _testCaseTarget;
@synthesize testCaseName = _testCaseName;
@synthesize runOrder =_runOrder;
@synthesize unitTest = _unitTest;

- (void) setDisabledWithReason:(NSString*) reason {
    self.disabled = YES;
    self.disabledReason = reason;
}

- (void) setNameAndFlagsWithFormattedName:(NSString*) string {
    
    // quickly look to see if there's a _ in the method name, search backward
    
    BOOL lookForFlags = NO;
    for(int i = string.length - 1; i >= 0; i--) {
        if([string characterAtIndex:i] == '[') {
            lookForFlags = YES;
            break;
        }
    }

    NSString* theString = string;
    if(lookForFlags) {
        NSMutableString* newString = FLAutorelease([string mutableCopy]);

        for(int i = 0; i < (sizeof(s_flagPairs) / sizeof(FLTestCaseFlagPair)); i++) {
            
            // set the flag and remove the setting from the test case name
            NSRange range = [newString rangeOfString:s_flagPairs[i].name];
            if(range.length) {
                BOOL deleteChars = YES;
                switch(s_flagPairs[i].flag) {

                    default:
                    case FLTestCaseFlagNone:
                        deleteChars = NO;
                        break;
                
                    case FLTestCaseFlagDisabled:
                        [self setDisabledWithReason: @"\"[off]\" found in test case name"];
                        break;
                }

                if(deleteChars) {
                    [newString deleteCharactersInRange:range];
                }
            }
        }
        
        theString = newString;
    }

    self.testCaseName = theString;
}

- (id) initWithName:(NSString*) name unitTest:(FLTestable*) unitTest {
    self = [super init];
    if(self) {
        [self setNameAndFlagsWithFormattedName:name];
        _unitTest = unitTest;
        _runOrder = FLTestCaseOrderDefault;
    }

    return self;
}


- (id) initWithName:(NSString*) name unitTest:(FLTestable*) unitTest testBlock:(FLTestBlock) block  {
    self = [self initWithName:name unitTest:unitTest];
    if(self) {
        _testCaseBlock = [block copy];
    }
    return self;
}


- (id) initWithName:(NSString*) name unitTest:(FLTestable*) unitTest target:(id) target selector:(SEL) selector {
    self = [self initWithName:name unitTest:unitTest];
    if(self) {
        _testCaseTarget = target;
        _testCaseSelector = selector;
    }
    return self;
}

+ (FLTestCase*) testCase:(NSString*) name unitTest:(FLTestable*) unitTest target:(id) target selector:(SEL) selector {
    return FLAutorelease([[FLTestCase alloc] initWithName:name unitTest:unitTest target:target selector:selector]);
}

+ (FLTestCase*) testCase:(NSString*) name unitTest:(FLTestable*) unitTest testBlock:(FLTestBlock) block {
    return FLAutorelease([[FLTestCase alloc] initWithName:name unitTest:unitTest testBlock:block]);
}

- (void) performTest {
    if(!self.isDisabled) {
        if(_testCaseTarget && _testCaseSelector) {
            FLPerformSelector0(_testCaseTarget, _testCaseSelector);
        }
        if(_testCaseBlock) {
            _testCaseBlock();
        }
    }
}

//- (id<FLTestCaseRunner>) testCaseRunner {
//    return [FLTestCaseRunner testCaseRunner];
//}

#if FL_MRC
- (void) dealloc {
    [_disabledReason release];
    [_testCaseName release];
    [_testCaseBlock release];
    [super dealloc];
}
#endif

#if DEPRECATED
+ (void) runTestWithExpectedFailure:(void (^)()) test
                       checkResults:(void (^)(NSException* ex, BOOL* pass)) checkResults {
 
    BOOL passed = YES;
    @try {
        test();
        passed = NO;
    }
    @catch(NSException* ex) {
        if(checkResults) {
            checkResults(ex, &passed);
        }
    }
    
    FLAssertIsTrueWithComment(passed, @"Didn't catch expected exception");
}


+ (void) runTestWithExpectedFailure:(void (^)()) test {
    [self runTestWithExpectedFailure:test checkResults:nil];
}

+ (void) runTestWithExpectedFailure:(FLAssertionFailure) failureType
                       infoString:(NSString*) infoStringContainsThisOrNil
                               test:(void (^)()) callback {

//    FLAssertionFailure failed = FLAssertionFailureNone;

//    BOOL gotReasonString = infoStringContainsThisOrNil == nil;
    
    @try {
        callback();
    }
    @catch(NSException* ex) {
        
//        if(ex.error.failed) {
//            failed = ex.error.code;
//        }
        
//        gotReasonString = [failure.info loca]
    }
    
//    FLAssertAreEqualWithComment(failed, failureType, nil);
}
#endif

@end



