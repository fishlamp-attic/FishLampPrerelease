////
////  FLTestSubclassRunner.m
////  FishLamp
////
////  Created by Mike Fullerton on 10/24/12.
////  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
////  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
////
//
//#import "FLTestSubclassRunner.h"
//
//#import "FLTestable.h"
//#import "FLTestGroup.h"
//#import "FLTestOperation.h"
//#import "FLTestLoggingManager.h"
//
//@implementation FLTestRunner
//
//- (id) init {
//    self = [super init];
//    if(self) {
//        _classList = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//
//+ (id) unitTestSubclassRunner {
//    return FLAutorelease([[[self class] alloc] init]);
//}
//
//
//- (FLPromisedResult) performSynchronously {
//
//    NSArray* allClassesList = [self classListWithRemovingBaseClasses:_classList];
//    
//    NSDictionary* groups = [self sortClassesIntoGroups:allClassesList];
//
//    NSArray* groupList = [self sortedGroupListWithGroupDictionary:groups];
//
//    [FLTestOutput appendLineWithFormat:@"Found %d unit test classes in %d groups", allClassesList.count, groupList.count];
//    
//    NSMutableArray* resultArray = [NSMutableArray array];
//    
//    for(FLTestGroup* group in groupList) {
//    
//        [FLTestOutput appendLineWithFormat:@"UnitTest Group: %@ (priority: %d)", group.groupName, group.groupPriority];
//        
//        NSMutableArray* classList = [groups objectForKey:group];
//        [self sortClassList:classList];
//        
//        for(Class aClass in classList) {
//
//            NSInteger runCount = [aClass unitTestRunCount];
//
//            for(NSInteger i = 0; i < runCount; i++) {
//                FLTestable* test = FLAutorelease([[[aClass class] alloc] init]);
//
//                [FLTestOutput indent:^{
//                    id results = [self runChildSynchronously:[FLTestOperation unitTestOperation:test]];
//                    FLThrowIfError(results);
//                    
//                    [resultArray addObject:results];
//                }];
//            }
//                
////            if(results.testResults.count) {
////                NSArray* failedResults = [results failedResults];
////                if(failedResults && failedResults.count) {
////                    FLTestOutput(@"%@: %d test cases failed", test.unitTestName, failedResults.count);
////                }
////                else {
////                    FLTestOutput(@"%@: %d test cases passed", test.unitTestName, results.testResults.count);
////                }
////            }
//        }
//    }
//    
//    return resultArray;
//    
//// - (FLPromisedResult) performSynchronously {
////
////    NSMutableArray* array = [NSMutableArray array];
////    NSArray* allResults = [self findUnitTests];
////    
////    for(FLTestable* test in tests) {
////
////        FLTestOutput(@"%Running @ Test Cases:", test.unitTestName);
////
////        [[FLTestable logger] indent:^{
////            FLTestResultCollection* results = [self runChildSynchronously:test];
////            NSArray* failedResults = [results failedResults];
////            if(result && results.count) {
////                FLTestOutput(@"%@ test cases failed", failedResults.count);
////            }
////            else {
////                FLTestOutput(@"%@ test cases passed", results.count);
////            }
////            
////            [allResults addObject:results];
////        }];
////    }
////
////    return allResults;
////}   
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_classList release];
//    [super dealloc];
//}
//#endif
//
//
//@end
