//
//  FLStringBuilderSection.h
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

@interface FLStringBuilderSection : FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _lines;
    BOOL _needsLine;
    BOOL _lineOpen;

    NSInteger _indentLevel;
    __unsafe_unretained FLStringBuilderSection* _parent;
}

+ (id) stringBuilder;

@property (readonly, assign, nonatomic) FLStringBuilderSection* parent;
@property (readonly, strong, nonatomic) NSArray* lines;

- (void) appendSection:(FLStringBuilderSection*) section;

// optional overrides
- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (void) didMoveToParent:(FLStringBuilderSection*) parent;

@end


