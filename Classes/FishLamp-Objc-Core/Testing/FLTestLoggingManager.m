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

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter {
    [[self logger] appendBlankLine];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    [[self logger] openLine];
}

- (BOOL) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    return [[self logger] closeLine];
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    [[self logger] indent];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    [[self logger] outdent];
}

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter {
    return [[self logger] indentLevel];
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    return [[self logger] length];
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) stringFormatter {
    [stringFormatter appendString:[self logger]];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {
    [[self logger] appendString:string];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
    [[self logger] appendString:attributedString];
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return [[self logger] formattedString];
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    return [[self logger] formattedAttributedString];
}


@end
