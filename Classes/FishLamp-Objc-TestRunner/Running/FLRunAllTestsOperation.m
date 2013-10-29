//
//  FLRunAllTestsOperationBot.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRunAllTestsOperation.h"
#import "FLAsyncQueue.h"
#import "FLStaticTestMethodRunner.h"
#import "FLObjcRuntime.h"
#import "FLTestable.h"

#import "FLTestOperation.h"
#import "FLDispatchQueue.h"

#import "FLTestOrganizer.h"
#import "FLSortedTestGroup.h"

#import "FLTestFactory.h"
#import "FLAssembledTest.h"

@implementation FLRunAllTestsOperation

+ (id) testRunner {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLPromisedResult) performSynchronously {

    FLTestOrganizer* organizer = [FLTestOrganizer testOrganizer];
    [organizer organizeTests];

    FLSortedTestGroupList* sortedGroupList = [organizer sortedGroupList];

    [FLTestOutput appendLineWithFormat:@"Found %ld unit test classes in %ld groups",
        (unsigned long) sortedGroupList.testCount,
        (unsigned long) sortedGroupList.groupCount];
    
    NSMutableArray* resultArray = [NSMutableArray array];

    for(FLSortedTestGroup* group in sortedGroupList) {
    
        [FLTestOutput appendLineWithFormat:@"UnitTest Group: %@ (priority: %ld)",
                                                group.testGroup.groupName,
                                                (long) group.testGroup.groupPriority];

        for(id<FLTestFactory> factory in group) {

            @autoreleasepool {
                FLAssembledTest* test = [factory createAssembledTest];

                [FLTestOutput indent:^{
                    FLTestOperation* unitTestOperation =
                        [FLTestOperation unitTestOperation:test];

                    FLPromisedResult result = [FLBackgroundQueue runSynchronously:unitTestOperation];

//                    FLTestResultCollection* result =
//                        [FLTestResultCollection fromPromisedResult:
//                            ];

                    [resultArray addObject:result];
                }];
            }
        }
    }

//    if(results.testResults.count) {
//        NSArray* failedResults = [results failedResults];
//        if(failedResults && failedResults.count) {
//            FLTestOutput(@"%@: %d test cases failed", test.unitTestName, failedResults.count);
//        }
//        else {
//            FLTestOutput(@"%@: %d test cases passed", test.unitTestName, results.testResults.count);
//        }
//    }

    return resultArray;
}

@end

