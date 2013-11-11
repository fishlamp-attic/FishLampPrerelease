//
//  FLTestCaseOperation.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseOperation.h"
#import "FLTestCaseList.h"
#import "FLTTestResult.h"

#import "FLStringUtils.h"
#import "FLTestable.h"
#import "FLSelectorPerforming.h"

#import "FLTimer.h"

@interface FLTestCaseOperation ()
@property (readwrite, strong) NSString* testCaseName;
@property (readwrite, strong) FLSelector* selector;
@property (readwrite, assign) id target;
@property (readwrite, strong) NSString* disabledReason;
@property (readwrite, strong) id<FLTestResult> result;
@property (readonly, strong) FLIndentIntegrity* indentIntegrity;
@end

@implementation FLTestCaseOperation

@synthesize isDisabled = _disabled;
@synthesize disabledReason = _disabledReason;
@synthesize selector = _selector;
@synthesize target = _target;
@synthesize testCaseName = _testCaseName;
@synthesize testable = _unitTest;
@synthesize result = _result;
@synthesize debugMode = _debugMode;
@synthesize indentIntegrity = _indentIntegrity;

- (id) init {	
	self = [super init];
	if(self) {
		_indentIntegrity = [[FLIndentIntegrity alloc] init];
	}
	return self;
}

- (id) initWithName:(NSString*) name testable:(id<FLTestable>) testable {
    self = [self init];
    if(self) {
        _testCaseName = FLRetain(name);
        _unitTest = testable;
    }

    return self;
}

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector {

    self = [self initWithName:name testable:testable];
    if(self) {
        _target = target;
        _selector = [[FLSelector alloc] initWithSelector:selector];
        _willTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"will%@", [_selector.selectorString stringWithUppercaseFirstLetter_fl]]];
        _didTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"did%@", [_selector.selectorString stringWithUppercaseFirstLetter_fl]]];
    }
    return self;
}

- (void) dealloc {
    [_timer stopTimer];

#if FL_MRC
    [_indentIntegrity release];
    [_disabledReason release];
    [_testCaseName release];
	[_selector release];
    [_willTestSelector release];
    [_didTestSelector release];
    [_result release];
    [super dealloc];
#endif
}

+ (id) testCase:(NSString*) name
       testable:(id<FLTestable>) testable
         target:(id) target
       selector:(SEL) selector {

    return FLAutorelease([[[self class] alloc] initWithName:name testable:testable target:target selector:selector]);
}

- (void) setDisabledWithReason:(NSString*) reason {
    _disabled = YES;
    self.disabledReason = reason;
}

- (void) performTestCaseSelector:(FLSelector*) selector optional:(id) optional{

    switch(selector.argumentCount) {
        case 0:
            [selector performWithTarget:_target];
        break;

        case 1:
            [selector performWithTarget:_target withObject:optional];
        break;

        default:
            [self setDisabledWithReason:[NSString stringWithFormat:@"[%@ %@] has too many paramaters (%ld).",
                NSStringFromClass([_target class]),
                selector.selectorString,
                selector.argumentCount]];
        break;
    }
}

- (void) prepareTestCase {
    self.result = [FLTTestResult testResult:self.testCaseName];
    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_target]) {
        [self performTestCaseSelector:_willTestSelector optional:self];
    }
}

- (void) timerDidTimeout:(FLTimer*) timer {
    FLLog(@"Test timed out: %@", [self testCaseName]);
}


- (BOOL) isAsyncTest {
    return _timer != nil;
}

- (void) startOperation {

    if(self.isDisabled) {
        [self setFinished];
    }

    [self.result setStarted];

    @try {
        switch(_selector.argumentCount) {
            case 0:
                [_selector performWithTarget:_target];
                if(!self.isAsyncTest) {
                    [self setFinished];
                }
            break;

            case 1:
                [_selector performWithTarget:_target withObject:self];
                if(!self.isAsyncTest) {
                    [self setFinished];
                }
            break;


            default:
                [self setDisabledWithReason:[NSString stringWithFormat:@"[%@ %@] has too many paramaters (%ld).",
                    NSStringFromClass([_target class]),
                    _selector.selectorString,
                    _selector.argumentCount]];
            break;
        }
    }
    @catch(NSException* ex) {
        if(!self.finisher.isFinished) {
            [self setFinishedWithResult:ex.error];
        }
    }
}

- (void) setFinishedWithResult:(id)result {

    if(_timer) {
        [_timer stopTimer];
    }

    [self.result setFinished];

    if([result isError]) {
        [self.result setFailedWithError:result];
    }
    else {
        [self.result setPassed];
    }

    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_didTestSelector]) {
        [self performTestCaseSelector:_didTestSelector optional:self];
    }

    [super setFinishedWithResult:self.result];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], self.testCaseName];
}

- (void) startAsyncTest {
    [self startAsyncTestWithTimeout:FLTestCaseDefaultAsyncTimeout];
}

- (void) setFailedWithError:(NSError*) error {
    [self setFinishedWithResult:error];
}

- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout {
    _timer = [[FLTimer alloc] initWithTimeout:timeout];
    _timer.delegate = self;
    [_timer startTimer];
}

- (void) executeTestBlock:(void (^)()) testBlock {
    @try {
        if(testBlock) {
            testBlock();
        }
    }
    @catch(NSException* ex) {
        [self setFinishedWithResult:ex.error];
    }
}

- (void) finishAsyncTestWithBlock:(void (^)()) finishBlock {
    @try {
        if(finishBlock) {
            finishBlock();
        }
        [self setFinished];
    }
    @catch(NSException* ex) {
        [self setFinishedWithResult:ex.error];
    }
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

+ (id<FLTestCase>) testCase:(NSString*) name testable:(id<FLTestable>) testable testBlock:(FLTestBlock) block {
    return FLAutorelease([[FLTestCase alloc] initWithName:name testable:testable testBlock:block]);
}

@property (readonly, copy, nonatomic) FLTestBlock testCaseBlock;
- (id) initWithName:(NSString*) name testable:(id<FLTestable>) testable testBlock:(FLTestBlock) block;
+ (id<FLTestCase>) testCase:(NSString*) name testable:(id<FLTestable>) testable testBlock:(FLTestBlock) block;

- (id) initWithName:(NSString*) name testable:(id<FLTestable>) testable testBlock:(FLTestBlock) block  {
    self = [self initWithName:name testable:testable];
    if(self) {
        _testCaseBlock = [block copy];
    }
    return self;
}

*/
