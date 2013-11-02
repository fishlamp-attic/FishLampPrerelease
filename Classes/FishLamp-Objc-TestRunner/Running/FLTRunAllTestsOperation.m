//
//  FLTRunAllTestsOperationBot.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTRunAllTestsOperation.h"
#import "FLAsyncQueue.h"
#import "FLTStaticTestMethodRunner.h"
#import "FLObjcRuntime.h"
#import "FLTestable.h"

#import "FLTRunAssembledTestOperation.h"
#import "FLDispatchQueue.h"

#import "FLTTestOrganizer.h"
#import "FLTTestFactoryList.h"

#import "FLTTestFactory.h"
#import "FLTAssembledTest.h"

@implementation FLTRunAllTestsOperation

+ (id) testRunner {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLPromisedResult) performSynchronously {

    FLTTestOrganizer* organizer = [FLTTestOrganizer testOrganizer];
    [organizer organizeTests];

    FLTSortedTestGroupList* sortedGroupList = [organizer sortedGroupList];

    FLTestLog(@"Found %ld unit test classes in %ld groups",
        (unsigned long) sortedGroupList.testCount,
        (unsigned long) sortedGroupList.count);
    
    NSMutableArray* resultArray = [NSMutableArray array];

    for(FLTTestFactoryList* group in sortedGroupList) {
    
        FLTestLog(@"Testable Group: %@", group.groupName);

        for(id<FLTTestFactory> factory in group) {

            @autoreleasepool {
                FLTAssembledTest* test = [factory createAssembledTest];

                [FLTestLogger() indent:^{
                    FLTRunAssembledTestOperation* unitTestOperation =
                        [FLTRunAssembledTestOperation unitTestOperation:test];

                    FLPromisedResult result = [FLBackgroundQueue runSynchronously:unitTestOperation];

//                    FLTTestResultCollection* result =
//                        [FLTTestResultCollection fromPromisedResult:
//                            ];

                    [resultArray addObject:result];
                }];
            }
        }
    }

//    if(results.testResults.count) {
//        NSArray* failedResults = [results failedResults];
//        if(failedResults && failedResults.count) {
//            FLTestOutput(@"%@: %d test cases failed", test.testName, failedResults.count);
//        }
//        else {
//            FLTestOutput(@"%@: %d test cases passed", test.testName, results.testResults.count);
//        }
//    }

    return resultArray;
}

@end

