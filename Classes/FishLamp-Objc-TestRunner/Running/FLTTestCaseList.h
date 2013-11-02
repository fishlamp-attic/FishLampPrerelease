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

@protocol FLTTestCase;

@interface FLTTestCaseList : NSObject<FLTestCaseList, NSFastEnumeration> {
@private
    NSMutableArray* _testCases;
    BOOL _disabled;
    NSString* _disabledReason;
    NSMutableArray* _prerequisiteTestClasses;
}

+ (id) testCaseList;
+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCases;

- (void) addTestCase:(FLTTestCase*) testCase;


@end