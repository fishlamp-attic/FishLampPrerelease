//
//  FLTestable+Utils.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLTestable.h"

@interface FLTestable (Utils)

- (NSString*) loadTestFile:(NSString*) testFileName
                fromBundle:(NSBundle*) bundle;

@end
