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
#import "FLTestGroupOrganizer.h"

#import "FLTestFactory.h"
#import "FLAssembledTest.h"

@implementation FLRunAllTestsOperation

+ (id) testRunner {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLPromisedResult) performSynchronously {

    FLTestOrganizer* organizer = [FLTestOrganizer unitTestOrganizer];
    [organizer findAndOrganizeUnitTests];

    NSArray* allClassesList = [organizer unitTestFactories];
    
    NSArray* sortedGroupList = [organizer sortedGroupList];

    [FLTestOutput appendLineWithFormat:@"Found %ld unit test classes in %ld groups",
        (unsigned long) allClassesList.count,
        (unsigned long) sortedGroupList.count];
    
    NSMutableArray* resultArray = [NSMutableArray array];

    for(FLTestGroupOrganizer* group in sortedGroupList) {
    
        [FLTestOutput appendLineWithFormat:@"UnitTest Group: %@ (priority: %ld)",
         group.testGroup.groupName,
         (long) group.testGroup.groupPriority];

        for(id<FLTestFactory> factory in group.testList) {

            @autoreleasepool {
                FLAssembledTest* test = [factory createAssembledTest];

                if(test.isDisabled) {
                    FLTestLog(@"Unit test disabled: %@, Reason: %@", test.testName, test.disabledReason);
                    continue;
                }

                [FLTestOutput indent:^{
                    FLTestOperation* unitTestOperation =
                        [FLTestOperation unitTestOperation:test];

                    FLTestResultCollection* result =
                        [FLTestResultCollection fromPromisedResult:
                            [FLBackgroundQueue runSynchronously:unitTestOperation]];

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

