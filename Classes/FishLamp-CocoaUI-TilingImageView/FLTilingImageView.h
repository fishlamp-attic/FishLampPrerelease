//
//  FLTilingImageView.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/8/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

@interface FLTilingImageView : SDKView {
@private
    SDKImage* _image;
}
@property (readwrite, strong, nonatomic) SDKImage* image;

@end
