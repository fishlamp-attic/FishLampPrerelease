//
//  FLAbstractStringFormatter.m
//  FishLampCore
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringFormatter.h"
#import "FLAssertions.h"
#import "NSArray+FLExtras.h"

@interface FLStringFormatter ()
- (void) closeLineWithString:(NSString*) string;
- (void) closeLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);
- (void) closeLineWithAttributedString:(NSAttributedString*) format;
@end

@implementation FLStringFormatter

@synthesize stringFormatterDelegate = _stringFormatterDelegate;
@synthesize preprocessor = _preprocessor;

- (id) init {	
	self = [super init];
	if(self) {
		_stringFormatterDelegate = self;
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_preprocessor release];
	[super dealloc];
}
#endif

- (NSString*) exportString {
    return [_stringFormatterDelegate stringFormatterExportString:self];
}

- (NSAttributedString*) exportAttributedString {
    return [_stringFormatterDelegate stringFormatterExportAttributedString:self];
}

- (void) stringPreprocessor:(id<FLStringPreprocessor>) preprocessor
              didFindString:(NSString*) string {

    [_stringFormatterDelegate stringFormatter:self appendString:string];
}

- (void) stringPreprocessor:(id<FLStringPreprocessor>) preprocessor
    didFindAttributedString:(NSAttributedString*) string {

    [_stringFormatterDelegate stringFormatter:self appendAttributedString:string];
}

- (void) stringPreprocessorDidFindEOL:(id<FLStringPreprocessor>) preprocessor {
    if(![_stringFormatterDelegate stringFormatterCloseLine:self]) {
        [self appendBlankLine];
    }
}

- (void) processString:(NSString*) string {
    if(_preprocessor) {
        [_preprocessor processString:string eventHandler:self];
    }
    else {
        [_stringFormatterDelegate stringFormatter:self appendString:string];
    }
}

- (void) processAttributedString:(NSAttributedString*) string {
    if(_preprocessor) {
        [_preprocessor processAttributedString:string eventHandler:self];
    }
    else {
        [_stringFormatterDelegate stringFormatter:self appendAttributedString:string];
    }
}

- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [_stringFormatterDelegate stringFormatter:self appendContentsToStringFormatter:stringFormatter];
}

- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter {
    [aStringFormatter appendToStringFormatter:self];
}

- (void) appendString:(NSString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self processString:string];
}

- (void) appendAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self processAttributedString:string];
}

- (void) openLine {
    [_stringFormatterDelegate stringFormatterOpenLine:self];
}

- (BOOL) closeLine {
    return [_stringFormatterDelegate stringFormatterCloseLine:self];
}

- (void) indent {
    [_stringFormatterDelegate stringFormatterIndent:self];
}

- (void) outdent {
    [_stringFormatterDelegate stringFormatterOutdent:self];
}

- (NSUInteger) length {
    return [_stringFormatterDelegate stringFormatterLength:self];
}

- (NSInteger) indentLevel {
    return [_stringFormatterDelegate stringFormatterIndentLevel:self];
}

- (void) appendBlankLine {
    [_stringFormatterDelegate stringFormatterAppendBlankLine:self];
}

- (void) closeLineWithString:(NSString*) string {

    if(string) {
        [self openLine];
        [self processString:string];
    }

    [self closeLine];
}

- (void) closeLineWithAttributedString:(NSAttributedString*) string {

    if(string) {
        [self openLine];
        [self processAttributedString:string];
    }

    [self closeLine];
}

- (void) openLineWithString:(NSString*) string {
    FLAssertNotNil(string);

    [self closeLine];
    [self openLine];
    [self processString:string];
}

- (void) openLineWithAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [self closeLine];
    [self openLine];
    [self processAttributedString:string];
}

- (void) appendLineWithAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self processAttributedString:string];
    [self closeLine];
}

- (void) appendLine:(NSString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self processString:string];
    [self closeLine];
}

- (void) indent:(FLStringFormatterIndentedBlock) block {
    [_stringFormatterDelegate stringFormatterCloseLine:self];
    [self closeLine];
    [self indent];
    // subsequent calls to us will open a line, etc..
    block();
    [self closeLine];
    [self outdent];
}

- (BOOL) isEmpty {
    return self.length == 0;
}

- (void) appendInScope:(NSString*) openScope
            closeScope:(NSString*) closeScope
             withBlock:(FLStringFormatterIndentedBlock) block {
    [self appendLine:openScope];
    [self indent:block];
    [self appendLine:closeScope];
}

- (void) appendLines:(NSString**) lines
               count:(NSInteger) count{

    FLAssertNotNil(lines);
    if(lines) {
        for(int i = 0; i < count; i++) {
            [self appendLine:lines[i]];
        }
    }
}

- (void) appendLines:(NSString**) lines {
    FLAssertNotNil(lines);
    [self appendLines:lines count:FLArrayLength(lines, NSString*)];
}

- (void) appendLinesWithArray:(NSArray*) lines {
    FLAssertNotNil(lines);
    for(NSString* line in lines) {
        [self appendLine:line];
    }
}

- (void) appendFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va;
	va_start(va, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va]);
	va_end(va);
    [self appendString:string];
}

- (void) appendFormat:(NSString*) format 
            arguments:(va_list)argList {
	[self appendString:FLAutorelease([[NSString alloc] initWithFormat:format arguments:argList])];
}

- (void) appendLineWithFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va_args;
	va_start(va_args, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va_args]);
	va_end(va_args);
	[self appendLine:string];
}

- (void) appendLineWithFormat:(NSString*) format arguments:(va_list)argList {
	[self appendLine:FLAutorelease([[NSString alloc] initWithFormat:format arguments:argList])];
}

- (void) openLineWithFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va_args;
	va_start(va_args, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va_args]);
	va_end(va_args);
	[self openLineWithString:string];
}

- (void) closeLineWithFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va_args;
	va_start(va_args, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va_args]);
	va_end(va_args);
	[self closeLineWithString:string];
}

- (NSString*) preprocessLines:(NSString*) lines {
	NSString* string = [lines stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return string;
}

- (void) appendStringContainingMultipleLines:(NSString*) inLines 
                              trimWhitespace:(BOOL) trimWhitespace {
    FLAssertNotNil(inLines);

	NSString* string = trimWhitespace ? [self preprocessLines:inLines] : inLines;
	if(FLStringIsNotEmpty(string)) {
		NSArray* lines = [string componentsSeparatedByString:@"\n"];
		for(NSString* line in lines) {
			NSString* newline = trimWhitespace ? [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : line;
		
			if(FLStringIsNotEmpty(newline)) {
				[self appendLine:newline];
            }
		}
	}
}

- (void) appendStringContainingMultipleLines:(NSString*) inLines {
    [self appendStringContainingMultipleLines:inLines trimWhitespace:YES];
}

- (NSString*) description {
    return [self exportString];
}
@end

@implementation NSString (FLStringFormatter)

- (void) appendToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter  {
    FLAssertNotNil(anotherStringFormatter);
    [anotherStringFormatter appendString:self];
}

@end
