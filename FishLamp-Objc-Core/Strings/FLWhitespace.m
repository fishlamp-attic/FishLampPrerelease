//
//  FLWhitespace.m
//  FLCore
//
//  Created by Mike Fullerton on 5/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLWhitespace.h"
#import "FLAssertions.h"

@interface FLWhitespace ()
@property (readwrite, strong, nonatomic) NSString* eolString;
@property (readwrite, strong, nonatomic) NSString* tabString; 
@end

@implementation FLWhitespace

@synthesize eolString = _eolString;
@synthesize tabString = _tabString;

- (id) initWithEOL:(NSString*) eol tab:(NSString*) tab {
    self = [super init];
    if(self) {
        self.eolString = eol == nil ? @"" : eol;
        self.tabString = tab == nil ? @"" : tab;
        memset(_cachedTabs, 0, sizeof(NSString*) * FLWhitespaceMaxIndent); 
    }
    return self;
}

+ (id) whitespace:(NSString*) eol tab:(NSString*) tab {
    return FLAutorelease([[[self class] alloc] initWithEOL:eol tab:tab]);
}

+ (FLWhitespace*) whitespace {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    for(int i = 0; i < FLWhitespaceMaxIndent; i++) {
        if(_cachedTabs[i]) {
            FLRelease(_cachedTabs[i]);
        }
    }
    [_eolString release];
    [_tabString release];
    [super dealloc];
}
#endif

- (NSString*) tabStringForScope:(NSUInteger) indent {
    FLAssertWithComment(indent < FLWhitespaceMaxIndent, @"too many indents");
    
    if( indent > 0 && 
        _tabString && 
        _tabString.length && 
        indent < FLWhitespaceMaxIndent) {
    
        if(!_cachedTabs[indent]) {
            _cachedTabs[indent] = FLRetain([@"" stringByPaddingToLength:(indent * _tabString.length) 
                                                             withString:_tabString startingAtIndex:0]);
        }
        return _cachedTabs[indent];
    }
    
    return @"";
}

+ (FLWhitespace*) tabbedWithSpacesWhitespace {
     FLReturnStaticObject(
        [[FLWhitespace alloc] initWithEOL:FLWhitespaceDefaultEOL tab:FLWhitespaceDefaultTabString];
     );
}

+ (FLWhitespace*) compressedWhitespace {
    return nil;
    
//    FLReturnStaticObject(
//        [[FLWhitespace alloc] initWithEOL:nil tab:nil];
//    );
}

+ (id) untabbedWhitespace {
    FLReturnStaticObject(
        [[FLWhitespace alloc] initWithEOL:FLWhitespaceDefaultEOL tab:nil];
    );
}

+ (FLWhitespace*) defaultWhitespace {
    return [FLWhitespace tabbedWithSpacesWhitespace];
}


//- (void) appendEol:(NSMutableString*) toString {
//    if(FLStringIsNotEmpty(_eolString)) {
//        [toString appendString:_eolString];
//    }
//}
//
//- (void) appendTabs:(NSUInteger) count toString:(NSMutableString*) toString {
//    
//    NSString* tabs = [self tabStringForScope:count];
//    if(FLStringIsNotEmpty(tabs)) {
//        [toString appendString:tabs];
//    }
//    
//}
//
//- (void) appendEolAndTabs:(NSUInteger) tabIndent 
//                 toString:(NSMutableString*) toString {
//                 
//    [self appendEol:toString];
//    [self appendTabs:tabIndent toString:toString];
//}
//
//- (void) appendWhitespaceToPrettyString:(FLPrettyString*) string {
//
//    if(FLStringIsNotEmpty(_eolString)) {
//        [string appendString:_eolString];
//    }
//    if(string.indentCount) {
//        NSString* tabs = [self tabStringForScope:string.indentCount];
//        if(FLStringIsNotEmpty(tabs)) {
//            [string appendString:tabs];
//        }
//    }
//}




@end

