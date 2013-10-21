//
//  FLScopeStringBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilder.h"
#import "FLPrettyString.h"
#import "FLPrettyAttributedString.h"

@interface FLStringBuilder ()
@property (readonly, strong, nonatomic) id<FLStringFormatter> rootStringBuilder;
@property (readonly, strong, nonatomic) NSArray* stack;
@end

@implementation FLStringBuilder 

@synthesize stack = _stack;

- (id) init {
    self = [super init];
    if(self) {

        _stack = [[NSMutableArray alloc] init];
        [_stack addObject:[FLDocumentSection stringBuilder]];

        self.rootStringBuilder.parent = self;
    }
    return self;
}

+ (id) stringBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_stack release];
    [super dealloc];
}
#endif

- (void) deleteAllStringBuilders {
    [_stack removeAllObjects];
    [_stack addObject:[FLDocumentSection stringBuilder]];
}

- (id<FLStringFormatter>) rootStringBuilder {
    FLAssertNotNil([_stack objectAtIndex:0]);
    return [_stack objectAtIndex:0];
}

- (id<FLStringFormatter>) openedSection {
    FLAssertNotNil([_stack lastObject]);
    return [_stack lastObject];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {

    [anotherStringFormatter appendStringFormatter:self.rootStringBuilder withPreprocessor:preprocessor];
}

- (void) appendStringFormatter:(id<FLStringFormatter>) formatter {
    FLAssert(_stack.count > 0);
    
    [self.openedSection appendStringFormatter:formatter
                             withPreprocessor:[FLStringFormatterLineProprocessor instance]];
}

- (void) openSection:(id<FLStringFormatter>) element {

    FLAssert(_stack.count > 0);
    
    [_stack addObject:element];
}

- (void) closeSection {
    FLAssert(_stack.count > 0);
    
    id last = FLRetainWithAutorelease(self.openedSection);
    [_stack removeLastObject_fl];
}

- (void) closeAllSections {
    while(_stack.count > 1) {
        [self closeSection];
    }
}

- (void) willAppendString:(NSString*) string {
    [[self openedSection] appendString:string];
}

- (void) willAppendAttributedString:(NSAttributedString*) string {
    [[self openedSection] appendAttributedString:string];
}

- (NSString*) exportString {
    return [self buildString];
}

- (NSString*) buildString {
    return [self buildStringWithWhitespace:[FLWhitespace defaultWhitespace]];
}

- (NSString*) buildStringWithWhitespace:(FLWhitespace*) whitespace {
    FLPrettyString* prettyString = [FLPrettyString prettyString:whitespace];
    [prettyString appendStringFormatter:self withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    return prettyString.string;
}

- (NSString*) buildStringWithNoWhitespace {
    return [self buildStringWithWhitespace:nil];
}

- (NSAttributedString*) exportAttributedString {
    FLPrettyAttributedString* prettyString = [FLPrettyAttributedString prettyAttributedString];
    [prettyString appendStringFormatter:self withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    return [prettyString exportAttributedString];
}

- (void) appendBlankLine {
    [[self openedSection] appendBlankLine];
}

- (void) willOpenLine {
    [[self openedSection] openLine];
}

- (void) closeLine {
    [[self openedSection] closeLine];
}

- (NSInteger) indentLevel {
    return [[self openedSection] indentLevel];
}

- (void) indent {
    [[self openedSection] indent];
}

- (void) outdent {
    [[self openedSection] outdent];
}

- (NSUInteger) length {

    NSUInteger length = 0;
    for(id<FLStringFormatter> formatter in _stack) {
        length += formatter.length;
    }

    return length;
}

- (void) didMoveToParent:(id) parent {
}

@end
