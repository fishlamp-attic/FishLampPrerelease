//
//  FLTestCaseRunner.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@class FLTestCaseResult;
@class FLTestCase;

@protocol FLTestCaseRunner <NSObject>
- (FLTestCaseResult*) performTestCase:(FLTestCase*) testCase;
@end

@interface FLTestCaseRunner : NSObject<FLTestCaseRunner>
+ (id) testCaseRunner;
@end
