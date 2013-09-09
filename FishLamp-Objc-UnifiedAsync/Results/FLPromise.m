//
//  FLPromise.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPromise.h"
#import "NSError+FLFailedResult.h"

@interface FLPromise ()
@property (readwrite, strong) FLPromisedResult result;
@property (readwrite, strong) FLPromise* nextPromise;
@property (readwrite, assign, getter=isFinished) BOOL finished;
@property (readwrite, copy) fl_completion_block_t completion;
@end

@implementation FLPromise

@synthesize nextPromise = _nextPromise;
@synthesize result = _result;
@synthesize finished = _finished;
@synthesize completion = _completion;

- (id) initWithCompletion:(fl_completion_block_t) completion {
    
    self = [super init];
    if(self) {
        self.completion = completion;
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (id) initWithTarget:(id) target action:(SEL) action {
    self = [self initWithCompletion:nil];
    if(self) {
        _target = target;
        _action = action;
    }
    return self;
}

+ (id) promise:(id) target action:(SEL) action {
    return FLAutorelease([[[self class] alloc] initWithTarget:target action:action]);
}

- (id) init {
    return [self initWithCompletion:nil];
}

- (void) dealloc {
    if(_semaphore) {
        dispatch_release(_semaphore);
    }
    
#if FL_MRC
    [_nextPromise release];
    [_completion release];
    [_result release];
    [super dealloc];
#endif
}

+ (id) promise {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) promise:(fl_completion_block_t) completion {
    return FLAutorelease([[[self class] alloc] initWithCompletion:completion]);
}

- (FLPromisedResult) waitUntilFinished {
    
    FLRetainObject(self);
    
    @try {
        if([NSThread isMainThread]) {
        // this may not work in all cases - e.g. some iOS apis expect to be called in the main thread
        // and this will cause endless blocking, unfortunately. I've seen this is the AssetLibrary sdk.
            while(!self.isFinished) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
            }
        } 
        else {
//            FLLog(@"waiting for semaphor for %X, thread %@", (void*) _semaphore, [NSThread currentThread]);
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//            FLLog(@"finished waiting for %X", (void*) _semaphore);
        } 
    }
    @finally {
        FLAutoreleaseObject(self);
    }   

    FLAssertNotNilWithComment(self.result, @"result should not be nil!!");

    return self.result;
}

- (void) setFinishedWithResult:(FLPromisedResult) result {
    
    FLAssertIsNilWithComment(self.result, @"already finished");

    if(result == nil) {
       result = [NSError failedResultError];
    }

    self.result = result;

    if(_completion) {
        _completion(self.result);
        FLReleaseBlockWithNil(_completion);
    }

    FLPerformSelector1(_target, _action, self.result);
    _target = nil;
    _action = nil;

    self.finished = YES;

    if(_semaphore) {
    //       FLLog(@"releasing semaphor for %X, ont thread %@", (void*) _semaphore, [NSThread currentThread]);
        dispatch_semaphore_signal(_semaphore);
        dispatch_release(_semaphore);
        _semaphore = nil;
    }
}



@end