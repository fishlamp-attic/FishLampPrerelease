//
//  FLHorizontalCellLayout.h
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 1/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangement.h"

// TODO(MF): should behave like FLVerticalGridArrangement with a decider.

@interface FLHorizontalGridArrangement : FLArrangement

+ (FLHorizontalGridArrangement*) horizontalCellLayout;

@end
