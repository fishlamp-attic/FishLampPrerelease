//
//  FLAssert.m
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAssert.h"
#import "FLExceptions.h"
#import "FLAssertions.h"

id _FLAssertIsClass(id object, Class aClass) {
    if(object) {
        FLAssertNotNilWithComment(aClass, @"class for %@ is nil", NSStringFromClass(aClass));
        FLAssertWithComment([object isKindOfClass:aClass], 
            @"expecting type of %@ but got %@", 
            NSStringFromClass(aClass), 
            NSStringFromClass([object class]));
    }
    return object;
}

id _FLAssertConformsToProtocol(id object, Protocol* proto) {
    if(object) {
        FLAssertWithComment([object conformsToProtocol:proto], @"expecting object to implement protocol: %@", NSStringFromProtocol(proto));
    }
    return object;
}

#if DEPRECATED
    #define FLAssertIsTrue                 FLConfirmIsTrue
    #define FLAssertIsTrueWithComment                FLConfirmIsTrueWithComment
    #define FLAssertIsFalse                FLConfirmIsFalse
    #define FLAssertIsFalseWithComment               FLConfirmIsFalseWithComment
    #define FLAssertIsYes                  FLConfirmIsYes
    #define FLAssertIsYesWithComment                 FLConfirmIsYesWithComment
    #define FLAssertIsNo                   FLConfirmIsNo
    #define FLAssertIsNoWithComment                  FLConfirmIsNoWithComment
    #define FLAssertAreEqual               FLConfirmAreEqual
    #define FLAssertAreEqualWithComment              FLConfirmAreEqualWithComment
    #define FLAssertAreNotEqual            FLConfirmAreNotEqual
    #define FLAssertAreNotEqualWithComment           FLConfirmAreNotEqualWithComment
    #define FLAssertObjectsAreEqual        FLConfirmObjectsAreEqual
    #define FLAssertObjectsAreEqualWithComment       FLConfirmObjectsAreEqualWithComment
    #define FLAssertObjectsAreNotEqual     FLConfirmObjectsAreNotEqual
    #define FLAssertObjectsAreNotEqualWithComment    FLConfirmObjectsAreNotEqualWithComment
    #define FLAssertIsKindOfClass          FLConfirmIsKindOfClass
    #define FLAssertIsKindOfClassWithComment         FLConfirmIsKindOfClassWithComment
    #define FLAssertIsImplemented          FLConfirmIsImplemented
    #define FLAssertIsImplementedWithComment         FLConfirmIsImplementedWithComment
    #define FLAssertIsFixed                FLConfirmIsFixed
    #define FLAssertIsFixedWithComment               FLConfirmIsFixedWithComment
    #define FLAssertIsBug                  FLConfirmIsBug
    #define FLAssertIsBugWithComment                 FLConfirmIsBugWithComment
    #define FLAssertIsOverridden           FLConfirmIsOverridden 
    #define FLAssertIsOverriddenWithComment          FLConfirmIsOverriddenWithComment


    #define FLAssertDefaultInitNotCalledWithComment(__FORMAT__, ...) \
                - (id) init { \
                    FLAssertFailedWithComment(@"unsupported call to default init: %@", FLStringWithFormatOrNil(__FORMAT__, ##__VA_ARGS__)); \
                    return self; \
                }

    #define FLAssertDefaultInitNotCalled() \
                - (id) init { \
                    FLAssertFailedWithComment(@"unsupported call to default init"); \
                    return self; \
                }

    extern id _FLAssertIsClass(id object, Class class);
    extern id _FLAssertConformsToProtocol(id object, Protocol* proto);

    #define FLAssertIsClass(__OBJ__, __CLASS__) \
        _FLAssertIsClass(__OBJ__, __CLASS__)

    #define FLAssertConformsToProtocol(__OBJ__, __PROTOCOL__) \
        _FLAssertConformsToProtocol(__OBJ__, NSProtocolFromString(@#__PROTOCOL__))


    #define FLAssertIsImplemented() 
    #define FLAssertIsImplementedWithComment(...) 
    #define FLAssertIsFixed() 
    #define FLAssertIsFixedWithComment(...) 
    #define FLAssertIsBug() 
    #define FLAssertIsBugWithComment(...) 
    #define FLAssertIsOverridden() 
    #define FLAssertIsOverriddenWithComment(...) 

    #define FLAssertDefaultInitNotCalledWithComment(__FORMAT__, ...)
    #define FLAssertDefaultInitNotCalled()

    #define FLFixMe_ FLAssertIsFixed
    #define FLFixMeWithComment FLAssertIsFixedWithComment

    #define FLAssertObjectIsType(__OBJ__, __TYPE__) __OBJ__
    #define FLAssertConformsToProtocol(__OBJ__, __PROTOCOL__) __OBJ__

    #define FLAssertIsTrue(...) 
    #define FLAssertIsTrueWithComment(...) 
    #define FLAssertIsFalse(...) 
    #define FLAssertIsFalseWithComment(...) 
    #define FLAssertIsYes(...) 
    #define FLAssertIsYesWithComment(...) 
    #define FLAssertIsNo(...) 
    #define FLAssertIsNoWithComment(...) 
    #define FLAssertAreEqual(...) 
    #define FLAssertAreEqualWithComment(...) 
    #define FLAssertAreNotEqual(...) 
    #define FLAssertAreNotEqualWithComment(...) 
    #define FLAssertObjectsAreEqual(...) 
    #define FLAssertObjectsAreEqualWithComment(...) 
    #define FLAssertObjectsAreNotEqual(...) 
    #define FLAssertObjectsAreNotEqualWithComment(...) 


#endif

