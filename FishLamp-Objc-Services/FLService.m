//
//  FLService.m
//  FLCore
//
//  Created by Mike Fullerton on 11/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLService.h"

NSString* const FLServiceDidCloseNotificationKey = @"FLServiceDidCloseNotificationKey";
NSString* const FLServiceDidOpenNotificationKey = @"FLServiceDidOpenNotificationKey";;

@interface FLService ()
@property (readwrite, assign, getter=isOpen) BOOL isOpen;
@property (readwrite, assign) id superService;
@property (readwrite, strong) NSError* error;
@end

@implementation FLService
@synthesize isOpen = _isOpen;
@synthesize superService = _superService;
@synthesize error = _error;

+ (id) service {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
	[_error release];
	[super dealloc];
}
#endif

- (void) openSelf:(FLFinisher*) finisher {
    [finisher setFinished];
}

- (void) closeSelf:(FLFinisher*) finisher {
    [finisher setFinished];
}

- (FLPromise*) openService:(fl_result_block_t) completion {

    FLConfirmWithComment(!self.isOpen, @"%@ service is already open", [self description]);

    self.error = nil;

    FLFinisher* finisher = [FLForegroundFinisher finisherWithBlock:^(FLPromisedResult result) {
        if([result isError]) {
            self.error = [NSError fromPromisedResult:result];
        }
        else {
            self.isOpen = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:FLServiceDidOpenNotificationKey object:self];

        }
    }];

    FLPromise* promise = [finisher addPromiseWithBlock:completion];
    [self openSelf:finisher];
    return promise;
}

- (FLPromise*) closeService:(fl_result_block_t) completion {

    FLConfirmWithComment(self.isOpen, @"%@ service is already open", [self description]);

    self.error = nil;

    FLFinisher* finisher = [FLForegroundFinisher finisherWithBlock:^(FLPromisedResult result) {
        if([result isError]) {
            self.error = [NSError fromPromisedResult:result];
        }
        else {
            self.isOpen = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:FLServiceDidCloseNotificationKey object:self];
        }
    }];

    FLPromise* promise = [finisher addPromiseWithBlock:completion];

    [self openSelf:finisher];

    return promise;
}


//- (void) didMoveToSuperService:(id) superService {
//
//}

//- (id) rootService {
//    id superService = self.superService;
//    return superService == nil ? self : [superService rootService];
//}
//
//- (void) setSuperService:(id) superService {
//    _superService = superService;
//    [self didMoveToSuperService:_superService];
//}


@end

//void FLAtomicAddServiceToService(__strong id* ivar, FLService* newService, FLService* parentService) {
//    FLAtomicPropertySet(ivar, newService, ^{ 
//        if(*ivar) {
//            [parentService removeService:*ivar];
//        }
//        if(newService) {
//            [parentService addService:newService];
//        }
//    });
//}


