//
//  FLOperationQueueOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperation.h"
@class FLOperationQueue;

@interface FLOperationQueueOperation : FLOperation {
@private
    FLOperationQueue* _operationQueue;
}
@property (readonly, strong) FLOperationQueue* operationQueue;

- (id) initWithOperationQueue:(FLOperationQueue*) operationQueue;
+ (id) operationQueueOperation:(FLOperationQueue*) operationQueue;

@end
