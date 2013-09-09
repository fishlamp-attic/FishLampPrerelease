//
//  FLCancellableAsyncQueue.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCancellableAsyncQueue.h"
#import "FLOperation.h"

@implementation FLCancellableAsyncQueue

+ (id) cancellableAsyncQueue:(id<FLAsyncQueue>) nextQueue {
    return FLAutorelease([[[self class] alloc] initWithNextQueue:nextQueue]);
}

- (id) initWithNextQueue:(id<FLAsyncQueue>) nextQueue {
	self = [super initWithNextQueue:nextQueue];
	if(self) {
		_operations = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_operations release];
	[super dealloc];
}
#endif

- (FLPromise*) queueObject:(id) object
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil {

    if([object respondsToSelector:@selector(requestCancel)] &&
        [object respondsToSelector:@selector(addListener:)]) {
        @synchronized(self) {
            [_operations addObject:object];
            [[((id)object) listeners] addListener:self];
        }
    }

    return [super queueObject:object withDelay:delay completion:completionOrNil];
}

- (void) requestCancel {
    NSArray* list = nil;
    @synchronized(self) {
        list = FLCopyWithAutorelease(_operations);
    }
    for(id obj in list) {
        [obj requestCancel];
    }
}

- (void) operationDidFinish:(id) operation withResult:(FLPromisedResult) result {
    [[operation listeners] removeListener:self];
    @synchronized(self) {
        [_operations removeObject:operation];
    }
}


@end
