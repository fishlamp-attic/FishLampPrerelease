//
//  FLRightJustifiedColumnArrangement.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangement.h"

// uses the existing sizes of the views and aligns them in the
// bounds on the right. Widths of columns are not adjusted.
// returns height of enclosing bounds adjusted for columns, width
// is not adjusted (since you're aligning right)
@interface FLRightJustifiedColumnArrangement : FLArrangement 
@end