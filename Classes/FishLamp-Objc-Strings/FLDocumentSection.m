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

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
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
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter {
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
- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter {
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

- (void) willAppendString:(NSString*) string {

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

- (void) appendAttributedString:(NSAttributedString*) attributedString {
    [self appendString:attributedString.string];
}

- (void) indent {
    FLAssertNotNil(_lines);
    [super indent];
    [_lines addObject:[FLDocumentSectionIndent documentSectionIndent]];
}

- (void) outdent {
    FLAssertNotNil(_lines);
    [super outdent];
    [_lines addObject:[FLDocumentSectionOutdent documentSectionOutdent]];
}

- (NSString*) description {
    FLPrettyString* str = [FLPrettyString prettyString];
    [str appendStringFormatter:self];
    return str.string;
}

- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) stringFormatter:(FLStringFormatter*) myFormatter
appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {

    FLAssertNotNil(_lines);
    FLAssertNotNil(myFormatter);
    FLAssertNotNil(anotherStringFormatter);

    [self willBuildWithStringFormatter:anotherStringFormatter];

    for(id<FLStringFormatter> line in _lines) {
        [anotherStringFormatter appendStringFormatter:line];
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

- (NSUInteger) length {
    FLAssertNotNil(_lines);

    NSUInteger length = 0;
    for(id<FLStringFormatter> line in _lines) {
        length += line.length;
    }
    return length;
}


@end

