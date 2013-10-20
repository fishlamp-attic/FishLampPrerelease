//
//  FLPrettyAttributedString.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLPrettyAttributedString.h"
#import "FLSelectorPerforming.h"

@implementation FLPrettyAttributedString

- (id) initWithWhitespace:(FLWhitespace*) whitespace {
    self = [super initWithWhitespace:whitespace];
    if(self) {
        _attributedString = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

+ (id) prettyAttributedString:(FLWhitespace*) whitespace {
    return FLAutorelease([[[self class] alloc] initWithWhitespace:whitespace]);
}

+ (id) prettyAttributedString {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) prettyAttributedStringWithString:(NSString*) string {
    FLPrettyAttributedString* prettyString = FLAutorelease([[[self class] alloc] init]);
    [prettyString appendString:string];
    return prettyString;
}

- (NSUInteger) length {
    return [_attributedString length];
}

#if FL_MRC
- (void) dealloc {
    [_attributedString release];
    [super dealloc];
}
#endif

- (void) deleteAllCharacters {
    [_attributedString deleteCharactersInRange:NSMakeRange(0, [_attributedString length])];
}

- (NSString*) description {
    return [self exportString];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor {

    [preprocessor processAndAppendAttributedString:[self exportAttributedString]
                                 toStringFormatter:anotherStringFormatter];

}

- (void) willAppendString:(NSString*) string {
    [self willAppendAttributedString:FLAutorelease([[NSAttributedString alloc] initWithString:string])];
}

- (void) willAppendAttributedString:(NSAttributedString*) attributedString {
    [_attributedString appendAttributedString:attributedString];
}

- (NSString*) exportString {
    return [_attributedString string];
}

- (NSAttributedString*) exportAttributedString {
    return FLCopyWithAutorelease(_attributedString);
}

@end
