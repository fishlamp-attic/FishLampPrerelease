//
//  FLStringBuilderSection.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilderSection.h"
#import "FLWhitespace.h"

@interface FLStringBuilderSection ()
//@property (readwrite, strong, nonatomic) NSMutableString* openLine;
@end

@interface FLDocumentSectionIndent : NSObject<FLAppendableString>
+ (id) documentSectionIndent;
@end

@interface FLDocumentSectionOutdent : NSObject<FLAppendableString>
+ (id) documentSectionOutdent;
@end

@implementation FLDocumentSectionIndent
+ (id) documentSectionIndent {
    FLReturnStaticObject(FLAutorelease([[[self class] alloc] init]));
}
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [stringFormatter indent];
}
- (NSString*) description {
    return @"INDENT";
}
@end

@implementation FLDocumentSectionOutdent
+ (id) documentSectionOutdent {
    FLReturnStaticObject(FLAutorelease([[[self class] alloc] init]));
}
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [stringFormatter outdent];
}
- (NSString*) description {
    return @"OUTDENT";
}

@end

@implementation FLStringBuilderSection 

@synthesize lines = _lines;
@synthesize parent = _parent;

- (id) init {
    self = [super init];
    if(self) {
        _lines = [[NSMutableArray alloc] init];
    }    
    return self;
}

+ (id) stringBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_lines release];
    [super dealloc];
}
#endif

- (id) lastLine {
    FLAssertNotNil(_lines);
    FLAssertNotNil([_lines lastObject]);
    return [_lines lastObject];
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);

    [_lines addObject:@""];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);
    _needsLine = YES;
    _lineOpen = YES;
}

- (BOOL) stringFormatterCloseLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);
    _needsLine = YES;
    if(_lineOpen) {
        _lineOpen = NO;
        return YES;
    }

    return NO;
}

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {

    FLAssertNotNil(_lines);
    FLAssertNotNil(string);

    if(_needsLine) {
        [_lines addObject:FLAutorelease([string mutableCopy])];
        _needsLine = NO;
    }
    else {
        FLAssert([self.lastLine isKindOfClass:[NSMutableString class]]);
        [self.lastLine appendString:string];
    }
}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
      [self stringFormatter:formatter appendString:attributedString.string];
}

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter {
    return _indentLevel;
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    FLAssertNotNil(_lines);
    ++_indentLevel;
    [_lines addObject:[FLDocumentSectionIndent documentSectionIndent]];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    FLAssertNotNil(_lines);
    --_indentLevel;
    [_lines addObject:[FLDocumentSectionOutdent documentSectionOutdent]];
}

- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) didMoveToParent:(FLStringBuilderSection*) parent {
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter  {

    FLAssertNotNil(_lines);
    FLAssertNotNil(anotherStringFormatter);

    [self willBuildWithStringFormatter:anotherStringFormatter];

    for(id<FLStringFormatter> line in _lines) {
        [line appendToStringFormatter:anotherStringFormatter];
        [line closeLine];
    }

    [self didBuildWithStringFormatter:anotherStringFormatter];
}

- (void) setParent:(FLStringBuilderSection*) parent {
    if(_parent) {
        [self didMoveToParent:nil];
    }

    _parent = parent;

    [self didMoveToParent:_parent];
}

- (void) appendSection:(FLStringBuilderSection*) section {

    FLAssertNotNil(_lines);
    FLAssertNotNil(section);

    [_lines addObject:section];
    _needsLine = YES;
    [section setParent:self];
}

//- (void) stringFormatterDeleteAllCharacters:(FLStringFormatter*) stringFormatter {
//    FLAssertNotNil(_lines);
//    FLAssertNotNil(stringFormatter);
//
//    [_lines removeAllObjects];
//}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    FLAssertNotNil(_lines);

    NSUInteger length = 0;
    for(id<FLStringFormatter> line in _lines) {
        length += line.length;
    }
    return length;
}

- (void) stringFormatter:(FLStringFormatter*) formatter
         didMoveToParent:(id) parent {
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    FLPrettyString* str = [FLPrettyString prettyString];
    [str appendStringFormatter:self];
    return str.string;
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    FLPrettyAttributedString* string = [FLPrettyAttributedString prettyAttributedString];
    [string appendStringFormatter:self];
    return [string exportAttributedString];
}



@end

