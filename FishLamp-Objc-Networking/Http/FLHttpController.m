//
//  FLHttpController.m
//  FishLampConnect
//
//  Created by Mike Fullerton on 3/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpController.h"
#import "FLReachableNetwork.h" 
#import "FLDatabaseStorageService.h"
#import "FLAppInfo.h"
#import "FLSynchronousOperation.h"
#import "FLOperationContext.h"
#import "FLHttpRequest.h"
#import "FLHttpUser.h"
#import "FLHttpRequestAuthenticator.h"

#import "FLStorageService.h"
#import "FLUserService.h"

// TODO (MWF): removing this coupling
#import "FLDatabaseStorageService.h"

#import "FLHttpAuthenticatorAsyncQueue.h"

NSString* const FLHttpControllerDidLogoutUserNotification = @"FLHttpControllerDidLogoutUserNotification";

@interface FLHttpController ()
@property (readwrite, strong) id<FLUserService> userService;
@property (readwrite, strong) id<FLStorageService> storageService;
@property (readwrite, strong) FLHttpRequestAuthenticator* httpRequestAuthenticator;
@property (readwrite, strong) FLService* authenticatedServices;
@property (readwrite, strong) FLOperationContext* operationContext;
@property (readwrite, strong) FLHttpUser* httpUser;

@end

@implementation FLHttpController
@synthesize userService = _userService;
@synthesize storageService = _storageService;
@synthesize httpRequestAuthenticator = _httpRequestAuthenticator;
//@synthesize streamSecurity = _streamSecurity;
@synthesize httpUser = _httpUser;
@synthesize authenticatedServices = _authenticatedServices;
@synthesize operationContext = _operationContext;

//- (id) init {
//    return [self initWithServiceFactory:nil];
//}
//
//- (id) initWithServiceFactory:(id<FLHttpControllerServiceFactory>) factory {

- (id) init {
    self = [super init];
    if(self) {
        _operationContext = [[FLOperationContext alloc] init];
        [_operationContext setAsyncQueue:FLBackgroundQueue];

//        [self.operationContext.listeners addListener:self];

        // create user service
        self.userService = [self createUserService];
        FLAssertNotNil(self.userService);
        [self addService:self.userService];

        // create storage service
        self.storageService = [self createStorageService];
        if(self.storageService) {
            [self addService:self.storageService];
        }

        // create http authenticator
        self.httpRequestAuthenticator = [self createHttpRequestAuthenticator];
        FLAssertNotNil(self.httpRequestAuthenticator);
//        self.httpRequestAuthenticator.delegate = self;

        FLHttpAuthenticatorAsyncQueue* httpQueue = [FLHttpAuthenticatorAsyncQueue httpAuthenticatorAsyncQueue:self.httpRequestAuthenticator];

        [_operationContext addDecorator:httpQueue];

//        [self addService:self.httpRequestAuthenticator];

    }
    return self;
}

+ (id) httpController {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) willClose {
    [self.httpUser setLoginUnathenticated];
}

- (void) userServiceDidOpen:(id<FLUserService>) service {
    self.httpUser = [self createHttpUserForCredentials:service.credentials];
}

- (void) userServiceDidClose:(id<FLUserService>) service {
    [self closeService:^(FLPromisedResult result) {
        if(self.httpUser) {
            [self.listeners.notify httpController:self didLogoutUser:self.httpUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:FLHttpControllerDidLogoutUserNotification object:self];
            self.httpUser = nil;
        }
    }];
}

- (BOOL) isAuthenticated {
    return self.httpUser && [self.httpUser isLoginAuthenticated];
}

#if FL_MRC
- (void) dealloc {
    [_operationContext release];
    [_httpUser release];
    [_httpRequestAuthenticator release];
    [_storageService release];
    [_userService release];
    [super dealloc];
}
#endif

- (void) operationContext:(FLOperationContext*) operationContext
          didAddOperation:(FLOperation*) operation {

//    [self.authenticatedServices startProcessingObject:operation];

    id object = operation; // for casting
    
// TODO: abstract this better.    

//    if(_streamSecurity != FLNetworkStreamSecurityNone) {
//        if([object respondsToSelector:@selector(setStreamSecurity:)]) {
//            if([object streamSecurity] == FLNetworkStreamSecurityNone) {
//                [object setStreamSecurity:_streamSecurity]; 
//            }
//        }
//    }
}

- (void) operationContext:(FLOperationContext*) operationContext
          didRemoveOperation:(FLOperation*) operation {

//    [self.authenticatedServices stopProcessingObject:operation];
}

- (void) httpRequestAuthenticationService:(FLHttpRequestAuthenticator*) service 
                      didAuthenticateUser:(FLHttpUser*) userLogin {


    FLServiceList* authenticated = [FLServiceList serviceList];

    // create http authenticator
    self.httpRequestAuthenticator = [self createHttpRequestAuthenticator];
    FLAssertNotNil(self.httpRequestAuthenticator);
//    self.httpRequestAuthenticator.delegate = self;

//    [authenticated addService:self.httpRequestAuthenticator];

    // create storage service
    self.storageService = [self createStorageService];
    if(self.storageService) {
        [authenticated addService:self.storageService];
    }

    [self addService:authenticated];

    if(self.storageService) {
        [self.storageService openService:nil];
    }
}

- (FLOperationContext*) httpRequestAuthenticationServiceGetOperationContext:(FLHttpRequestAuthenticator*) service {
    return self.operationContext;
}

- (FLHttpUser*) httpRequestAuthenticationServiceGetUser:(FLHttpRequestAuthenticator*) service {
    return self.httpUser;
}

- (void) databaseStorageServiceWillOpen:(FLDatabaseStorageService*) service {

    service.databaseFilePath = [[self.httpUser userDataFolderPath] stringByAppendingPathComponent:
                                    [NSString stringWithFormat:@"%@.sqlite", [FLAppInfo bundleIdentifier]]];

}

- (id<FLUserService>) createUserService {
    return [FLUserService userService];
}

- (id<FLStorageService>) createStorageService {
    return [FLDatabaseStorageService databaseStorageService];
}

- (FLHttpUser*) createHttpUserForCredentials:(id<FLCredentials>) credentials {
    return  [FLHttpUser httpUser:[FLUserLogin userLoginWithCredentials:credentials]];
}

- (FLHttpRequestAuthenticator*) createHttpRequestAuthenticator {
    return nil;
}

@end

//@implementation FLHttpControllerServiceFactory
//
//+ (id<FLHttpControllerServiceFactory>) httpControllerServiceFactory {
//    return FLAutorelease([[[self class] alloc] init]);
//}
//
//- (id<FLUserService>) httpControllerCreateUserService:(FLHttpController*) controller {
//    return [FLUserService userService];
//}
//
//- (id<FLStorageService>) httpControllerCreateStorageService:(FLHttpController*) controller {
//    return [FLDatabaseStorageService databaseObjectStorageService:controller];
//}
//
//- (FLHttpUser*) httpController:(FLHttpController*) controller
//  createHttpUserForCredentials:(id<FLCredentials>) credentials {
//    return  [FLHttpUser httpUser:[FLUserLogin userLoginWithCredentials:credentials]];
//}
//
//- (FLHttpRequestAuthenticator*) httpControllerCreateHttpRequestAuthenticationService:(FLHttpController*) controller {
//    return [FLHttpRequestAuthenticator httpRequestAuthenticationService];
//}
//@end

