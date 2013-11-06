//
//  FLOperationContract.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperationContract.h"

#import "FLObjcRuntime.h"

@implementation FLOperationContract

- (id) initWithProtocol:(Protocol*) protocol {
	self = [super init];
	if(self) {
		_protocol = protocol;
	}
	return self;
}

+ (id) operationContractWithProtocol:(Protocol*) protocol {
    return FLAutorelease([[[self class] alloc] initWithProtocol:protocol]);
}

- (BOOL) objectFufillsContract:(id) object {
    if(FLClassConformsToProtocol([object class], _protocol)) {
        return YES;
    }
    
    return NO;
}

@end
