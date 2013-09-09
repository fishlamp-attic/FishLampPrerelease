//
//  FLTestResult.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResult.h"
#import "FLStringFormatter.h"
#import "FLPrettyString.h"
#import "FLAssertions.h"

@interface FLTestResult ()
@property (readwrite, strong, nonatomic) NSError* error;
@property (readwrite, strong, nonatomic) NSString* testName;
@end

@implementation FLTestResult 
@synthesize error = _error;
@synthesize testName = _testName;
@synthesize loggerOutput = _loggerOutput;

+ (id) testResult {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_loggerOutput release];
    [_testName release];
    [_error release];
    [super dealloc];
}
#endif


- (void) setPassed {
    FLAssert(!_passed);
    _passed = YES;
}

- (BOOL) passed {
    return !self.error && _passed;
}

- (id) init {
    self = [super init];
    if(self) {
        self.testName = NSStringFromClass([self class]);
        _loggerOutput = [[FLPrettyString alloc] init];
    }
    return self;
}


//- (NSString*) description {
//    return [NSString stringWithFormat:@"%@ { testName: %@, passed: %@, error: %@ }", [super description], self.testName, self.passed ? @"YES" : [NSString stringWithFormat:@"NO (%d of %d)", (int)_count, (int)_expectedCount], 
//            [_error description]];
//}


@end

@interface FLCountedTestResult ()
@property (readwrite, assign, nonatomic) NSUInteger expectedCount;
@property (readwrite, assign, nonatomic) NSUInteger count;
@end

@implementation FLCountedTestResult 
@synthesize count =_count;
@synthesize expectedCount = _expectedCount;

- (id) init {	
	self = [super init];
	if(self) {
		
	}
	return self;
}

- (id) initWithExpectedCount:(NSUInteger) count {
    self = [super init];
    if(self) {
        _expectedCount = count;
        self.testName = NSStringFromClass([self class]);
    }
    return self;
}

//- (NSString*) description {
//    return [NSString stringWithFormat:@"%@ { testName: %@, passed: %@, error: %@ }", [super description], self.testName, self.passed ? @"YES" : [NSString stringWithFormat:@"NO (%d of %d)", (int)_count, (int)_expectedCount], 
//            [_error description]];
//}


- (void) setPassed {
    ++_count;
}

- (BOOL) passed {
    return !self.error && _count == _expectedCount;
}

+ (id) countedTestResult:(NSUInteger) expectedCount {
    return FLAutorelease([[[self class] alloc] initWithExpectedCount:expectedCount]);
}

@end
