//
//  FLSanityCheckRunner.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTTestFinder.h"
#import "FLSynchronousOperation.h"

#define FLSanityCheckStaticTestMethodPrefix @"sanityCheck_"

@interface FLTSanityCheckTestFindler : NSObject<FLTTestMethodFinder>
+ (id) sanityCheckTestFinder;
@end

