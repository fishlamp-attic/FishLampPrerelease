//
//  FLStringBuilderContents.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLDocumentSection.h"
#import "FLPrettyString.h"

@interface FLStringDocument : NSObject {
@private
    NSMutableArray* _stack;
}

@property (readonly, strong, nonatomic) NSArray* openedStringBuilders;

@property (readonly, strong, nonatomic) id<FLStringFormatter> rootStringBuilder;

@property (readonly, strong, nonatomic) id<FLStringFormatter> openedStringBuilder;

@property (readonly, assign, nonatomic) NSUInteger length;

- (void) appendStringFormatter:(id<FLStringFormatter>) stringBuilder;

- (void) openStringBuilder:(id<FLStringFormatter>) stringBuilder;

- (id<FLStringFormatter>) closeStringBuilder;

- (void) closeAllStringBuilders;

- (void) deleteAllStringBuilders;

@end


