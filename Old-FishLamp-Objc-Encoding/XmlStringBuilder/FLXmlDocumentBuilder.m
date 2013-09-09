//
//	FLXmlDocumentBuilder.m
//	FishLamp
//
//	Created by Mike Fullerton on 6/11/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLXmlDocumentBuilder.h"
#import "FLStringUtils.h"
#import "FLStringToObjectConversionManager.h"
#import "FLXmlElement.h"
#import "FLObjectDescriber.h"
#import "FLXmlElement.h"

#define EOL @"\r\n"

@interface FLXmlDocumentBuilder ()
 
@end

@implementation FLXmlDocumentBuilder

@synthesize dataEncoder = _dataEncoder;

FLSynthesizeLazyGetter(dateEncoder, FLStringToObjectConversionManager*, _dataEncoder, FLStringToObjectConversionManager);

- (id) init {
    self = [super init];
    if(self) {
        [self openDocument];
    }
    return self;
}

+ (FLXmlDocumentBuilder*) xmlStringBuilder {
	return FLAutorelease([[[self class] alloc] init]);
}

- (void) openDocument {
}
#if FL_MRC
- (void) dealloc {
    [_dataEncoder release];
    [super dealloc];
}
#endif

-(void) appendXmlVersionHeader:(NSString*) version 
               andEncodingHeader:(NSString*) encoding
               standalone:(BOOL) standalone {
    
    [self appendLineWithFormat:@"<?xml version=\"%@\" encoding=\"%@\" standalone=\"%@\"?>", version, encoding, standalone ? @"yes" : @"no"];
}

- (void) appendDefaultXmlHeader {
    [self appendXmlVersionHeader:FLXmlVersion1_0 andEncodingHeader:FLXmlEncodingUtf8 standalone:YES];
}

- (void) openElement:(FLXmlElement*) element {
    [self openSection:element];
}

- (void) addElement:(FLXmlElement*) element {
    [self appendStringFormatter:element];
}

- (void) closeElement {
    [self closeSection];
}

- (id) openedElement {
    return [self openedSection];
}


@end



