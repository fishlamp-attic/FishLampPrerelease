//
//  FLOperationUnitTest.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationUnitTest.h"
#import "FLOperation.h"
#import "FLSynchronousOperation.h"
#import "FLDispatchQueue.h"

@implementation FLOperation (Tests)

//- (void) assertNotRun {
//    FLAssertIsFalseWithComment(self.wasCancelled, nil);
//    FLAssertIsFalseWithComment(self.wasStarted, nil);
//    FLAssertIsFalseWithComment(self.isFinished, nil);
//    FLAssertIsFalseWithComment(self.didSucceed, nil);
//    FLAssertIsNilWithComment(self.error, nil);
//}
//
//- (void) assertRanOk {
//    FLAssertIsFalseWithComment(self.wasCancelled, nil);
//    FLAssertIsTrueWithComment(self.wasStarted, nil);
//    FLAssertIsTrueWithComment(self.isFinished, nil);
//    FLAssertIsTrueWithComment(self.didSucceed, nil);
//    FLAssertIsNilWithComment(self.error, nil);
//}
//
//- (void) assertNotInQueue {
////    FLAssertIsNilWithComment(self.operationQueue, nil);
//}
//
//- (void) assertInQueue {
////    FLAssertIsNotNilWithComment(self.operationQueue, nil);
//}
//
//- (void) assertWasCancelled {
//    FLAssertIsKindOfClassWithComment(self.error, NSError, nil);
//    FLAssertIsTrueWithComment(self.wasCancelled, nil);
//}

@end

@interface FLSimpleTestOperation : FLSynchronousOperation {
@private
    BOOL _passed;
}
@property (readonly, assign, nonatomic) BOOL passed;
@end

@implementation FLSimpleTestOperation
@synthesize passed = _passed;

- (FLPromisedResult) performSynchronously {

    FLTestLog(@"hello world");
    _passed = YES;

    return FLSuccessfulResult;
}
@end
@implementation FLOperationUnitTest

+ (FLTestGroup*) testGroup {
    return [FLTestGroup frameworkTestGroup];
}

- (void) testSimpleCase {
    FLSimpleTestOperation* op = FLAutorelease([[FLSimpleTestOperation alloc] init]);
    FLThrowIfError([FLBackgroundQueue runSynchronously:op]);
    FLAssert(op.passed);
}

- (void) testInQueue {

//    FLSynchronousOperationQueueOperation* q = [FLSynchronousOperationQueueOperation operationQueue];
//    [q assertNotRun];
//    [q assertNotInQueue];
//
//    FLOperation* op = [FLOperation operation];
//    
//    
//    [op assertNotRun];
//    [op assertNotInQueue];
//
//    [q queueOperation:op];
//    [op assertNotRun];
//    [op assertInQueue];
//    
//    [q run];
//    
//    [op assertInQueue];
//    [op assertRanOk];
//    [q assertRanOk];
    
//    [op assertWasCancelled];
}
@end
