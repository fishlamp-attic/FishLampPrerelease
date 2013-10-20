//
//  FLCodeChunk.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeChunk.h"

@implementation FLCodeChunk

@synthesize openScopeString = _openScopeString;
@synthesize closeScopeString = _closeScopeString;

+ (id) codeChunk {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_openScopeString release];
    [_closeScopeString release];
    [super dealloc];
}
#endif

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter
                    withPreprocessor:(id<FLStringFormatterProprocessor>) preprocessor  {

    if(FLStringIsNotEmpty(_openScopeString)) {
        [anotherStringFormatter appendLine:_openScopeString];
        [anotherStringFormatter indent:^{
            [super appendSelfToStringFormatter:anotherStringFormatter withPreprocessor:preprocessor];
        }];
        
        if(FLStringIsNotEmpty(_closeScopeString)) {
            [anotherStringFormatter appendLine:_closeScopeString];
        }
    }
    else {
        [super appendSelfToStringFormatter:anotherStringFormatter  withPreprocessor:preprocessor];
    }
}

@end