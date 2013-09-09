//
//  FLFinisher.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"
#import "FLFinishable.h"

@protocol FLFinisherDelegate;
@class FLPromise;

@interface FLFinisher : NSObject<FLFinishable> {
@private
    FLPromise* _firstPromise;
#if DEBUG
    NSTimeInterval _birth;
#endif
}

@property (readonly, assign) BOOL willFinish;
@property (readonly, strong) FLPromise* firstPromise;

+ (id) finisher;
+ (id) finisherWithBlock:(fl_completion_block_t) completion;
+ (id) finisherWithTarget:(id) target action:(SEL) action;
+ (id) finisherWithPromise:(FLPromise*) promise;

- (FLPromise*) addPromise;
- (FLPromise*) addPromiseWithBlock:(fl_completion_block_t) completion;
- (FLPromise*) addPromiseWithTarget:(id) target action:(SEL) action;

- (void) addPromise:(FLPromise*) promise;

@end

@interface FLFinisher (OptionalOverrides)
- (void) willFinishWithResult:(FLPromisedResult) result;
- (void) didFinishWithResult:(FLPromisedResult) result;
@end

@protocol FLFinisherDelegate <NSObject>
- (void) finisherDidFinish:(FLFinisher*) finisher
                withResult:(FLPromisedResult) resultOrNil;
@end

@interface FLForegroundFinisher : FLFinisher
@end