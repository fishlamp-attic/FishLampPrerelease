//
//  FLDocumentTests.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/20/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringBuilderTester.h"
#import "FLStringBuilder.h"

@implementation FLStringBuilderTester

+ (FLTestGroup*) testGroup {
    FLReturnStaticObject( [[FLTestGroup alloc] initWithGroupName:@"String Document Tests" priority:FLTestPriorityFramework]);
}

- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace {
    return [FLStringBuilder stringBuilder];
}

- (id<FLStringFormatter>) createStringFormatter {
    return [FLStringBuilder stringBuilder];
}

- (NSString*) formattedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace {

    NSString* theString = [formatter buildStringWithWhitespace:whitespace];
    return theString;
}

- (NSAttributedString*) formattedAttributedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace {

    NSAttributedString* string = [[NSAttributedString alloc] initWithString:[self formattedString:formatter whitespace:whitespace]];

    return FLAutorelease(string);
}

//- (NSString*) disableAll {
//    return @"Tests don't work with formtter tests";
//}

@end
