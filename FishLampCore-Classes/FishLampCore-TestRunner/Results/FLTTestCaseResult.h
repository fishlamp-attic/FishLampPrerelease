//
//  FLTestCaseResult.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTTestResult.h"

@protocol FLTestCase;

@interface FLTTestCaseResult : FLTTestResult {
@private
    id<FLTestCase> _testCase;
}
+ (id) testCaseResult:(id<FLTestCase>) forTest;

@property (readonly, strong, nonatomic) id<FLTestCase> testCase;

@end

