//
//  FLCharString.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCharString.h"

@implementation NSString (FLCharString)

- (id) initWithCharString:(FLCharString) charString {
    if(charString.length == 0) {
        return nil;
    }

    return [self initWithBytes:charString.string length:charString.length encoding:NSASCIIStringEncoding];
}

+ (NSString*) stringWithCharString:(FLCharString) charString {
    return FLAutorelease([[[self class] alloc] initWithCharString:charString]);

}
@end