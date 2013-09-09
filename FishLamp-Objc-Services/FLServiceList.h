//
//  FLServiceList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLService.h"


@interface FLServiceList : FLAsyncMessageBroadcaster<FLService, NSFastEnumeration> {
@private
    NSMutableArray* _services;
    BOOL _isOpen;
}

+ (id) serviceList;

@property (readonly, strong) NSArray* services;

- (void) addService:(id<FLService>) service;
- (void) removeService:(id<FLService>) service;

- (void) removeAllServices;

@end

@interface FLServiceList (OptionalOverrides)
- (void) willOpen;
- (void) didOpenWithResult:(FLPromisedResult) result;

- (void) didClose;
- (void) didCloseWithResult:(FLPromisedResult) result;
@end
