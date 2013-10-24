//
//  FLStringPreprocessor.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringPreprocessor.h"

typedef void (^FLStringPreprocessorOutputBlock)(NSRange range);

@implementation FLStringFormatterLineProprocessor

FLSynthesizeSingleton(FLStringFormatterLineProprocessor);

- (void) processString:(NSString*) string
          eventHandler:(id<FLStringPreprocessorEventHandler>) eventHandler
          appendRange:(FLStringPreprocessorOutputBlock) appendRange
          outputAll:(dispatch_block_t) outputAll {

    NSRange range = { 0, 0 };

    for(NSUInteger i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        
        if(c == '\n') {
            if(range.length > 0) {
                appendRange(range);
            }

            [eventHandler stringPreprocessorDidFindEOL:self];

            range.location = i+1;
            range.length = 0;
            
            continue;
        }

        ++range.length;
    }
    
    if(range.length) {
        if(range.location > 0) {
            appendRange(range);
        }
        else {
            outputAll();
        }
    }
}

- (void) processString:(NSString*) string
          eventHandler:(id<FLStringPreprocessorEventHandler>) eventHandler {

    [self processString:string
           eventHandler:eventHandler
            appendRange:^(NSRange range) {
                [eventHandler stringPreprocessor:self
                                   didFindString:[string substringWithRange:range]];
            }
            outputAll:^{
                [eventHandler stringPreprocessor:self
                                   didFindString:string];
            }
    ];
}

- (void) processAttributedString:(NSAttributedString*) attributedString
                    eventHandler:(id<FLStringPreprocessorEventHandler>) eventHandler {

    [self processString:attributedString.string
           eventHandler:eventHandler
            appendRange:^(NSRange range) {
                [eventHandler stringPreprocessor:self
                         didFindAttributedString:[attributedString attributedSubstringFromRange:range]];
            }
            outputAll:^{
                [eventHandler stringPreprocessor:self
                         didFindAttributedString:attributedString];
            }
    ];
}
@end
