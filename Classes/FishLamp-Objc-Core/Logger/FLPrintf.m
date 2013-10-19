//
//  FLPrintf.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPrintf.h"
#import "FLWhitespace.h"
#import "FishLampMinimum.h"

@implementation FLPrintfStringFormatter

FLSynthesizeSingleton(FLPrintfStringFormatter);

- (void) willAppendString:(NSString*) string {
    const char* c_str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    if(c_str) {
        printf("%s", c_str);
    }
}

- (void) willAppendAttributedString:(NSAttributedString*) string {
    [self willAppendString:[string string]];
}

@end
