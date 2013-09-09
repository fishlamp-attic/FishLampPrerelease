//
//	FLSoapStringBuilder.h
//	FishLamp
//
//	Created By Mike Fullerton on 4/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"
#import "FishLampMinimum.h"

#import "FLXmlDocumentBuilder.h"
#import "FLObjectXmlElement.h"

@interface FLSoapStringBuilder : FLXmlDocumentBuilder {
@private
    FLXmlElement* _envelopeElement;
    FLXmlElement* _bodyElement;
}

+ (id) soapStringBuilder;

@end

@interface FLObjectXmlElement (Soap)

+ (id) soapXmlElementWithObject:(id) object                 
                  xmlElementTag:(NSString*) functionName 
                   xmlNamespace:(NSString*) xmlNamespace;

- (void) addSoapParameter:(NSString*) name 
                    value:(NSString*) value;

- (void) addSoapParameters:(NSDictionary*) parameters;

@end

