//
//  FLAbstractStringFormatter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"
#import "FLStringPreprocessor.h"

typedef void (^FLStringFormatterIndentedBlock)();

@protocol FLStringFormatter;

@protocol FLAppendableString <NSObject>
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter;
@end

@protocol FLStringFormatter <FLAppendableString, FLStringPreprocessorEventHandler>

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
- (BOOL) closeLine;

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

/**
 *  Indent in a block. All calls inside the block are indented once.
 *  Note: if delegate doesn't implement indentLevel, then the block is executed anyway and resulting text will not be indented.
 *
 *  @param block the block in which to append content to this formatter
 */
- (void) indent:(FLStringFormatterIndentedBlock) block;

- (void) appendInScope:(NSString*) openScope 
            closeScope:(NSString*) closeScope 
             withBlock:(FLStringFormatterIndentedBlock) block;

- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter;

- (NSString*) exportString;

- (NSAttributedString*) exportAttributedString;

@end

/**
 *  Concrete base class for a string formatter.
 */
@interface FLStringFormatter : NSObject<FLStringFormatter> {
@private
    __unsafe_unretained id _stringFormatterDelegate;
    id<FLStringPreprocessor> _preprocessor;
}

/**
 *  The delegate implements the guts of the string formatter. By default the delegate is set to self because most of the time we will be subclass FLStringFormatter.
 *  @interface MyStringFormatter : FLStringFormatter<FLStringFormatterDelegate>
 */
@property (readwrite, assign, nonatomic) id stringFormatterDelegate;

@property (readwrite, strong, nonatomic) id<FLStringPreprocessor> preprocessor;
@end

/**
 *  This delegate is here mainly to help subclasses be sure that they're implementing all the relevant methods.
 *  The delegate is normally the subclass of the FLStringFormatter.
 */
@protocol FLStringFormatterDelegate <NSObject>

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter;

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter;

- (BOOL) stringFormatterCloseLine:(FLStringFormatter*) formatter;

- (void) stringFormatterIndent:(FLStringFormatter*) formatter;

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter;

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter;

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter;

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) stringFormatter;

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string;

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString;

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter;

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter;

@end

@interface NSString (FLStringFormatter)
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter;
@end



