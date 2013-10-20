//
//  SDKViewController+FLPresentationBehavior.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 7/17/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLPresentationBehavior.h"

@interface SDKViewController (FLPresentationBehavior) 

@property (readwrite, retain, nonatomic) id<FLPresentationBehavior> presentationBehavior;

+ (id<FLPresentationBehavior>) defaultPresentationBehavior;

@end