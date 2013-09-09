//
//  FLCompatibility.h
//  FLCompatibility
//
//  Created by Mike Fullerton on 1/6/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#if OSX

#define SDKColor             NSColor
#define SDKControl           NSControl
#define SDKEvent             NSEvent
#define SDKFont              NSFont
#define SDKImage             NSImage

#define SDKView              NSView
#define SDKViewController    NSViewController

// views
#define SDKTextField         NSTextField
#define SDKImageView         NSImageView
#define SDKLabel             NSTextField
#define SDKButton            NSButton
#define SDKTextView          NSTextView

#define SDKApplication       NSApplication

#import "FLCompatibility+OSX.h"


#endif

#if IOS

#define SDKColor            UIColor
#define SDKControl          UIControl
#define SDKEvent            UIEvent
#define SDKFont             UIFont
#define SDKImage            SDKImage

#define SDKView             UIView
#define SDKViewController   UIViewController

#define SDKButton           UIButton
#define SDKImageView        SDKImageView
#define SDKLabel            UITextField
#define SDKTextField        UITextField
#define SDKTextView         UITextView

#define SDKApplication      UIApplication

#import "FLCompatibility+iOS.h"


#endif

