//
//  FishLampMinimum.h
//  FLCore
//
//  Generated by Mike Fullerton on 7/18/12 4:32 PM using "Headers" tool
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

// Prerequisites

#import <Foundation/Foundation.h>
#import <Availability.h>

#if DEBUG
    #define FL_SHIP_ONLY_INLINE 
#else
    #define FL_SHIP_ONLY_INLINE NS_INLINE
#endif

#import "FLCoreRequired.h"

// TODO: push these out to the frameworks?
#if IOS
//    #import <UIKit/UIKit.h>
//    #import <CoreGraphics/CoreGraphics.h>
//    #import <MobileCoreServices/MobileCoreServices.h>
//    #import <ImageIO/ImageIO.h>
#else
//    #import <Cocoa/Cocoa.h>
//    #import <AppKit/AppKit.h>
//    #import <CoreServices/CoreServices.h>
#endif

// Errors
#import "FLErrors.h"

// Assertions
#import "FLAssertions.h"


// Properties
#import "FLObjcPropertyHelpers.h"

// String Utils
#import "FLStrings.h"

// Utilities
#import "FLUtilities.h"

// Proxy objects (Owner objects)
#import "FLObjectProxies.h"

// Event broadcasting and object communication
#import "FLBroadcaster.h"

// Logger
#import "FLSimpleLogger.h"

// Testing
#import "FishLampTesting.h"

/*
    // Runtime
    #import "FLObjcRuntime.h"
    #import "FLPropertyAttributes.h"
    #import "FLRuntimeInfo.h"
    #import "FLSelector.h"

    // Strings
    #import "FLCharString.h"

*/

