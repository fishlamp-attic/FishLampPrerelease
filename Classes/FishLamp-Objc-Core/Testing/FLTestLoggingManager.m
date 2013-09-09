//
//  FLTestLoggingManager.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestLoggingManager.h"
#import "FLAssertions.h"

@implementation FLTestLoggingManager

FLSynthesizeSingleton(FLTestLoggingManager)

- (NSArray*) array {
    return _loggers;
}

- (id) init {	
	self = [super init];
	if(self) {
        _loggers = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_loggers release];
	[super dealloc];
}
#endif

- (void) addLogger:(id<FLStringFormatter>) formatter {
    FLAssertNotNil(formatter);
    [_loggers addObject:formatter];
}

- (void) pushLogger:(id<FLStringFormatter>) formatter {
    FLAssertNotNil(formatter);
    [_loggers insertObject:formatter atIndex:0];
}

- (void) popLogger {
    [_loggers removeObjectAtIndex:0];
}

- (id<FLStringFormatter>) logger {
    return [_loggers objectAtIndex:0];
}

- (void) appendBlankLine {
    [[self logger] appendBlankLine];
}

- (void) openLine {
    [[self logger] openLine];
}

- (void) closeLine {
    [[self logger] closeLine];
}

- (void) indent {
    [[self logger] indent];
}

- (void) outdent {
    [[self logger] outdent];
}

- (NSUInteger) length {
    return [[self logger] length];
}

- (void) appendSelfToStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) willAppendString:(NSString*) string {
    [[self logger] appendString:string];
}

- (void) willAppendAttributedString:(NSAttributedString*) string {
    [[self logger] appendAttributedString:string];
}

@end
