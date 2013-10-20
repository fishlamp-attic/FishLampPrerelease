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
#import "FLTestResult.h"
#import "FLTestResultCollection.h"

@class FLAssembledTest;

@interface FLTestOperation : FLSynchronousOperation {
@private
    FLAssembledTest* _unitTest;
}

+ (id) unitTestOperation:(FLAssembledTest*) unitTest;

@end


