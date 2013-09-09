//
//  FLAssertionsUnitTest.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAssertionTests.h"

#undef NOT_IMPLEMENTED_WARNINGS
#define NOT_IMPLEMENTED_WARNINGS 0

@implementation FLAssertionTests

+ (FLTestGroup*) testGroup {
    return [FLTestGroup frameworkTestGroup];
}

//- (void) testNotImplemented_broken_debug_verbose:(FLTestCase*) test {
//    [FLTestCase runTestWithExpectedFailure:^{  FLAssertIsImplementedWithComment(@"this is a test"); }];
//    [FLTestCase runTestWithExpectedFailure:^{  FLAssertIsImplementedWithComment(nil); } ];
//    [FLTestCase runTestWithExpectedFailure:^{  FLAssertIsBugWithComment(@"this is a bug", nil); } ];
//}


@end
