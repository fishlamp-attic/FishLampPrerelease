//
//  FLTestRunnerBot.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestRunner.h"
#import "FLAsyncQueue.h"
#import "FLStaticTestMethodRunner.h"
#import "FLObjcRuntime.h"
#import "FLTestable.h"

#import "FLTestOperation.h"
#import "FLDispatchQueue.h"

#import "FLTestOrganizer.h"
#import "FLTestGroupOrganizer.h"

#import "FLTestFactory.h"


@implementation FLTestRunner

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
    
        [FLTestOutput appendLineWithFormat:@"UnitTest Group: %@ (priority: %d)",
         group.testGroup.groupName,
         group.testGroup.groupPriority];

        for(id<FLTestFactory> factory in group.testList) {

            @autoreleasepool {
                FLAssembledTest* test = [factory createAssembledTest];

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
// - (FLPromisedResult) performSynchronously {
//
//    NSMutableArray* array = [NSMutableArray array];
//    NSArray* allResults = [self findUnitTests];
//    
//    for(FLTestable* test in tests) {
//
//        FLTestOutput(@"%Running @ Test Cases:", test.unitTestName);
//
//        [[FLTestable logger] indent:^{
//            FLTestResultCollection* results = [self runChildSynchronously:test];
//            NSArray* failedResults = [results failedResults];
//            if(result && results.count) {
//                FLTestOutput(@"%@ test cases failed", failedResults.count);
//            }
//            else {
//                FLTestOutput(@"%@ test cases passed", results.count);
//            }
//            
//            [allResults addObject:results];
//        }];
//    }
//
//    return allResults;
//}   

//@implementation FLTestRunner 
//
//+ (id) testRunner {
//    return FLAutorelease([[[self class] alloc] init]);
//}
//
//
//- (NSArray*) runUnitTests:(NSArray*) factoryList {
//
//    NSMutableArray* resultsArray = [NSMutableArray array];
//
//    for(id<FLTestFactory> factory in factoryList) {
//        @autoreleasepool {
//            FLTestOperation* unitTestOperation = [FLTestOperation unitTestOperation:factory];
//            [resultsArray addObject:[FLBackgroundQueue runSynchronously:unitTestOperation]];
//        }
//    }
//
//    int errorCount = 0;
//    for(NSArray* resultArray in array) {
//        for(FLTestResultCollection* result in resultArray) {
//            errorCount += [[result failedResults] count];
//        }
//    }
//    
//    if(errorCount) {
//        [FLTestOutput appendLine:@"Unit Tests Failed"];
//    
////        return [NSError errorWithDomain:FLErrorDomain code:FLErrorResultFailed localizedDescription:@"Unit Tests Failed"];
//    }
//    else {
//        [FLTestOutput appendLine:@"Unit Tests Passed"];
//    }
//
//    return resultsArray;
//}
//
//@end
