//
//  FLScopeStringBuilder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLDocumentSection.h"

@interface FLStringBuilder : FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _stack;
}

+ (id) stringBuilder;

@property (readonly, strong, nonatomic) id<FLStringFormatter> openedSection;

- (void) openSection:(id<FLStringFormatter>) element;
- (void) closeSection;

- (void) closeAllSections;

- (NSString*) buildString;
- (NSString*) buildStringWithWhitespace:(FLWhitespace*) whitespace;
- (NSString*) buildStringWithNoWhitespace;

@end

