//
//  NSObject+FLArrangeable.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

#import "FLArrangeable.h"

@interface NSObject (FLArrangeable)

// We don't want all objects to have this api tacked onto them.
// So we should only use this for categories on existing objects like NSView/SDKView that
// we want to arrange but can't add the member data directly (e.g. our own subclass).
//
// The declared methods are in this .m file so you can safely expect them to be
// here.

/*
    @property (readwrite, assign, nonatomic) UIEdgeInsets innerInsets;
    @property (readwrite, assign, nonatomic) FLArrangeableGrowMode arrangeableGrowMode;
    @property (readwrite, assign, nonatomic) FLArrangeableWeight arrangeableWeight;
    @property (readwrite, assign, nonatomic) FLArrangeableState arrangeableState
*/

+ (id) lastSubframeByWeight:(FLArrangeableWeight) weight
                  subframes:(NSArray*) subframes;

@end


#define FLDeclareArrangebleObjectProperties() \
    @property (readwrite, assign, nonatomic) UIEdgeInsets innerInsets; \
    @property (readwrite, assign, nonatomic) FLArrangeableGrowMode arrangeableGrowMode; \
    @property (readwrite, assign, nonatomic) FLArrangeableWeight arrangeableWeight; \
    @property (readwrite, assign, nonatomic) FLArrangeableState arrangeableState

// paste these into your .m file
/*
    @dynamic innerInsets;
    @dynamic arrangeableGrowMode;
    @dynamic arrangeableWeight;
    @dynamic arrangeableState;
*/

#define FLSynthesizeArrangeableObjectProperties() \
    @dynamic innerInsets; \
    @dynamic arrangeableGrowMode; \
    @dynamic arrangeableWeight; \
    @dynamic arrangeableState
