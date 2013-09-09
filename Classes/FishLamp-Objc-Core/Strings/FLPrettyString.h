//
//  FLPrettyString.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCoreRequired.h"
#import "FLWhitespaceStringFormatter.h"

@class FLWhitespace;
@protocol FLPrettyStringDelegate;

@interface FLPrettyString : FLWhitespaceStringFormatter {
@private
    NSMutableString* _string;
    __unsafe_unretained id<FLPrettyStringDelegate> _delegate;
}
@property (readwrite, assign, nonatomic) id<FLPrettyStringDelegate> delegate;

@property (readonly, strong, nonatomic) NSString* string;

+ (id) prettyString:(FLWhitespace*) whiteSpace;
+ (id) prettyString; // uses default whitespace

+ (id) prettyStringWithString:(NSString*) string;

- (void) deleteAllCharacters;

@end

@protocol FLPrettyStringDelegate <NSObject>
@optional
- (void) prettyString:(FLPrettyString*) prettyString didAppendString:(NSString*) string;
@end


@interface NSObject (FLStringFormatter)
// override this one
- (void) describeSelf:(FLPrettyString*) string;

// call this one
- (void) prettyDescription:(FLPrettyString*) string;

- (NSString*) prettyDescription;
@end




