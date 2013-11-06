//
//  FLOperationContract.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@protocol FLOperationContract <NSObject>
- (BOOL) objectFufillsContract:(id) object;
@end

@interface FLOperationContract : NSObject<FLOperationContract> {
@private
    Protocol* _protocol;
}

+ (id) operationContractWithProtocol:(Protocol*) protocol;


@end
