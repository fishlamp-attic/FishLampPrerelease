//
//  FLHttpController.m
//  FishLampConnect
//
//  Created by Mike Fullerton on 3/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpController.h"
#import "FLHttpRequest.h"
#import "FLHttpUser.h"
#import "FLHttpRequestAuthenticator.h"
#import "FLStorageService.h"
#import "FLUserService.h"

NSString* const FLHttpControllerDidLogoutUserNotification = @"FLHttpControllerDidLogoutUserNotification";

@interface FLHttpController ()
@property (readwrite, strong) id<FLUserService> userService;
@property (readwrite, strong) id<FLStorageService> storageService;
@property (readwrite, strong) FLHttpRequestAuthenticator* httpRequestAuthenticator;
@property (readwrite, strong) FLHttpUser* httpUser;
@property (readwrite, strong) FLServiceList* serviceList;
@end

@implementation FLHttpController
@synthesize userService = _userService;
@synthesize storageService = _storageService;
@synthesize httpRequestAuthenticator = _httpRequestAuthenticator;
@synthesize httpUser = _httpUser;
@synthesize serviceList = _serviceList;

- (id) init {
    self = [super init];
    if(self) {
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

        // create http authenticator
        self.httpRequestAuthenticator = [self createHttpRequestAuthenticator];
        FLAssertNotNil(self.httpRequestAuthenticator);
        self.httpRequestAuthenticator.delegate = self;
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
    [self.serviceList closeService:^(FLPromisedResult result) {
        if(self.httpUser) {
            [self.notify httpController:self didLogoutUser:self.httpUser];
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
    [_httpUser release];
    [_httpRequestAuthenticator release];
    [_storageService release];
    [_userService release];
    [_serviceList release];
    [super dealloc];
}
#endif

- (void) didAddOperation:(FLOperation*) operation {

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

- (void) didRemoveOperation:(FLOperation*) operation {

//    [self.authenticatedServices stopProcessingObject:operation];
}

- (void) httpRequestAuthenticator:(FLHttpRequestAuthenticator*) authenticator
                didAuthenticateUser:(FLHttpUser*) user {

    if(self.storageService) {
        [self.storageService openService:nil];
    }
}

- (FLOperationContext*) httpRequestAuthenticatorGetOperationContext:(FLHttpRequestAuthenticator*) context {
    return self;
}

- (FLHttpUser*) httpRequestAuthenticatorGetUser:(FLHttpRequestAuthenticator*) service {
    return self.httpUser;
}

- (id<FLUserService>) createUserService {
    return [FLUserService userService];
}

- (id<FLStorageService>) createStorageService {
    return [FLNoStorageService noStorageService];
}

- (FLHttpUser*) createHttpUserForCredentials:(id<FLCredentials>) credentials {
    return  [FLHttpUser httpUser:[FLUserLogin userLoginWithCredentials:credentials]];
}

- (FLHttpRequestAuthenticator*) createHttpRequestAuthenticator {
    return nil;
}

@end


