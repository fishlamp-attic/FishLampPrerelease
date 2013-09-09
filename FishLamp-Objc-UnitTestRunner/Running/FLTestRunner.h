//
//  FLTestRunnerBot.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSynchronousOperation.h"
#import "FLTestResultCollection.h"
//
//@interface FLTestRunner : NSObject {
//}
//
//+ (id) testRunner;
//
//- (NSArray*) runUnitTests:(NSArray*) factoryList;
//
//// returns array of FLTestResultCollection
//@end


#import "FLSynchronousOperation.h"

@interface FLTestRunner : FLSynchronousOperation {
@private
}

+ (id) testRunner;

@end