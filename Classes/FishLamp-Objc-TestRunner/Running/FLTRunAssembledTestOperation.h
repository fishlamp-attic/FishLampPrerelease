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

@class FLTAssembledTest;

@interface FLTRunAssembledTestOperation : FLSynchronousOperation {
@private
    FLTAssembledTest* _unitTest;
}

+ (id) unitTestOperation:(FLTAssembledTest*) testable;

@end


