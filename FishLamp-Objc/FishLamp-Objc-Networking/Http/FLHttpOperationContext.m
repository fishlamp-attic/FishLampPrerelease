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
#import "FLAuthenticateHttpRequestOperation.h"
#import "FLAuthenticatedEntity.h"

#import "FLAuthenticateHttpEntityOperation.h"
#import "FLAuthenticateHttpCredentialsOperation.h"

@interface FLHttpOperationContext ()

@property (readwrite, strong) id<FLUserService> userService;
@property (readwrite, strong) id<FLStorageService> storageService;
@property (readwrite, strong) FLServiceList* serviceList;
@property (readonly, strong) FLFifoAsyncQueue* authenticationQueue;

@property (readwrite, strong) id<FLAuthenticatedEntity> authenticatedEntity;

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

//- (void) openServiceWithCredentials:(id<FLAuthenticationCredentials>) credentials {
//    [self.userService openServiceWithCredentials:credentials];
//}

- (id<FLAuthenticationCredentials>) authenticationCredentials {
    return self.userService.credentials;
}

//- (void) openServiceWithUser:(id<FLAuthenticatedEntity>) entity {
//    self.authenticatedEntity = entity;
//    [self openServiceWithCredentials:entity.authenticationCredentials];
//}

- (void) closeService {
    [self requestCancel];
    [self.userService closeService];

    self.authenticatedEntity = nil;
}

- (void) userServiceDidOpen:(id<FLUserService>) service {

    [self didChangeAuthenticationCredentials:service.credentials];

    [self.storageService openService];

    [self sendMessageToListeners:@selector(httpOperationContextDidOpen:) withObject:self];
}

- (void) userServiceDidClose:(id<FLUserService>) service {
    [self.serviceList closeServices];

    [self sendMessageToListeners:@selector(httpOperationContext:didLogoutUser:)
                      withObject:self
                      withObject:self.userService.credentials];

    [self sendMessageToListeners:@selector(httpOperationContextDidClose:) withObject:self];
}

- (BOOL) isAuthenticated {
    return [self.authenticatedEntity isAuthenticated];
}

- (id<FLHttpRequestAuthenticator>) httpRequestAuthenticator {
    return self;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) request {

    FLOperation* authenticator = nil;

    if(self.authenticatedEntity) {
        authenticator = [FLAuthenticateHttpEntityOperation authenticateHttpEntityOperation:self.authenticatedEntity withHttpRequest:request];
    }
    else if(self.authenticationCredentials) {
        authenticator = [FLAuthenticateHttpCredentialsOperation authenticateHttpCredentialsOperation:self.authenticationCredentials withHttpRequest:request];
    }

    FLAssertNotNil(authenticator);

    FLThrowIfError([self runSynchronously:authenticator]);

}

- (void) willStartOperation:(id) operation {

    if([operation respondsToSelector:@selector(setAuthenticationDelegate:)]) {
        [operation setAuthenticationDelegate:self.authenticationDelegate];
        [operation setOperationStarter:self.authenticationQueue];
    }

    [operation addListener:self];

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

- (void) didRemoveOperation:(FLOperation*) operation {
    [operation removeListener:self];
}

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion {

    if(!self.isServiceOpen) {
        [self openService];
    }

    return [self queueOperation:[FLAuthenticateHttpCredentialsOperation authenticateHttpCredentialsOperation:self.authenticationCredentials]
                     completion:completion];

}

- (void) authenticateHttpRequestOperation:(FLAuthenticateHttpRequestOperation*) operation
                    didAuthenticateEntity:(id<FLAuthenticatedEntity>) entity {
    self.authenticatedEntity = entity;

    [self sendMessageToListeners:@selector(httpOperationContext:didAuthenticateUser:) withObject:self withObject:entity];
}

- (id<FLUserService>) createUserService {
    return [FLUserService userService];
}

- (id<FLStorageService>) createStorageService {
    return [FLNoStorageService noStorageService];
}

- (void) didChangeAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials {
}

- (void) prepareAuthenticatedOperation:(id) operation {
}

//- (void) updateCredentials:(id<FLAuthenticationCredentials>)authenticationCredentials {
//    self.userService.credentials = authenticationCredentials;
//}

- (void) updateEntity:(id<FLAuthenticatedEntity>) entity {
    self.authenticatedEntity = entity;
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



