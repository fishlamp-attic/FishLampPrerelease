//
//  FLStringFormatterTester.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestable.h"
#import "FLCoreFrameworkTest.h"

@interface FLStringFormatterTester : FLCoreFrameworkTest
- (id<FLStringFormatter>) createStringFormatter;
- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace;

- (NSString*) formattedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace;

- (NSAttributedString*) formattedAttributedString:(id) formatter
                                       whitespace:(FLWhitespace*) whitespace;

@end

@interface FLTestWhitespace : FLRepeatingCharTabWhitespace
+ (id) testWhitespace;
@end
