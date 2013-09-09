//
//  FLDocumentSection.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLPrettyString.h"

@interface FLDocumentSection : FLStringFormatter {
@private
    NSMutableArray* _lines;
    BOOL _needsLine;
}
+ (id) stringBuilder;

@property (readonly, strong, nonatomic) NSArray* lines;

- (void) appendStringFormatter:(id<FLStringFormatter>) stringBuilder;

- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;

@end


