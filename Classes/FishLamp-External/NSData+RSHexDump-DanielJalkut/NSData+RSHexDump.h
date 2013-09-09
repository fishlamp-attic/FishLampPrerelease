//
//	NSData+RSHexDump.h
//	RSFoundation
//
//	Created by Daniel Jalkut on 2/14/07.
//	Copyright 2007 Red Sweater Software. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
//	Based on code from Dan Wood 
//	http://gigliwood.com/weblog/Cocoa/Better_description_.html
//
#import "FishLampMinimum.h"

@interface NSData (RSHexDump)

- (NSString *)description;

// startOffset may be negative, indicating offset from end of data
- (NSString *)descriptionFromOffset:(int)startOffset;
- (NSString *)descriptionFromOffset:(int)startOffset limitingToByteCount:(unsigned int)maxBytes;

@end
