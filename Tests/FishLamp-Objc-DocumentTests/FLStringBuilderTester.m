//
//  FLDocumentTests.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/20/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringBuilderTester.h"
#import "FLStringBuilder.h"
#import "FLCoreTestGroup.h"

@interface FLStringBuilderTestGroup : FLTestGroup
@end

@implementation FLStringBuilderTestGroup

+ (void) specifyRunOrder:(id<FLTestableRunOrder>)runOrder {
    [runOrder orderClass:[self class] afterClass:[FLCoreTestGroup class]];
}
@end

@implementation FLStringBuilderTester

+ (Class) testGroupClass {
    return [FLStringBuilderTestGroup class];
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

- (void) willRunTestCases:(FLTestCaseList*) testCases {
//    [testCases disableAllTests:@"my name is fred"];
}


@end
