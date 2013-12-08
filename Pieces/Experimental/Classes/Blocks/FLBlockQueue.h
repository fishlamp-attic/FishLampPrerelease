//
//  FLBlockQueue.h
//  FishLamp
//
//  Created by Mike Fullerton on 8/13/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

typedef void (^FLQueuedBlock)(id sender);

@interface FLBlockQueue : NSObject {
@private
    NSMutableArray* _blockQueue;
}
@property (readonly, assign, nonatomic) NSUInteger count;

+ (FLBlockQueue*) blockQueue;

- (void) addBlock:(FLQueuedBlock) block;

- (void) removeAllBlocks;

- (void) executeBlocks:(id) sender;

@end
