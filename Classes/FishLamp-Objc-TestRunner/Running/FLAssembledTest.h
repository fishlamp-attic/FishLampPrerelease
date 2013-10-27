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

@property (readonly, strong, nonatomic) NSString* testName;
//@property (readonly, assign, nonatomic) BOOL isDisabled;
//@property (readonly, strong, nonatomic) NSString* disabledReason;

@property (readonly, strong, nonatomic) id testableObject;
@property (readonly, strong, nonatomic) FLTestCaseList* testCaseList;

+ (id) assembledUnitTest:(id) testableObject testCases:(FLTestCaseList*) testCases;

- (void) willRunTestCases:(FLTestCaseList*) testCases;

- (void) didRunTestCases:(FLTestCaseList*) testCases;

@end
