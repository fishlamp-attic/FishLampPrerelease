//
//	FLTestable.h
//	WreckingBall
//
//	Created by Mike Fullerton on 9/12/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FishLampAsync.h"
#import "FLTTestResult.h"
#import "FLTTestResultCollection.h"

@class FLTTest;

@interface FLTRunTestOperation : FLOperation {
@private
    FLTTest* _unitTest;
    NSMutableArray* _queue;
}

+ (id) runTestOperation:(FLTTest*) testable;

@end


