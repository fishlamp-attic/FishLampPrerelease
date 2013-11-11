//
//  FLTestableOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLTTestResultCollection.h"
#import "FLOperation.h"

@class FLTestCaseList;
@class FLTTestResultCollection;
@class FLTestCaseOperation;

@interface FLTestableOperation : FLOperation {
@private
    id<FLTestable> _testableObject;
}

+ (id) testWithTestable:(id<FLTestable>) testableObject;
@end
