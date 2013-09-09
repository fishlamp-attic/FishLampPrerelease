//
//  FLTestCaseOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampAsync.h"
#import "FLSynchronousOperation.h"

@class FLTestCase;

@interface FLTestCaseOperation : FLSynchronousOperation {
@private
    FLTestCase* _testCase;
}

@property (readonly, strong, nonatomic) FLTestCase* testCase;

- (id) initWithTestCase:(FLTestCase*) testCase;
+ (id) testCaseOperation:(FLTestCase*) testCase;

@end
