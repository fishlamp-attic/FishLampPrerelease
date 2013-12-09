//
//  FLStashedCallback.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCallback.h"

@interface FLStashedCallback : FLCallback<FLAsyncWorker> {
@private
    FLArgumentList* _arguments;
}

@property (readonly, strong, nonatomic) FLArgumentList* arguments;

- (id) initWithTarget:(id) target action:(SEL) action arguments:(FLArgumentList*) arguments;
- (id) initWithBlock:(FLCallbackBlock) block arguments:(FLArgumentList*) arguments;

+ (id) callbackWithTarget:(id) target action:(SEL) action arguments:(FLArgumentList*) arguments;
+ (id) callbackWithBlock:(FLCallbackBlock) block arguments:(FLArgumentList*) arguments;

@end
