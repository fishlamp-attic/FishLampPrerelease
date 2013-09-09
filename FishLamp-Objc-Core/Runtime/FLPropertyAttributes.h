//
//  FLPropertyAttributes.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Foundation/Foundation.h>

#import "FLCharString.h"

#ifndef FLPropertyAttributesBufferSize
#define FLPropertyAttributesBufferSize 256
#endif

typedef struct {
    char encodedAttributes[FLPropertyAttributesBufferSize];
    char propertyName[FLPropertyAttributesBufferSize];

    // these are pointers into the various strings
    FLCharString className;
    FLCharString structName;
    FLCharString customGetter;
    FLCharString customSetter;
    FLCharString ivar;
    FLCharString selector;
    FLCharString unionName;
    
    unsigned int is_object: 1;
    unsigned int is_array: 1;
    unsigned int is_union: 1;
    unsigned int is_number: 1;
    unsigned int is_bool_number: 1;
    unsigned int is_float_number: 1;
    unsigned int retain:1;
    unsigned int readonly: 1;
    unsigned int copy: 1;
    unsigned int weak: 1;
    unsigned int nonatomic: 1;
    unsigned int dynamic: 1;
    unsigned int eligible_for_gc : 1;
    unsigned int indirect_count:8;
    unsigned int is_pointer:1;
    char type; // see runtime.h
} FLPropertyAttributes_t;

extern FLPropertyAttributes_t FLPropertyAttributesParse(objc_property_t property);
