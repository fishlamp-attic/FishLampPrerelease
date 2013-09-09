//
//  FLCharString.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

typedef struct {
    const char* string;
    NSUInteger length;
} FLCharString;

NS_INLINE
FLCharString FLCharStringFromCString(const char* string, char stopChar) {
    FLCharString charString = { string, 0 };
    while(*string && *string++ != stopChar) {
        charString.length++;
    }
    return charString;
}

NS_INLINE 
const char* FLCStringCopyWithLength(const char* str, int len) {
    char* copy = malloc(len + 1);
    memcpy(copy, str, len);
    copy[len] = 0;
    return copy;
}

NS_INLINE 
const char* FLCStringCopy(const char* str) {
    return FLCStringCopyWithLength(str, strlen(str));
}

NS_INLINE
const char* FLCStringCopyCharString(FLCharString charString) {
    return FLCStringCopyWithLength(charString.string, charString.length);
}


@interface NSString (FLCharString)
- (id) initWithCharString:(FLCharString) charString;
+ (NSString*) stringWithCharString:(FLCharString) charString;
@end