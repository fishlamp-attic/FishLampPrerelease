//
//  FLWhitespaceStringFormatter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatter.h"

@class FLWhitespace;

@interface FLWhitespaceStringFormatter : FLStringFormatter {
@private
    BOOL _editingLine;
    FLWhitespace* _whitespace;
    NSInteger _indentLevel;
}

@property (readonly, assign, nonatomic) BOOL lineIsOpen;
@property (readonly, strong, nonatomic) FLWhitespace* whitespace;
@property (readonly, assign, nonatomic) NSInteger indentLevel;

- (id) initWithWhitespace:(FLWhitespace*) whitespace;

// required overrides
- (void) willAppendString:(NSString*) string;
- (void) willAppendAttributedString:(NSAttributedString*) string;

// optional overrides
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (NSUInteger) length;
- (void) willOpenLine;
- (void) willCloseLine;

// utils 
- (void) appendEOL;

@end