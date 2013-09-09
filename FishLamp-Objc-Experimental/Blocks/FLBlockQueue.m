//
//  FLBlockQueue.m
//  FishLamp
//
//  Created by Mike Fullerton on 8/13/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBlockQueue.h"

@interface FLBlockQueue ()
@property (readwrite, strong, nonatomic) NSArray* blockQueue;
@end

@implementation FLBlockQueue

@synthesize blockQueue = _blockQueue;

- (id) init {
    if((self = [super init])) {
        _blockQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_blockQueue release];
    [super dealloc];
}
#endif

- (NSUInteger) count {
    return _blockQueue.count;
}

- (void) addBlock:(FLQueuedBlock) block {
    [_blockQueue addObject:FLCopyWithAutorelease(block)];
}

- (void) executeBlocks:(id) sender {
    for(FLQueuedBlock block in _blockQueue) {
        block(sender);
    }
}

- (void) removeAllBlocks {
    [_blockQueue removeAllObjects];
}

+ (FLBlockQueue*) blockQueue {
    return FLAutorelease([[FLBlockQueue alloc] init]);
}

@end
