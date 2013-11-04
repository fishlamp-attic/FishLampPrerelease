//
//  FLTTestCaseList.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTTestCase.h"
#import "FLTestCaseList.h"
#import "FLTOrderedRunList.h"

@protocol FLTTestCase;

@interface FLTTestCaseList : NSObject<FLTestCaseList, NSFastEnumeration> {
@private
    NSMutableArray* _testCaseArray;
    BOOL _disabled;
    NSString* _disabledReason;
}

@property (readonly, strong, nonatomic) NSArray* testCaseArray;

+ (id) testCaseList;
+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCaseArray;

- (void) addTestCase:(FLTTestCase*) testCase;


@end