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
#import "FLTestCaseList.h"
#import "FLTestResult.h"
#import "FLTestLoggingManager.h"

@interface FLTestCase ()
@property (readwrite, strong) NSString* testCaseName;
@property (readwrite, strong) FLSelector* selector;
@property (readwrite, assign) id target;
@property (readwrite, strong) NSString* disabledReason;
@property (readwrite, assign) FLTestCaseList* testCaseList;
@property (readwrite, strong) FLTestCaseResult* result;
@end

@implementation FLTestCase
@synthesize isDisabled = _disabled;
@synthesize disabledReason = _disabledReason;
@synthesize selector = _selector;
@synthesize target = _target;
@synthesize testCaseName = _testCaseName;
@synthesize testable = _unitTest;
@synthesize testCaseList = _testCaseList;
@synthesize result = _result;

- (id) initWithName:(NSString*) name testable:(FLTestable*) testable {
    self = [super init];
    if(self) {
        _testCaseName = FLRetain(name);
        _unitTest = testable;
    }

    return self;
}

- (id) initWithName:(NSString*) name
           testable:(FLTestable*) testable
             target:(id) target
           selector:(SEL) selector {

    self = [self initWithName:name testable:testable];
    if(self) {
        _target = target;
        _selector = [[FLSelector alloc] initWithSelector:selector];
        _willTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"will%@", [_selector.name stringWithUppercaseFirstLetter_fl]]];
        _didTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"did%@", [_selector.name stringWithUppercaseFirstLetter_fl]]];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_disabledReason release];
    [_testCaseName release];
	[_selector release];
    [_willTestSelector release];
    [_didTestSelector release];
    [_result release];
    [super dealloc];
}
#endif

+ (FLTestCase*) testCase:(NSString*) name testable:(FLTestable*) testable target:(id) target selector:(SEL) selector {
    return FLAutorelease([[FLTestCase alloc] initWithName:name testable:testable target:target selector:selector]);
}


- (void) disable:(NSString*) reason {
    _disabled = YES;
    self.disabledReason = reason;
}

/*
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
*/

- (void) performTestCaseSelector:(FLSelector*) selector optional:(id) optional{

    switch(selector.argumentCount) {
        case 0:
            [selector performWithTarget:_target];
        break;

        case 1:
            [selector performWithTarget:_target withObject:optional];
        break;

        default:
            [self disable:[NSString stringWithFormat:@"[%@ %@] has too many paramaters (%ld).",
                NSStringFromClass([_target class]),
                selector.name,
                selector.argumentCount]];
        break;
    }
}

- (void) willPerformTest {
    self.result = [FLTestResult testResult:self.testCaseName];
    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_target]) {
        [[FLTestLoggingManager instance] logger:self.result.loggerOutput logInBlock:^{
            [self performTestCaseSelector:_willTestSelector optional:self];
        }];
    }
}

- (void) performTest {
    if(!self.isDisabled) {
        @try {
            [[FLTestLoggingManager instance] logger:self.result.loggerOutput logInBlock:^{
                [self performTestCaseSelector:_selector optional:self];
            }];

            [self.result setPassed];
        }
        @catch(NSException* exception) {
            [self.result setFailedWithException:exception];
        }
    }
}

- (void) didPerformTest {
    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_didTestSelector]) {
        [[FLTestLoggingManager instance] logger:self.result.loggerOutput logInBlock:^{
            [self performTestCaseSelector:_didTestSelector optional:self];
        }];
    }
}

- (NSUInteger) runOrder {
    return [_testCaseList runOrderForTestCase:self];
}

- (void) setRunOrder:(NSUInteger) runOrder {
    [_testCaseList setRunOrder:runOrder forTestCase:self];
}

- (void) runSooner {
    [_testCaseList setRunOrder:self.runOrder - 1 forTestCase:self];
}

- (void) runLater {
    [_testCaseList setRunOrder:self.runOrder + 1 forTestCase:self];
}

- (void) runFirst {
    [_testCaseList setRunOrder:0 forTestCase:self];
}

- (void) runLast {
    [_testCaseList setRunOrder:INT_MAX forTestCase:self];
}

- (void) runBefore:(FLTestCase*) anotherTestCase {
    NSUInteger idx = [anotherTestCase runOrder];
    [self setRunOrder:idx - 1];
}

- (void) runAfter:(FLTestCase*) anotherTestCase {
    NSUInteger idx = [anotherTestCase runOrder];
    [self setRunOrder:idx + 1];
}

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

/*

@property (readwrite, copy, nonatomic) FLTestBlock testCaseBlock;

+ (FLTestCase*) testCase:(NSString*) name testable:(FLTestable*) testable testBlock:(FLTestBlock) block {
    return FLAutorelease([[FLTestCase alloc] initWithName:name testable:testable testBlock:block]);
}

@property (readonly, copy, nonatomic) FLTestBlock testCaseBlock;
- (id) initWithName:(NSString*) name testable:(FLTestable*) testable testBlock:(FLTestBlock) block;
+ (FLTestCase*) testCase:(NSString*) name testable:(FLTestable*) testable testBlock:(FLTestBlock) block;

- (id) initWithName:(NSString*) name testable:(FLTestable*) testable testBlock:(FLTestBlock) block  {
    self = [self initWithName:name testable:testable];
    if(self) {
        _testCaseBlock = [block copy];
    }
    return self;
}

*/
