//
//  FLStringFormatterTester.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatterTester.h"

@interface FLTestWhitespace : FLRepeatingCharTabWhitespace
@end

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

- (void) testPrettyString1 {
    id<FLStringFormatter> stringFormatter = [self createStringFormatter];
    [stringFormatter appendString:@"hello world"];

    NSString* string = [[stringFormatter formattedAttributedString] string];
    NSString* string2 = [stringFormatter formattedString];

    FLTestNotNil(string);
    FLTestNotNil(string2);
    FLTestStringsAreEqual(string, string2);
    FLTestStringsAreEqual(string, @"hello world");

}

- (void) testPrettyStringLines {

    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"this\nis\na\ntest\n";

    NSString* exportedString = [string formattedString];
    FLTestNotNil(exportedString);
    FLTestStringsAreEqual(result, exportedString);
}

- (void) testPrettyStringNoWhitespace {
    id<FLStringFormatter> string = [self createStringFormatter:[FLWhitespace compressedWhitespace]];

    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"thisisatest";

    NSString* exportedString = [string formattedString];
    FLTestNotNil(exportedString);
    FLTestStringsAreEqual(result, exportedString);
}

- (void) testDefaultWhitespace {
    FLTest(   [FLWhitespace defaultWhitespace] ==
                [FLWhitespace tabbedWithSpacesWhitespace]);
}

- (void) testWhitespaceTabs {
    for(int i = 0; i < 5;i++) {
        NSString* tab = [[FLWhitespace defaultWhitespace] tabStringForScope:i];

        FLTest(tab.length == i * 4);
        for(int j = 0; j < tab.length; j++) {
            FLTest([tab characterAtIndex:j] == ' ');
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
    FLTestStringsAreEqual(@"", [string formattedString]);
    FLTest(string.indentLevel == 0);
    [string appendLine:@"foo"];
    [string indent];
        FLTest(string.indentLevel == 1);
        [string appendLine:@"hello"];
        [string indent];
            FLTest(string.indentLevel == 2);
            [string appendLine:@"world"];
            [string outdent];
        FLTest(string.indentLevel == 1);
        [string appendLine:@"bar"];
        [string outdent];
    FLTest(string.indentLevel == 0);
    [string appendLine:@"foobar"];

    FLTestStringsAreEqual(indent_result, [string formattedString]);
}

- (void) testPrettyStringIndent2 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLTestStringsAreEqual(@"", [string formattedString]);
    [string appendLine:@"foo"];
    FLTest(string.indentLevel == 0);

    [string indent:^{
        FLTest(string.indentLevel == 1);
        [string appendLine:@"hello"];

        [string indent:^{
            FLTest(string.indentLevel == 2);
            [string appendLine:@"world"];
        }];
        FLTest(string.indentLevel == 1);

        [string appendLine:@"bar"];
    }];

    [string appendLine:@"foobar"];
     FLTest(string.indentLevel == 0);

    FLTestStringsAreEqual(indent_result, [string formattedString]);
}

- (void) testAppendString {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendString:@"Hello"];
    [string appendString:@" "];
    [string appendString:@"World"];
    FLTestStringsAreEqual([string formattedString], @"Hello World");

    [string closeLine];
    FLTestStringsAreEqual([string formattedString], @"Hello World\n");
}

- (void) testPrettyStringAppendBlankLine {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendBlankLine];
    [string appendBlankLine];
    [string appendBlankLine];

    FLTestStringsAreEqual(@"\n\n\n", [string formattedString]);
}

- (void) testSimpleStringFormatterAppend {
    id<FLStringFormatter> string1 = [self createStringFormatter];
    [string1 appendLine:@"hello"];

    id<FLStringFormatter> string2 = [self createStringFormatter];
    [string2 appendLine:@"world"];

    [string1 appendString:string2];

    FLTestStringsAreEqual([string1 formattedString], @"hello\nworld\n");
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

    FLTestStringsAreEqual([string1 formattedString], @"a\n>b\n>c\n>>d\n");
}

- (void) testAppendLine {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendLine:@"hello"];
    FLTestStringsAreEqual([string formattedString], @"hello\n");
}

- (void) testAppendFormat {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendFormat:@"hello %@", @"world"];
    FLTestStringsAreEqual([string formattedString], @"hello world");
}

- (void) testAppendLineWithFormat {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendLineWithFormat:@"hello %@", @"world"];
    FLTestStringsAreEqual([string formattedString], @"hello world\n");
}


- (void) testLineWithLineFeedInIt {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendLine:@"hello\nworld"];

    FLTestStringsAreEqual([string1 formattedString], @"hello\nworld\n");
}

- (void) testLineWithLineFeedInIt1 {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendString:@"hello\nworld"];

    FLTestStringsAreEqual([string1 formattedString], @"hello\nworld");
}



@end
