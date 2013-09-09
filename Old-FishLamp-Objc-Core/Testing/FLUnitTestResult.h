//
//  FLUnitTestResult.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResultCollection.h"
@class FLUnitTest;

@interface FLUnitTestResult : FLTestResultCollection {
@private
    FLUnitTest* _unitTest;
}

@property (readonly, strong) FLUnitTest* unitTest;

@end