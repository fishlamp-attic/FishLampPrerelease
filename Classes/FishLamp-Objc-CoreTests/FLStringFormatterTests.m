//
//  FLStringFormatterTests.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatterTests.h"

@interface FLTestWhitespace : FLRepeatingCharTabWhitespace
@end

@implementation FLTestWhitespace

- (id) initWithEOL:(NSString*) eol {
    return [super initWithEOL:eol tabChar:@"." tabCharRepeatCount:4];
}

+ (id) testWhitespace {
    return FLAutorelease([[[self class] alloc] initWithEOL:FLWhitespaceDefaultEOL]);
}

@end

@implementation FLStringFormatterTests

- (id<FLStringFormatter>) createStringFormatter {
    return nil;
}

- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace {
    return nil;
}

- (void) testPrettyString1 {
    id<FLStringFormatter> stringFormatter = [self createStringFormatter];
    [stringFormatter appendString:@"hello world"];

    NSString* string = [[stringFormatter exportAttributedString] string];
    NSString* string2 = [stringFormatter exportString];

    FLEnsureNotNil(string);
    FLEnsureNotNil(string2);
    FLEnsureStringsAreEqual(string, string2);
    FLEnsureStringsAreEqual(string, @"hello world");

}

- (void) testPrettyStringLines {

    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"this\nis\na\ntest\n";

    NSString* exportedString = [string exportString];
    FLEnsureNotNil(exportedString);
    FLEnsureStringsAreEqual(result, exportedString);
}

- (void) testPrettyStringNoWhitespace {
    id<FLStringFormatter> string = [self createStringFormatter:[FLWhitespace compressedWhitespace]];

    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"thisisatest";

    NSString* exportedString = [string exportString];
    FLEnsureNotNil(exportedString);
    FLEnsureStringsAreEqual(result, exportedString);
}

- (void) testDefaultWhitespace {
    FLEnsure(   [FLWhitespace defaultWhitespace] ==
                [FLWhitespace tabbedWithSpacesWhitespace]);
}

- (void) testWhitespaceTabs {
    for(int i = 0; i < 5;i++) {
        NSString* tab = [[FLWhitespace defaultWhitespace] tabStringForScope:i];

        FLEnsure(tab.length == i * 4);
        for(int j = 0; j < tab.length; j++) {
            FLEnsure([tab characterAtIndex:j] == ' ');
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

- (void) testPrettyStringIndent1 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLEnsureStringsAreEqual(@"", [string exportString]);
    FLEnsure(string.indentLevel == 0);
    [string appendLine:@"foo"];
    [string indent];
    FLEnsure(string.indentLevel == 1);
    [string appendLine:@"hello"];
    [string indent];
    FLEnsure(string.indentLevel == 2);
    [string appendLine:@"world"];
    [string outdent];
    FLEnsure(string.indentLevel == 1);
    [string appendLine:@"bar"];
    [string outdent];
    FLEnsure(string.indentLevel == 0);
    [string appendLine:@"foobar"];

    NSString* file = [self loadTestFile:@"StringIndentTest.txt"
                                    fromBundle:nil];

    FLEnsureStringsAreEqual(file, [string exportString]);
}

- (void) testPrettyStringIndent2 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLEnsureStringsAreEqual(@"", [string exportString]);
    [string appendLine:@"foo"];
    FLEnsure(string.indentLevel == 0);

    [string indent:^{
        FLEnsure(string.indentLevel == 1);
        [string appendLine:@"hello"];

        [string indent:^{
            FLEnsure(string.indentLevel == 2);
            [string appendLine:@"world"];
        }];
        FLEnsure(string.indentLevel == 1);

        [string appendLine:@"bar"];
    }];

    [string appendLine:@"foobar"];
     FLEnsure(string.indentLevel == 0);

    NSString* file = [self loadTestFile:@"StringIndentTest.txt"
                                    fromBundle:nil];

    FLEnsureStringsAreEqual(file, [string exportString]);
}

- (void) testAppendString {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendString:@"Hello"];
    [string appendString:@" "];
    [string appendString:@"World"];
    FLEnsureStringsAreEqual([string exportString], @"Hello World");

    [string closeLine];
    FLEnsureStringsAreEqual([string exportString], @"Hello World\n");
}

- (void) testPrettyStringAppendBlankLine {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendBlankLine];
    [string appendBlankLine];
    [string appendBlankLine];

    FLEnsureStringsAreEqual(@"\n\n\n", [string exportString]);
}

- (void) testSimpleStringFormatterAppend {
    id<FLStringFormatter> string1 = [self createStringFormatter];
    [string1 appendLine:@"hello"];

    id<FLStringFormatter> string2 = [self createStringFormatter];
    [string2 appendLine:@"world"];

    [string1 appendStringFormatter:string2
                  withPreprocessor:[FLStringFormatterLineProprocessor instance]];

    FLEnsureStringsAreEqual([string1 exportString], @"hello\nworld\n");
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

        [string1 appendStringFormatter:string2 withPreprocessor:[FLStringFormatterLineProprocessor instance]];
    }];

    FLEnsureStringsAreEqual([string1 exportString], @"a\n....b\n....c\n........d\n");
}



@end
