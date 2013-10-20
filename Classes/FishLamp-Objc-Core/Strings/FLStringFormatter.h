//
//  FLAbstractStringFormatter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"
#import "FLObjcPropertyHelpers.h"

typedef void (^FLStringFormatterBlock)();

@protocol FLStringFormatterProprocessor;
@protocol FLStringFormatter;

@protocol FLAppendableString <NSObject>
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor;
@end

@protocol FLStringFormatter <FLAppendableString>

@property (readonly, assign, nonatomic) NSUInteger length;
@property (readonly, assign, nonatomic) BOOL isEmpty;

/// ends currently open line, opens a new one.
- (void) openLine;
- (void) openLineWithString:(NSString*) string;
- (void) openLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);
- (void) openLineWithAttributedString:(NSAttributedString*) string;

/// append to open line. Opens a news line if no line is open.
- (void) appendString:(NSString*) string; 
- (void) appendFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);
- (void) appendAttributedString:(NSAttributedString*) string; 
- (void) appendFormat:(NSString*) format arguments:(va_list)argList;

// end current line with EOF (only if it hasn't already been ended)
- (void) closeLine; 
- (void) closeLineWithString:(NSString*) string;
- (void) closeLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);
- (void) closeLineWithAttributedString:(NSAttributedString*) format;

/// Ends currently open line, then adds a blank line. Leaves no open line.
- (void) appendBlankLine;

/// AppendLine: Append a string, then a EOL. Ends currently open line first.
- (void) appendLine:(NSString*) line;  
- (void) appendLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);
- (void) appendLineWithAttributedString:(NSAttributedString*) line;
- (void) appendLineWithFormat:(NSString*) format arguments:(va_list)argList;

/// AppendLine is called for each line
- (void) appendLines:(NSString**) lines count:(NSInteger) count;
- (void) appendLines:(NSString**) lines;
- (void) appendLinesWithArray:(NSArray*) lines;

/// incoming string is chopped into lines and then fed through appendLines
- (void) appendStringContainingMultipleLines:(NSString*) inLines;
- (void) appendStringContainingMultipleLines:(NSString*) inLines trimWhitespace:(BOOL) trimWhitespace;

/// indent the string (optionally implemented by delegate)
@property (readonly, nonatomic, assign) NSInteger indentLevel;
- (void) indent;
- (void) outdent;

// if delegate doesn't implement indentLevel, then the block is executed anyway and resulting
// text will not be indented.
- (void) indent:(FLStringFormatterBlock) block;

- (void) appendInScope:(NSString*) openScope 
            closeScope:(NSString*) closeScope 
             withBlock:(FLStringFormatterBlock) block;

//- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter;

- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter
              withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor;

@property (readwrite, assign, nonatomic) id parent;

- (NSString*) exportString;
- (NSAttributedString*) exportAttributedString;

@end

@protocol FLStringFormatterImplementation <NSObject>
- (void) appendBlankLine;
- (void) openLine;
- (void) closeLine;
- (void) indent;
- (void) outdent;
- (NSInteger) indentLevel;
- (NSUInteger) length;
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor;

- (void) willAppendString:(NSString*) string;
- (void) willAppendAttributedString:(NSAttributedString*) string;
- (void) didMoveToParent:(id) parent;
@end

// Concrete base class

@interface FLStringFormatter : NSObject<FLStringFormatter> {
@private
    __unsafe_unretained id _parent;
}

// deprecated
/*
- (NSAttributedString*) attributedString;
- (NSString*) string;
*/

@end

@protocol FLStringFormatterProprocessor <NSObject>
- (void) processAndAppendString:(NSString*) string toStringFormatter:(id<FLStringFormatter>) formatter;
- (void) processAndAppendAttributedString:(NSAttributedString*) string
                        toStringFormatter:(id<FLStringFormatter>) formatter;
@end

@interface FLStringFormatterLineProprocessor : NSObject<FLStringFormatterProprocessor>
FLSingletonProperty(FLStringFormatterLineProprocessor);
@end

