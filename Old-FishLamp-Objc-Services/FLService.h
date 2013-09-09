//
//  FLService.h
//  FLCore
//
//  Created by Mike Fullerton on 11/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLAsyncMessageBroadcaster.h"
#import "FishLampAsync.h"

extern NSString* const FLServiceDidCloseNotificationKey;
extern NSString* const FLServiceDidOpenNotificationKey;

@protocol FLService <NSObject, FLAsyncMessageBroadcaster>
@property (readonly, assign) BOOL isOpen;
- (FLPromise*) openService:(fl_result_block_t) completion;
- (FLPromise*) closeService:(fl_result_block_t) completion;
@end

@interface FLService : FLAsyncMessageBroadcaster<FLService> {
@private
    BOOL _isOpen;
    NSError* _error;
}

@property (readonly, strong) NSError* error;

// override these
- (void) openSelf:(FLFinisher*) finisher;
- (void) closeSelf:(FLFinisher*) finisher;
@end


