//
//  FLEventForwarder.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLRetainedObject.h"

@interface FLEventForwarder : NSProxy {
@private
    id _targetObject;
}
@property (readonly, strong) id targetObject;
@end

@interface FLUnhandledEventForwarder : FLEventForwarder

@end