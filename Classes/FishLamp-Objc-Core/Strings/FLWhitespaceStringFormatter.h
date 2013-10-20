//
//  FLWhitespaceStringFormatter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatter.h"

@class FLWhitespace;

@interface FLWhitespaceStringFormatter : FLStringFormatter<FLStringFormatterImplementation> {
@private
    BOOL _editingLine;
    FLWhitespace* _whitespace;
    NSInteger _indentLevel;
}

@property (readonly, assign, nonatomic) BOOL lineIsOpen;
@property (readonly, strong, nonatomic) FLWhitespace* whitespace;
@property (readonly, assign, nonatomic) NSInteger indentLevel;

- (id) initWithWhitespace:(FLWhitespace*) whitespace;

// optional overrides
- (void) willOpenLine;
- (void) willCloseLine;

// utils 
- (void) appendEOL;

@end

@protocol FLWhitespaceStringFormatterImplementation <NSObject>
- (void) willAppendString:(NSString*) string;
- (void) willAppendAttributedString:(NSAttributedString*) string;

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor;

- (NSUInteger) length;

- (void) didMoveToParent:(id) parent;
@end