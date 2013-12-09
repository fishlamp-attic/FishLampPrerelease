//
//  FLFillInBoundsArrangement.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLArrangement.h"

/*
	FLFillInBoundsArrangement (this is really best with one subview)
	1. this fills all subviews to fit in super view
	2. setViewSize does nothing.
*/ 
@interface FLFillInBoundsArrangement : FLArrangement
@end