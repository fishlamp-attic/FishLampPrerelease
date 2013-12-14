//
//  FLColumnArrangement.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangement.h"

// this lays out columns within the bounds - it adjusts
// the widths of each column to fit. You can specifiy a single
// column FLArrangeableGrowModeFlexibleWidth in a single column's 
// (view or widget or whatever) 
@interface FLSingleRowColumnArrangement : FLArrangement {}
@end