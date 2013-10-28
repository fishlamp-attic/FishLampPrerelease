//
//  FLStringFormatterTester.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatterTester.h"
#import "FishLampTesting.h"

@implementation FLTestWhitespace

- (id) initWithEOL:(NSString*) eol {
    return [super initWithEOL:eol tabChar:@">" tabCharRepeatCount:1];
}

+ (id) testWhitespace {
    return FLAutorelease([[[self class] alloc] initWithEOL:FLWhitespaceDefaultEOL]);
}

@end

@implementation FLStringFormatterTester

- (id<FLStringFormatter>) createStringFormatter {
    return nil;
}

- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace {
    return nil;
}

- (NSString*) formattedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace {
    return [formatter formattedString];
}

- (NSAttributedString*) formattedAttributedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace {
    return [formatter formattedAttributedString];
}

- (void) testPrettyString1 {
    id<FLStringFormatter> stringFormatter = [self createStringFormatter];
    [stringFormatter appendString:@"hello world"];

    NSString* string = [[self formattedAttributedString:stringFormatter whitespace:[FLTestWhitespace testWhitespace]] string];
    NSString* string2 = [self formattedString:stringFormatter whitespace:[FLTestWhitespace testWhitespace]];

    FLTAssertNotNil(string);
    FLTAssertNotNil(string2);
    FLTAssertStringsAreEqual(string, string2);
    FLTAssertStringsAreEqual(string, @"hello world");

}

- (void) testPrettyStringLines {

    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"this\nis\na\ntest\n";

    NSString* exportedString = [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]];
    FLTAssertNotNil(exportedString);
    FLTAssertStringsAreEqual(result, exportedString);
}

- (void) testPrettyStringNoWhitespace {
    id<FLStringFormatter> string = [self createStringFormatter:[FLWhitespace compressedWhitespace]];

    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"thisisatest";

    NSString* exportedString = [self formattedString:string whitespace:[FLWhitespace compressedWhitespace]];
    FLTAssertNotNil(exportedString);
    FLTAssertStringsAreEqual(result, exportedString);
}

- (void) testDefaultWhitespace {
    FLTAssert(   [FLWhitespace defaultWhitespace] ==
                [FLWhitespace tabbedWithSpacesWhitespace]);
}

- (void) testWhitespaceTabs {
    for(int i = 0; i < 5;i++) {
        NSString* tab = [[FLWhitespace defaultWhitespace] tabStringForScope:i];

        FLTAssert(tab.length == i * 4);
        for(int j = 0; j < tab.length; j++) {
            FLTAssert([tab characterAtIndex:j] == ' ');
        }
    }
}

- (NSString*) spaces:(int) count {
    NSMutableString* string = [NSMutableString string];
    for(int i = 0; i < count; i++) {
        [string appendString:@" "];
    }
    return string;
}

static NSString* indent_result = @"foo\n>hello\n>>world\n>bar\nfoobar\n";

- (void) testPrettyStringIndent1 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLTAssertStringsAreEqual(@"", [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
    FLTAssert(string.indentLevel == 0);
    [string appendLine:@"foo"];
    [string indent];
        FLTAssert(string.indentLevel == 1);
        [string appendLine:@"hello"];
        [string indent];
            FLTAssert(string.indentLevel == 2);
            [string appendLine:@"world"];
            [string outdent];
        FLTAssert(string.indentLevel == 1);
        [string appendLine:@"bar"];
        [string outdent];
    FLTAssert(string.indentLevel == 0);
    [string appendLine:@"foobar"];

    FLTAssertStringsAreEqual(indent_result, [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
}

- (void) testPrettyStringIndent2 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLTAssertStringsAreEqual(@"", [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
    [string appendLine:@"foo"];
    FLTAssert(string.indentLevel == 0);

    [string indent:^{
        FLTAssert(string.indentLevel == 1);
        [string appendLine:@"hello"];

        [string indent:^{
            FLTAssert(string.indentLevel == 2);
            [string appendLine:@"world"];
        }];
        FLTAssert(string.indentLevel == 1);

        [string appendLine:@"bar"];
    }];

    [string appendLine:@"foobar"];
     FLTAssert(string.indentLevel == 0);

    FLTAssertStringsAreEqual(indent_result, [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
}

- (void) testAppendString {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendString:@"Hello"];
    [string appendString:@" "];
    [string appendString:@"World"];
    FLTAssertStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"Hello World");

    [string closeLine];
    FLTAssertStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"Hello World\n");
}

- (void) testPrettyStringAppendBlankLine {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendBlankLine];
    [string appendBlankLine];
    [string appendBlankLine];

    FLTAssertStringsAreEqual(@"\n\n\n", [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
}

- (void) testSimpleStringFormatterAppend {
    id<FLStringFormatter> string1 = [self createStringFormatter];
    [string1 appendLine:@"hello"];

    id<FLStringFormatter> string2 = [self createStringFormatter];
    [string2 appendLine:@"world"];

    [string1 appendString:string2];

    FLTAssertStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"hello\nworld\n");
}

- (void) testIndentedStringFormatterAppend {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendLine:@"a"];
    [string1 indent:^{
        [string1 appendLine:@"b"];

        id<FLStringFormatter> string2 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
        [string2 appendLine:@"c"];
        [string2 indent:^{
            [string2 appendLine:@"d"];
        }];

        [string1 appendString:string2];
    }];

    FLTAssertStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"a\n>b\n>c\n>>d\n");
}

- (void) testAppendLine {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendLine:@"hello"];
    FLTAssertStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"hello\n");
}

- (void) testAppendFormat {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendFormat:@"hello %@", @"world"];
    FLTAssertStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"hello world");
}

- (void) testAppendLineWithFormat {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendLineWithFormat:@"hello %@", @"world"];
    FLTAssertStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"hello world\n");
}


- (void) testLineWithLineFeedInIt {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendLine:@"hello\nworld"];

    FLTAssertStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"hello\nworld\n");
}

- (void) testLineWithLineFeedInIt1 {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendString:@"hello\nworld"];

    FLTAssertStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"hello\nworld");
}



@end
