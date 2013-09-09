//
//  FLXmlCommentElement.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLXmlComment.h"

@implementation FLXmlComment

+ (id) xmlComment {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter {

    BOOL hasLines = self.lines.count > 0;
    if(hasLines) {
        [stringFormatter appendLine:@"<--"];

        [stringFormatter indent:^{
            [super appendSelfToStringFormatter:stringFormatter];
        }];
        
        [stringFormatter appendLine:@"-->"];
    }
    
}                           

@end


