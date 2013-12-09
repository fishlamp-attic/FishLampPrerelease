//
//  FLSingleRowColumnArrangement.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangement.h"

/*
	FLSingleRowColumnArrangement
	1. this stacks the view top to bottom (back to front in subviewList)
	2. makes each view as wide as parent view (minus innerInsets and margins)
	3. setViewSize sets height of view to bottom of last view + innerInsets + margins
*/ 
@interface FLSingleColumnRowArrangement : FLArrangement
@end
