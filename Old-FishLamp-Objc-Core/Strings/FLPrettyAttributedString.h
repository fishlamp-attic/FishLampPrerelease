//
//  FLPrettyAttributedString.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWhitespaceStringFormatter.h"

@protocol FLPrettyAttributedStringDelegate;

@interface FLPrettyAttributedString : FLWhitespaceStringFormatter {
@private
    NSMutableAttributedString* _attributedString;
}

+ (id) prettyAttributedString:(FLWhitespace*) whitespace;
+ (id) prettyAttributedString;
+ (id) prettyAttributedStringWithString:(NSString*) string;

- (void) deleteAllCharacters;

@end


//@interface FLDeprecatedPrettyAttributedString : FLPrettyAttributedString {
//@private
//    id<FLPrettyAttributedStringDelegate> _delegate;
//}
//@property (readwrite, assign, nonatomic) id<FLPrettyAttributedStringDelegate> delegate;
//@end
//
//@protocol FLPrettyAttributedStringDelegate <NSObject>
//@optional
//
//- (NSAttributedString*) prettyString:(FLPrettyAttributedString*) prettyString
//          willAppendAttributedString:(NSAttributedString*) string;
//
//- (void) prettyString:(FLPrettyAttributedString*) prettyString
//didAppendAttributedString:(NSAttributedString*) string;
//@end
