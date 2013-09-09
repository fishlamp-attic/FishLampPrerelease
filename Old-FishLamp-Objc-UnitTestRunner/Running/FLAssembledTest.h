//
//  FLAssembledTest.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLTestResultCollection.h"

@class FLTestCaseList;
@class FLTestResultCollection;

@interface FLAssembledTest : NSObject {
@private
    id _testableObject;
    FLTestCaseList* _testCaseList;
}

@property (readonly, strong, nonatomic) id testableObject;
@property (readonly, strong, nonatomic) FLTestCaseList* testCaseList;

+ (id) assembledUnitTest:(id) testableObject testCases:(FLTestCaseList*) testCases;

- (void) willRunTestCases:(FLTestCaseList*) testCases
       withExpectedResult:(FLExpectedTestResult*) expected;

- (void) didRunTestCases:(FLTestCaseList*) testCases
      withExpectedResult:(FLExpectedTestResult*) expected
        withActualResult:(FLTestResultCollection*) actual;

@end
