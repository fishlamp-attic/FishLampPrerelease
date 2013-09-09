//
//  FLHttpAuthenticatorAsyncQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncQueueDecorator.h"
@protocol FLHttpRequestAuthenticator; 
@class FLFifoAsyncQueue;

@interface FLHttpAuthenticatorAsyncQueue : FLAsyncQueueDecorator {
@private
    FLFifoAsyncQueue* _asyncQueue;
    id<FLHttpRequestAuthenticator> _authenticator;
}

+ (id) httpAuthenticatorAsyncQueue:(id<FLHttpRequestAuthenticator>) authenticator;

+ (id) httpAuthenticatorAsyncQueue:(id<FLHttpRequestAuthenticator>) authenticator
                     withNextQueue:(id<FLAsyncQueue>) nextQueue;

@end

