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

@implementation FLStringFormatter

@synthesize parent = _parent;

- (id) init {	
	self = [super init];
	if(self) {
		_delegate = self;
	}
	return self;
}

- (NSString*) exportString {
    return [_delegate stringFormatterExportString:self];
}

- (NSAttributedString*) exportAttributedString {
    return [_delegate stringFormatterExportAttributedString:self];
}

- (void) processString:(NSString*) string {

    [_delegate stringFormatter:self appendString:string];
//    [[FLStringFormatterLineProprocessor instance] processAndAppendString:string toStringFormatter:self];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {
    [_delegate stringFormatter:self
   appendSelfToStringFormatter:stringFormatter
              withPreprocessor:preprocessor];
}

- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter
              withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {

    [aStringFormatter appendSelfToStringFormatter:self
                                 withPreprocessor:preprocessor];
}

- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter {
    [aStringFormatter appendSelfToStringFormatter:self
                                withPreprocessor:[FLStringFormatterLineProprocessor instance]];
}

- (void) setParent:(id) parent {
    _parent = parent;
    [_delegate stringFormatter:self didMoveToParent:_parent];
}

- (void) appendString:(NSString*) string {
    FLAssertNotNil(string);

    [_delegate stringFormatterOpenLine:self];
    [self processString:string];
}

- (void) appendAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [_delegate stringFormatterOpenLine:self];
    [_delegate stringFormatter:self appendAttributedString:string];
}

- (void) openLine {
    [_delegate stringFormatterOpenLine:self];
}

- (void) closeLine {
    [_delegate stringFormatterCloseLine:self];
}

- (void) indent {
    [_delegate stringFormatterIndent:self];
}

- (void) outdent {
    [_delegate stringFormatterOutdent:self];
}

- (NSUInteger) length {
    return [_delegate stringFormatterLength:self];
}

- (NSInteger) indentLevel {
    return [_delegate stringFormatterIndentLevel:self];
}

- (void) appendBlankLine {
    [_delegate stringFormatterAppendBlankLine:self];
}

- (void) closeLineWithString:(NSString*) string {

    if(string) {
        [_delegate stringFormatterOpenLine:self];
        [self processString:string];
    }

    [_delegate stringFormatterCloseLine:self];
}

- (void) closeLineWithAttributedString:(NSAttributedString*) string {

    if(string) {
        [_delegate stringFormatterOpenLine:self];
        [_delegate stringFormatter:self appendAttributedString:string];
    }

    [_delegate stringFormatterCloseLine:self];
}

- (void) openLineWithString:(NSString*) string {
    FLAssertNotNil(string);

    [_delegate stringFormatterCloseLine:self];
    [_delegate stringFormatterOpenLine:self];
    [self processString:string];
}

- (void) openLineWithAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [_delegate stringFormatterCloseLine:self];
    [_delegate stringFormatterOpenLine:self];
    [_delegate stringFormatter:self appendAttributedString:string];
}

- (void) appendLineWithAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [_delegate stringFormatterOpenLine:self];
    [_delegate stringFormatter:self appendAttributedString:string];
    [_delegate stringFormatterCloseLine:self];
}

- (void) appendLine:(NSString*) string {
    FLAssertNotNil(string);

    [_delegate stringFormatterOpenLine:self];
    [self processString:string];
    [_delegate stringFormatterCloseLine:self];
}

- (void) indent:(FLStringFormatterBlock) block {
    [_delegate stringFormatterCloseLine:self];
    [_delegate stringFormatterIndent:self];
    // subsequent calls to us will open a line, etc..
    block();
    [_delegate stringFormatterCloseLine:self]; // just in case.
    [_delegate stringFormatterOutdent:self];
}

- (BOOL) isEmpty {
    return self.length == 0;
}

- (void) appendInScope:(NSString*) openScope
            closeScope:(NSString*) closeScope
             withBlock:(FLStringFormatterBlock) block {
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

@implementation FLStringFormatterLineProprocessor

FLSynthesizeSingleton(FLStringFormatterLineProprocessor);

- (void) processAndAppendString:(NSString*) string
              toStringFormatter:(FLStringFormatter*) formatter {

    NSRange range = { 0, 0 };

    [formatter closeLine];

    for(NSUInteger i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        
        if(c == '\n') {
            if(range.length > 0) {
                [formatter appendLine:[string substringWithRange:range]];
            }
            else {
                [formatter appendBlankLine];
            }
            
            range.location = i+1;
            range.length = 0;
            
            continue;
        }

        ++range.length;
    }
    
    if(range.length) {
        [formatter openLine];
            
        if(range.location > 0) {
            [formatter appendLine:[string substringWithRange:range]];
        }
        else {
            [formatter appendLine:string];
        }
    }
}

- (void) processAndAppendAttributedString:(NSAttributedString*) attributedString
                        toStringFormatter:(id<FLStringFormatter>) formatter {

    NSRange range = { 0, 0 };

    [formatter closeLine];

    NSString* string = [attributedString string];

    for(NSUInteger i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        
        if(c == '\n') {
            if(range.length > 0) {
                [formatter appendLineWithAttributedString:
                    [attributedString attributedSubstringFromRange:range]];
            }
            else {
                [formatter appendBlankLine];
            }
            
            range.location = i+1;
            range.length = 0;
            
            continue;
        }

        ++range.length;
    }
    
    if(range.length) {
        if(range.location > 0) {
            [formatter appendLineWithAttributedString:
                [attributedString attributedSubstringFromRange:range]];
        }
        else {
            [formatter appendLineWithAttributedString:attributedString];
        }
    }

}
@end
