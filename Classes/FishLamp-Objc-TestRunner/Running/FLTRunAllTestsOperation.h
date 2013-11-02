//
//  FLTRunAllTestsOperationBot.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSynchronousOperation.h"
#import "FLTTestResultCollection.h"
#import "FLSynchronousOperation.h"

@interface FLTRunAllTestsOperation : FLSynchronousOperation {
@private
}

+ (id) testRunner;

@end