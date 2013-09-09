//
//  FLUnitTestResult.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUnitTestResult.h"
#import "FLUnitTest.h"
#import "FLUnitTestResult_Internal.h"

@interface FLUnitTestResult ()
@property (readwrite, strong) FLUnitTest* unitTest;
@end

@implementation FLUnitTestResult

@synthesize unitTest = _unitTest;

#if FL_MRC
- (void) dealloc {
    [_unitTest release];
    [super dealloc];
}
#endif

- (NSString*) runSummary {
    return nil;
}

- (NSString*) failureDescription {

    return nil;
}

- (NSString*) testName {
    return NSStringFromClass([self.unitTest class]);
}

- (id) initWithUnitTest:(FLUnitTest*) unitTest {
    self = [super init];
    if(self) {
        self.unitTest = unitTest;
    }
    return self;
}

+ (FLUnitTestResult*) unitTestResult:(FLUnitTest*) unitTest {
    return FLAutorelease([[[self class] alloc] initWithUnitTest:unitTest]);
}


@end
