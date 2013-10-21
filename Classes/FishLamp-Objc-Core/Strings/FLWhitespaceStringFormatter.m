//
//  FLWhitespaceStringFormatter.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWhitespaceStringFormatter.h"
#import "FLAssertions.h"
#import "FLWhitespace.h"

@implementation FLWhitespaceStringFormatter

@synthesize whitespace = _whitespace;
@synthesize lineIsOpen = _editingLine;

- (id) initWithWhitespace:(FLWhitespace*) whitespace {
    self = [super init];
    if(self) {
        _whitespace = FLRetain(whitespace);
    }
    return self;
}

- (id) init {
    return [self initWithWhitespace:[FLWhitespace defaultWhitespace]];
}

#if FL_MRC
- (void) dealloc {
    [_whitespace release];
    [super dealloc];
}
#endif

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter {

    if(_editingLine) {
        [self willCloseLine];
        _editingLine = NO;
    }
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    if(!_editingLine) {
        _editingLine = YES;
        if(self.whitespace) {
            [self appendString:[self.whitespace tabStringForScope:self.indentLevel]];
        }
        [self willOpenLine];
    }
}
- (void) willCloseLine {
    [self appendEOL];
}

- (void) willOpenLine {
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    ++_indentLevel;
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    --_indentLevel;
}

- (void) appendEOL {
    if(self.whitespace) {
        [self appendString:self.whitespace.eolString];
    } 
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter {
    [self closeLine];

    // intentionally not opening line
    [self appendEOL];

    _editingLine = NO;
}

- (void) stringFormatter:(FLStringFormatter*) formatter appendString:(NSString*) string {
}

- (void) stringFormatter:(FLStringFormatter*) formatter appendAttributedString:(NSAttributedString*) string {
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    return 0;
}

- (void) stringFormatter:(FLStringFormatter*) formatter
        appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {
}

- (void) stringFormatter:(FLStringFormatter*) formatter
         didMoveToParent:(id) parent {
}

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter {
    return _indentLevel;
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return nil;
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    return nil;
}


@end
