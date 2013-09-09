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
@synthesize indentLevel = _indentLevel;

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

- (void) closeLine {

    if(_editingLine) {
        [self willCloseLine];
        _editingLine = NO;
    }
}

- (void) openLine {
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

- (void) indent {
    ++_indentLevel;
}

- (void) outdent {
    --_indentLevel;
}

- (void) appendEOL {
    if(self.whitespace) {
        [self appendString:self.whitespace.eolString];
    } 
}

- (void) appendBlankLine {
    [self closeLine];

    // intentionally not opening line
    [self appendEOL];
}

- (void) willAppendString:(NSString*) string {
}

- (void) willAppendAttributedString:(NSAttributedString*) string {
}

- (NSUInteger) length {
    return 0;
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

@end
