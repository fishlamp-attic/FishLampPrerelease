//
//  FLOperationQueueOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperationQueueOperation.h"
#import "FLOperationQueue.h"

@implementation FLOperationQueueOperation

@synthesize operationQueue = _operationQueue;

- (id) initWithOperationQueue:(FLOperationQueue*) operationQueue {
    self = [super init];
    if(self) {
        _operationQueue = FLRetain(operationQueue);
        [_operationQueue.listeners addListener:self];
    }

    return self;
}

#if FL_MRC
- (void)dealloc {
	[_operationQueue release];
	[super dealloc];
}
#endif

+ (id) operationQueueOperation:(FLOperationQueue*) operationQueue {
    return FLAutorelease([[[self class] alloc] initWithOperationQueue:operationQueue]);
}

- (void) startOperation {

}


@end
