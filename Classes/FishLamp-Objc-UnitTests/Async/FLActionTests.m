//
//  FLActionTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if REFACTOR

#import "FLActionTests.h"
#import "FLAction.h"
#import "FLDispatchQueue.h"

@implementation FLActionTests

+ (FLTestGroup*) testGroup {
    return [FLTestGroup frameworkTestGroup];
}

- (void) firstTest {
//   [self.results setTestResult:[FLCountedTestResult countedTestResult:6] forKey:@"counter"];
}

- (void) runOneAction {
//    FLAction* action = [FLAction action];
//
//    [action.operations addOperationWithBlock:^(FLOperation* block) {
//        FLAssert(![NSThread isMainThread]);
//        [[self.results testResultForKey:@"counter"] setPassed];
//    }];
//    
//    action.starting = ^(FLAction* theAction){ 
//        FLAssert([NSThread isMainThread]); 
//        [[self.results testResultForKey:@"counter"] setPassed];
//        
//    };
//    
//    action.finished = ^(FLAction* theAction) {
//        FLAssert([NSThread isMainThread]); 
//        [[self.results testResultForKey:@"counter"] setPassed];
//    };
//    
//    FLFinisher* finisher = [action startAction]; 
//    [finisher waitUntilFinished];
//    FLThrowError(finisher.result);
}

- (void) testBasicScheduling {
    [self runOneAction];
}

- (void) testBackgroundThreadStart {
    FLDispatchSync([FLDispatchQueue defaultQueue], ^{ [self runOneAction]; });
}

@end
#endif
