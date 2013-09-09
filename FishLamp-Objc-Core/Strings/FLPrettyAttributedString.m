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

- (NSMutableAttributedString*) storage {
    return _attributedString;
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

//- (void) appendPrettyString:(FLPrettyString*) string {
//    [self appendStringContainingMultipleLines:string.string];
//}

- (void) deleteAllCharacters {
    [_attributedString deleteCharactersInRange:NSMakeRange(0, [_attributedString length])];
}

- (NSString*) description {
    return [self exportString];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
    [anotherStringFormatter appendAttributedString:[self exportAttributedString]];
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

//@implementation FLDeprecatedPrettyAttributedString
//
//@synthesize delegate = _delegate;
//
//- (void) willAppendAttributedString:(NSAttributedString*) attributedString {
//
//    NSAttributedString* stringToAppend = FLRetainWithAutorelease(attributedString);
//
//    if([self.delegate respondsToSelector:@selector(prettyString:willAppendAttributedString:)]) {
//        stringToAppend = [self.delegate prettyString:self willAppendAttributedString:attributedString];
//    }
//
//    [self.storage appendAttributedString:stringToAppend];
//    
//    FLPerformSelector2(self.delegate, @selector(prettyString:didAppendAttributedString:), self, stringToAppend); 
//}
//
//@end
