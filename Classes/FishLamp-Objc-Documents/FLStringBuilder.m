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

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {
    [[self openedSection] appendString:string];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
    [[self openedSection] appendAttributedString:attributedString];
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return [self buildString];
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    FLPrettyAttributedString* prettyString = [FLPrettyAttributedString prettyAttributedString];
    [prettyString appendStringFormatter:self withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    return [prettyString exportAttributedString];
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter{
    [[self openedSection] appendBlankLine];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    [[self openedSection] openLine];
}

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    [[self openedSection] closeLine];
}

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter{
    return [[self openedSection] indentLevel];
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    [[self openedSection] indent];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    [[self openedSection] outdent];
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {

    NSUInteger length = 0;
    for(id<FLStringFormatter> aFormatter in _stack) {
        length += aFormatter.length;
    }

    return length;
}

- (void) stringFormatter:(FLStringFormatter*) formatter
         didMoveToParent:(id) parent {
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

- (void)stringFormatter:(FLStringFormatter*) formatter
appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter
       withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {

    [anotherStringFormatter appendStringFormatter:self.rootStringBuilder withPreprocessor:preprocessor];
}

@end
