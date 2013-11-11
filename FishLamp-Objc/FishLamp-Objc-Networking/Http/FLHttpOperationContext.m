//
//  FLHttpOperationContext.m
//  FishLampConnect
//
//  Created by Mike Fullerton on 3/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpOperationContext.h"
#import "FLHttpRequest.h"
#import "FLStorageService.h"
#import "FLUserService.h"
#import "FLServiceList.h"
#import "FLAuthenticationCredentials.h"
#import "FLHttpAuthenticator.h"

NSString* const FLHttpControllerDidLogoutUserNotification = @"FLHttpControllerDidLogoutUserNotification";

@interface FLHttpOperationContext ()

@property (readwrite, strong) id<FLUserService> userService;
@property (readwrite, strong) id<FLStorageService> storageService;
@property (readwrite, strong) FLServiceList* serviceList;
@property (readonly, strong) FLFifoAsyncQueue* authenticationQueue;

@end

@implementation FLHttpOperationContext

@synthesize userService = _userService;
@synthesize storageService = _storageService;
@synthesize serviceList = _serviceList;
@synthesize authenticatedEntity = _authenticatedEntity;
@synthesize authenticationQueue = _authenticationQueue;
@synthesize authenticationDelegate = _authenticationDelegate;

- (id) init {
    self = [super init];
    if(self) {
        _authenticationQueue = [[FLFifoAsyncQueue alloc] init];

        _serviceList = [[FLServiceList alloc] init];

        // create user service
        self.userService = [self createUserService];
        FLAssertNotNil(self.userService);
        [_serviceList addService:self.userService];

        [self.userService addListener:self];

        // create storage service
        self.storageService = [self createStorageService];
        if(self.storageService) {
            [_serviceList addService:self.storageService];
        }
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_authenticatedEntity release];
    [_storageService release];
    [_userService release];
    [_serviceList release];
    [super dealloc];
}
#endif

+ (id) httpContext {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) isServiceOpen {
    return self.userService.isServiceOpen;
}

- (BOOL) canOpenService {
    return [self.userService canOpenService];
}

- (void) openService {
    return [self.userService openService];
}

- (void) openServiceWithCredentials:(id<FLAuthenticationCredentials>) credentials {
    [self.userService openServiceWithCredentials:credentials];
}

- (void) openServiceWithUser:(id<FLAuthenticatedEntity>) entity {
    self.authenticatedEntity = entity;
    [self openServiceWithCredentials:entity.authenticationCredentials];
}

- (void) closeService {
    [self.userService closeService];
}

- (void) userServiceDidOpen:(id<FLUserService>) service {
    [self didChangeAuthenticationCredentials:service.credentials];
    [self.storageService openService];
}

- (void) userServiceDidClose:(id<FLUserService>) service {
    [self.serviceList closeService];

    [self sendMessageToListeners:@selector(httpContext:didLogoutUser:)
                      withObject:self
                      withObject:self.userService.credentials];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FLHttpControllerDidLogoutUserNotification object:self];
}

- (BOOL) isAuthenticated {
    return [self.userService.credentials isAuthenticated];
}

- (id<FLHttpRequestAuthenticator>) httpRequestAuthenticator {
    return self;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) request {
    FLThrowIfError([self runSynchronously:
        [FLHttpAuthenticator httpAuthenticatorWithEntity:self.authenticatedEntity withHttpRequest:request]]);
}

- (void) willStartOperation:(id) operation {

    if([operation respondsToSelector:@selector(setAuthenticationDelegate:)]) {
        [operation setAuthenticationDelegate:self.authenticationDelegate];
        [operation setOperationStarter:self.authenticationQueue];
    }

//    [self.authenticatedServices startProcessingObject:operation];

//    id object = operation; // for casting

// TODO: abstract this better.    

//    if(_streamSecurity != FLNetworkStreamSecurityNone) {
//        if([object respondsToSelector:@selector(setStreamSecurity:)]) {
//            if([object streamSecurity] == FLNetworkStreamSecurityNone) {
//                [object setStreamSecurity:_streamSecurity]; 
//            }
//        }
//    }
}

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion {

    if(!self.isServiceOpen) {
        [self openService];
    }

    return [self queueOperation:[FLHttpAuthenticator httpAuthenticatorWithCredentials:self.userService.credentials]
                     completion:completion];

}

//- (void) didRemoveOperation:(FLOperation*) operation {
//
////    [self.authenticatedServices stopProcessingObject:operation];
//}

- (void) authenticateHttpRequestOperation:(FLHttpAuthenticator*) operation
                    didAuthenticateEntity:(id<FLAuthenticatedEntity>) entity {
    self.authenticatedEntity = entity;

    [self sendMessageToListeners:@selector(httpContext:didAuthenticateUser:) withObject:self withObject:entity];
}

- (id<FLUserService>) createUserService {
    return [FLUserService userService];
}

- (id<FLStorageService>) createStorageService {
    return [FLNoStorageService noStorageService];
}

- (void) didChangeAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials {
    [self.authenticatedEntity setAuthenticationCredentials:credentials];
}

- (void) prepareAuthenticatedOperation:(id) operation {

}

//- (FLPromise*) beginAuthenticatingCredentials:(id<FLAuthenticationCredentials>) credentials
//                                   completion:(fl_completion_block_t) completion {
//
//    if(!self.isOpen) {
//        [self openServiceWithCredentials:credentials completion:nil];
//    }
//
//    return [self.httpRequestAuthenticator beginAuthenticatingCredentials:credentials
//                                                              completion:completion];
//
//}

//- (FLPromise*) beginAuthenticatingUser:(id<FLAuthenticatedEntity>) entity
//                            completion:(fl_completion_block_t) completion {
//
//    if(!self.isOpen) {
//        [self openServiceWithCredentials:entity.authenticationCredentials completion:nil];
//    }
//
//    return [self.httpRequestAuthenticator beginAuthenticatingEntity:entity
//                                                         completion:completion];
//}



@end



