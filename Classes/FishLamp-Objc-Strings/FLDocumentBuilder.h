//
//  FLScopeStringBuilder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLCocoaRequired.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLDocumentSection.h"
#import "FLPrettyString.h"
#import "FLStringDocument.h"

@interface FLDocumentBuilder : FLStringFormatter {
@private
    FLStringDocument* _document;
}
+ (id) documentBuilder;

@property (readonly, strong, nonatomic) FLStringDocument* document;
@property (readonly, strong, nonatomic) FLDocumentSection* openedSection;

- (void) openSection:(id<FLStringFormatter>) element;
- (void) closeSection;

- (void) closeAllSections;

- (NSString*) buildString;
- (NSString*) buildStringWithWhitespace:(FLWhitespace*) whitespace;
- (NSString*) buildStringWithNoWhitespace;

@end

