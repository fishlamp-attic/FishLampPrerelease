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

/**
 *  Indent in a block. All calls inside the block are indented once.
 *  Note: if delegate doesn't implement indentLevel, then the block is executed anyway and resulting text will not be indented.
 *
 *  @param block <#block description#>
 */
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

/**
 *  Concrete base class for a string formatter.
 */
@interface FLStringFormatter : NSObject<FLStringFormatter> {
@private
    __unsafe_unretained id _parent;
    __unsafe_unretained id _stringFormatterDelegate;
}

/**
 *  The delegate implements the guts of the string formatter. By default the delegate is set to self because most of the time we will be subclass FLStringFormatter.
 *  @interface MyStringFormatter : FLStringFormatter<FLStringFormatterDelegate>
 */
@property (readwrite, assign, nonatomic) id stringFormatterDelegate;
@end

/**
 *  This delegate is here mainly to help subclasses be sure that they're implementing all the relevant methods.
 *  The delegate is normally the subclass of the FLStringFormatter.
 */
@protocol FLStringFormatterDelegate <NSObject>

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter;

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter;

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter;

- (void) stringFormatterIndent:(FLStringFormatter*) formatter;

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter;

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter;

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter;

- (void)stringFormatter:(FLStringFormatter*) formatter
appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
       withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor;

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string;

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString;

- (void) stringFormatter:(FLStringFormatter*) formatter
         didMoveToParent:(id) parent;

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter;

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter;

@end


@protocol FLStringFormatterProprocessor <NSObject>
- (void) processAndAppendString:(NSString*) string toStringFormatter:(id<FLStringFormatter>) formatter;
- (void) processAndAppendAttributedString:(NSAttributedString*) string
                        toStringFormatter:(id<FLStringFormatter>) formatter;
@end

@interface FLStringFormatterLineProprocessor : NSObject<FLStringFormatterProprocessor>
FLSingletonProperty(FLStringFormatterLineProprocessor);
@end

