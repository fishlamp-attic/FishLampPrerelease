//
//  FLScopeStringBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDocumentBuilder.h"
#import "FLPrettyString.h"
#import "FLPrettyAttributedString.h"

@implementation FLDocumentBuilder 

@synthesize document = _document;

- (id) init {
    self = [super init];
    if(self) {
        _document = [[FLStringDocument alloc] init];
        _document.rootStringBuilder.parent = self;
    }
    return self;
}

+ (id) documentBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_document release];
    [super dealloc];
}
#endif

//- (void) stringFormatter:(FLStringFormatter*) stringFormatter 
//            appendString:(NSString*) string
//  appendAttributedString:(NSAttributedString*) attributedString
//              lineUpdate:(FLStringFormatterLineUpdate) lineUpdate {
//
//    [[self openedSection] stringFormatter:stringFormatter appendString:string appendAttributedString:attributedString lineUpdate:lineUpdate];
//}                                                 

- (id<FLStringFormatter>) openedSection {
    return [_document openedStringBuilder];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
    [anotherStringFormatter appendStringFormatter:_document.rootStringBuilder];
}

- (void) appendStringFormatter:(id<FLStringFormatter>) element {
    [self.document appendStringFormatter:element];
}

- (void) openSection:(id<FLStringFormatter>) element {
    [self.document openStringBuilder:element];
}

//- (void) appendStringFormatter:(id<FLStringFormatter>) element {
//    [self.document appendStringFormatter:element];
//}

- (void) closeSection {
    [self.document closeStringBuilder];
}

- (void) closeAllSections {
    [self.document closeAllStringBuilders];
}

//- (void) willAppendString:(NSString*) string {
//    [[self.document] willAppendString:string];
//}
//
//- (void) willAppendAttributedString:(NSAttributedString*) string {
//    [[self.document] willAppendAttributedString:string];
//}

- (NSString*) exportString {
    return [self buildString];
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

- (NSAttributedString*) exportAttributedString {
    FLPrettyAttributedString* prettyString = [FLPrettyAttributedString prettyAttributedString];
    [prettyString appendStringFormatter:self];
    return [prettyString exportAttributedString];
}

- (void) appendBlankLine {
    [[self openedSection] appendBlankLine];
}

- (void) openLine {
    [[self openedSection] openLine];
}

- (void) closeLine {
    [[self openedSection] closeLine];
}

- (void) appendString:(NSString*) string {
    [[self openedSection] appendString:string];
}

- (void) appendAttributedString:(NSAttributedString*) attributedString {
    [[self openedSection] appendAttributedString:attributedString];
}

- (void) indent {
    [[self openedSection] indent];
}

- (void) outdent {
    [[self openedSection] outdent];
}

- (NSUInteger) length {
    return [_document length];
}

- (NSString*) description {
    return [self exportString];
}

- (id) parent {
    return nil;
}

//- (void) appendDocument:(FLDocumentBuilder*) document {
//    [self appendStringFormatter:document];
//}




@end