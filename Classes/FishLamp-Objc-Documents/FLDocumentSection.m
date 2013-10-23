//
//  FLDocumentSection.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDocumentSection.h"
#import "FLWhitespace.h"

@interface FLDocumentSection ()
//@property (readwrite, strong, nonatomic) NSMutableString* openLine;
@end

@implementation NSString (FLDocumentSection)

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {
    FLAssertNotNil(anotherStringFormatter);

    [anotherStringFormatter appendLine:self];
}

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
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {
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
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {
    [stringFormatter outdent];
}
- (NSString*) description {
    return @"OUTDENT";
}

@end

@implementation FLDocumentSection 

@synthesize lines = _lines;

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
}

- (void) stringFormatterCloseLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);
    _needsLine = YES;
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

- (void)stringFormatter:(FLStringFormatter*) formatter
appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter
       withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {

    FLAssertNotNil(_lines);
    FLAssertNotNil(anotherStringFormatter);

    [self willBuildWithStringFormatter:anotherStringFormatter];

    for(id<FLStringFormatter> line in _lines) {
        [anotherStringFormatter appendStringFormatter:line
                                     withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    }

    [self didBuildWithStringFormatter:anotherStringFormatter];
}

- (void) appendStringFormatter:(id<FLStringFormatter>) stringBuilder {

    FLAssertNotNil(_lines);
    FLAssertNotNil(stringBuilder);

    [_lines addObject:stringBuilder];
    _needsLine = YES;
    [stringBuilder setParent:self];
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
    [str appendStringFormatter:self withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    return str.string;
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    FLPrettyAttributedString* string = [FLPrettyAttributedString prettyAttributedString];
    [string appendStringFormatter:self withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    return [string exportAttributedString];
}



@end

