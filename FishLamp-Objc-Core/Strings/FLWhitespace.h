//
//  FLWhitespace.h
//  FLCore
//
//  Created by Mike Fullerton on 5/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

@class FLPrettyString;

/// FLWhitespaceDefaultEOL is the default EOL "\n"

#define FLWhitespaceDefaultEOL          @"\n"

/// FLWhitespaceTabTab is defines a "tab style" behavior - e.g. it uses \\t not "    " for a tab.

#define FLWhitespaceTabTab              @"\t"

/// FLWhitespaceFourSpacesTab defines a four character tab. This is the default tab.


#define FLWhitespaceFourSpacesTab       @"    " // 4 spaces

//#define FLWhitespaceFourSpacesTab       @"...." // 4 spaces


/// FLWhitespaceDefaultTabString defines the default tab string. You can override this in your prefix file.

#ifndef FLWhitespaceDefaultTabString    
#define FLWhitespaceDefaultTabString    FLWhitespaceFourSpacesTab
#endif

/// FLWhitespace defines how a builder handles whitespace during a build. With this you can control tabs and LF.

#define FLWhitespaceMaxIndent 128

@interface FLWhitespace : NSObject {
@private
    NSString* _eolString;
    NSString* _tabString;
    NSString* _cachedTabs[FLWhitespaceMaxIndent];
}

/// Create a whitespace

- (id) initWithEOL:(NSString*) eol tab:(NSString*) tab;

+ (id) whitespace:(NSString*) eol tab:(NSString*) tab;

/// Set the eolString here, e.g. \\n or \\r\\n. See FLWhitespaceDefaultEOL
@property (readonly, strong, nonatomic) NSString* eolString;

/// Set teh tabString. See FLWhitespaceFourSpacesTab or FLWhitespaceTabTab
@property (readonly, strong, nonatomic) NSString* tabString; 

/// returns tabString for indent level. This is cached and built once for the life of the formatter.
- (NSString*) tabStringForScope:(NSUInteger) indent;

/// returns a formatter built with default EOL and default tab string.
+ (id) tabbedWithSpacesWhitespace;

/// returns a formatter that doesn't insert EOL or tabs (e.g. you're sending XML in a HTTP request)
+ (id) compressedWhitespace;

+ (id) untabbedWhitespace;

+ (id) defaultWhitespace;

@end

