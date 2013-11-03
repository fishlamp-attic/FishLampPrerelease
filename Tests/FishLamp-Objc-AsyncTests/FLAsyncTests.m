//
//  FLAsyncTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAsyncTests.h"
#import "FLPerformSelectorOperation.h"

#import "FLTestable.h"
#import "FLTimeoutTests.h"

#import "FLAsyncTestGroup.h"

@implementation FLAsyncTests

+ (Class) testGroupClass {
    return [FLAsyncTestGroup class];
}

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {
    [runOrder orderClass:[self class] afterClass:[FLTimeoutTests class]];
}

- (void) _didExecuteOperation:(FLPerformSelectorOperation*) operation {
	FLTestLog(@"did execute");
}

- (void) _asyncDone:(FLPerformSelectorOperation*) operation
{
//	[operation finishAsync];
	
//	FLAssertWithComment(operation.isFinished, @"not performed");
//	  FLAssertWithComment(operation.wasStarted, @"not started");
//
//	[[FLTestCase currentTestCase] didCompleteAsyncTest];
}

- (void) testAsyncOperation {
    
//    FLAsyncRunner* async = [FLAsyncRunner asyncRunner];
//    
//    [async start:^{
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                [async setFinished];
//                });
//        }];
//    
//    [async waitForFinish];
//    
//    FLAssert(async.isFinished);
    
//	FLPerformSelectorOperation* operation = [FLPerformSelectorOperation performSelectorOperation:self action:@selector(_didExecuteOperation:)];
//
//	  [operation startAsync:FLCallbackMake(operation, @selector(_asyncDone:))];
//	  
//	  [testCase blockUntilTestCompletes];
}

@end

