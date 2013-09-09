//
//	FLXmlDocumentBuilder.h
//	FishLamp
//
//	Created by Mike Fullerton on 6/11/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDocumentBuilder.h"

// xml
#define FLXmlVersion1_0                         @"1.0"
#define FLXmlEncodingUtf8                       @"utf-8"
#define FMXmlEncodingUtf16                      @"UTF-16"

@class FLXmlElement;
@class FLStringToObjectConversionManager;

@interface FLXmlDocumentBuilder : FLDocumentBuilder {
@private
    FLStringToObjectConversionManager* _dataEncoder;
}
@property (readwrite, strong, nonatomic) FLStringToObjectConversionManager* dataEncoder;

@property (readonly, strong, nonatomic) id openedElement;

+ (FLXmlDocumentBuilder*) xmlStringBuilder;

- (void) openElement:(FLXmlElement*) element;

- (void) addElement:(FLXmlElement*) element;

- (void) closeElement;

- (void) appendXmlVersionHeader:(NSString*) version 
                   andEncodingHeader:(NSString*) encoding
                          standalone:(BOOL) standalone;

- (void) appendDefaultXmlHeader; 

- (void) openDocument;

@end

