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

- (NSString*) exportString {
    return nil;
}

- (NSAttributedString*) exportAttributedString {
    return nil;
}

- (NSAttributedString*) attributedString {
    return [self exportAttributedString];
}

- (NSString*) string {
    return [self exportString];
}

- (void) indent {
}

- (void) outdent {
}

- (void) processString:(NSString*) string {

    [self willAppendString:string];
//    [[FLStringFormatterLineProprocessor instance] processAndAppendString:string toStringFormatter:self];
}

- (void) willAppendString:(NSString*) string {
}

- (void) willAppendAttributedString:(NSAttributedString*) string {
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) appendStringFormatter:(id<FLStringFormatter>) aStringFormatter {
    [aStringFormatter appendSelfToStringFormatter:self];
}

- (void) setParent:(id) parent {
    _parent = parent;
    [self didMoveToParent:_parent];
}

- (void) didMoveToParent:(id) parent {
}

- (void) appendBlankLine {
}

- (void) openLine {
}

- (void) appendString:(NSString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self processString:string];
}

- (void) appendAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self willAppendAttributedString:string];
}

- (void) closeLine {
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
        [self willAppendAttributedString:string];
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
    [self willAppendAttributedString:string];
}

- (void) appendLineWithAttributedString:(NSAttributedString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self willAppendAttributedString:string];
    [self closeLine];
}

- (void) appendLine:(NSString*) string {
    FLAssertNotNil(string);

    [self openLine];
    [self processString:string];
    [self closeLine];
}

- (void) indent:(FLStringFormatterBlock) block {
    [self closeLine];
    [self indent];
    // subsequent calls to us will open a line, etc..
    block();
    [self closeLine]; // just in case.
    [self outdent];
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

- (NSUInteger) length {
    return 0;
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


@end

@implementation FLStringFormatterLineProprocessor

FLSynthesizeSingleton(FLStringFormatterLineProprocessor);

- (void) processAndAppendString:(NSString*) string toStringFormatter:(FLStringFormatter*) formatter {

    NSRange range = { 0, 1 };
    
    for(NSUInteger i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        
        if(c == '\n') {
            if(range.length > 0) {
                [formatter openLine];
                [formatter willAppendString:[string substringWithRange:range]];
                [formatter closeLine];
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
            [formatter willAppendString:[string substringWithRange:range]];
        }
        else {
            [formatter willAppendString:string];
        }
    }
}

@end
