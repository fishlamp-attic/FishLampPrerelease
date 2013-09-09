//
//  FLPrettyString.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPrettyString.h"
#import "FLAssertions.h"
#import "FLWhitespace.h"
#import "FLSelectorPerforming.h"

@implementation FLPrettyString

@synthesize delegate = _delegate;

- (id) initWithWhitespace:(FLWhitespace*) whitespace {
    self = [super initWithWhitespace:whitespace];
    if(self) {
        _string = [[NSMutableString alloc] init];
    }
    return self;
}

- (NSString*) string {
    return _string;
}

+ (id) prettyString:(FLWhitespace*) whitespace {
    return FLAutorelease([[[self class] alloc] initWithWhitespace:whitespace]);
}

+ (id) prettyString {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) prettyStringWithString:(NSString*) string {
    FLPrettyString* prettyString = FLAutorelease([[[self class] alloc] init]);
    [prettyString appendString:string];
    return prettyString;
}

- (NSUInteger) length {
    return [_string length];
}

#if FL_MRC
- (void) dealloc {
    [_string release];
    [super dealloc];
}
#endif

//- (void) appendPrettyString:(FLPrettyString*) string {
//    [self appendStringContainingMultipleLines:string.string];
//}

- (void) deleteAllCharacters {
    [_string deleteCharactersInRange:NSMakeRange(0, [_string length])];
}

- (NSString*) description {
    return [self string];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
    [anotherStringFormatter appendString:self.string];
}

- (void) willAppendString:(NSString*) string {
    [_string appendString:string];
    FLPerformSelector2(self, @selector(prettyString:didAppendString:), self, string); 
}

- (void) willAppendAttributedString:(NSAttributedString*) attributedString {
    [self willAppendString:[attributedString string]];
}

@end

@implementation NSObject (FLPrettyString)

- (void) describeToString:(FLPrettyString*) string {
    [string appendInScope:[NSString stringWithFormat:@"%@ {", NSStringFromClass([self class])] 
               closeScope:@"}"
                withBlock:^{
                    [self describeSelf:string];
                }]; 
}

- (NSString*) prettyDescription {
    FLPrettyString* str = [FLPrettyString prettyString];
    [self describeToString:str];
    return [str string];
}

- (void) prettyDescription:(FLPrettyString*) string {
    [string indent: ^{
        [self describeSelf:string];
    }];
}

- (void) describeSelf:(FLPrettyString*) string {
    [string appendLine:[self description]];
}

@end

