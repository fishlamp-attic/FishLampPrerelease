//
//  FLUnitTestResult.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUnitTestResult.h"
#import "FLTestable.h"

@interface FLUnitTestResult ()
@property (readwrite, strong) id<FLTestable> unitTest;
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

- (id) initWithUnitTest:(id<FLTestable>) unitTest {
    self = [super init];
    if(self) {
        self.unitTest = unitTest;
    }
    return self;
}

+ (FLUnitTestResult*) unitTestResult:(id<FLTestable>) unitTest {
    return FLAutorelease([[[self class] alloc] initWithUnitTest:unitTest]);
}


@end
