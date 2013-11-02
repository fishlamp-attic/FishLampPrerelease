//
//  FLTestCaseResult.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResult.h"

@protocol FLTestCase;

@protocol FLTestCaseResult <FLTestResult>
@property (readonly, strong, nonatomic) id<FLTestCase> testCase;
@end

