//
//  FLTestCaseResult.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTTestCaseResult.h"
#import "FLPrettyString.h"
#import "FLTestCase.h"

@interface FLTTestCaseResult ()
@end

@implementation FLTTestCaseResult

@synthesize testCase = _testCase;

- (id) initWithTestCase:(id<FLTestCase>) testCase {
    self = [super init];
    if(self) {
        _testCase = testCase;
    }

    return self;
}

+ (id) testCaseResult:(id<FLTestCase>) test {
    return FLAutorelease([[[self class] alloc] initWithTestCase:test]);
}

#if FL_MRC
- (void) dealloc {
    [_testCase release];
    [super dealloc];
}
#endif

- (NSString*) testName {
    return self.testCase.testCaseName;
}

@end