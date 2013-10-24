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
        [_stack addObject:[FLStringBuilderSection stringBuilder]];
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
    [_stack addObject:[FLStringBuilderSection stringBuilder]];
}

- (id<FLStringFormatter>) rootStringBuilder {
    FLAssertNotNil([_stack objectAtIndex:0]);
    return [_stack objectAtIndex:0];
}

- (FLStringBuilderSection*) openedSection {
    FLAssertNotNil([_stack lastObject]);
    return [_stack lastObject];
}

//- (void) appendStringFormatter:(id<FLStringFormatter>) formatter {
//    FLAssert(_stack.count > 0);
//    
//    [self.openedSection appendStringFormatter:formatter
//                             withPreprocessor:[FLStringFormatterLineProprocessor instance]];
//}

- (void) openSection:(FLStringBuilderSection*) section {
    [self appendSection:section];
    [_stack addObject:section];
}

- (void) appendSection:(FLStringBuilderSection*) section {
    FLAssert(_stack.count > 0);
    [[self openedSection] appendSection:section];
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
    [prettyString appendStringFormatter:self];
    return [prettyString exportAttributedString];
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter{
    [[self openedSection] appendBlankLine];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    [[self openedSection] openLine];
}

- (BOOL) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    return [[self openedSection] closeLine];
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

- (NSString*) buildString {
    return [self buildStringWithWhitespace:[FLWhitespace defaultWhitespace]];
}

- (NSString*) buildStringWithWhitespace:(FLWhitespace*) whitespace {
    FLPrettyString* prettyString = [FLPrettyString prettyString:whitespace];
    [prettyString appendStringFormatter:self];
    return prettyString.string;
}

- (NSString*) buildStringWithNoWhitespace {
    return [self buildStringWithWhitespace:nil];
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter  {

    [anotherStringFormatter appendStringFormatter:self.rootStringBuilder];
}

@end
