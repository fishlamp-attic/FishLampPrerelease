//
//  FLDocumentSection.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLPrettyString.h"
#import "FLWhitespaceStringFormatter.h"

@interface FLDocumentSection : FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _lines;
    BOOL _needsLine;
    NSInteger _indentLevel;
}
+ (id) stringBuilder;

@property (readonly, strong, nonatomic) NSArray* lines;

- (void) appendStringFormatter:(id<FLStringFormatter>) stringBuilder;

- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;

@end


