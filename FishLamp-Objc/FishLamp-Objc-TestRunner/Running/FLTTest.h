//
//  FLTTest.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLTTestResultCollection.h"
#import "FLOperation.h"

@class FLTTestCaseList;
@class FLTTestResultCollection;

@interface FLTTest : FLOperation {
@private
    id _testableObject;
    FLTTestCaseList* _testCaseList;
}

@property (readonly, strong, nonatomic) NSString* testName;
//@property (readonly, assign, nonatomic) BOOL isDisabled;
//@property (readonly, strong, nonatomic) NSString* disabledReason;

@property (readonly, strong, nonatomic) id testableObject;
@property (readonly, strong, nonatomic) FLTTestCaseList* testCaseList;

+ (id) testWithTestable:(id<FLTestable>) testableObject testCases:(id<FLTestCaseList>) testCases;

- (void) willRunTestCases:(FLTTestCaseList*) testCases;

- (void) didRunTestCases:(FLTTestCaseList*) testCases;

@end
