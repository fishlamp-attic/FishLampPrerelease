//
//  FLHttpUser.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLAuthenticationCredentials.h"

@interface FLHttpUser : NSObject<FLAuthenticatedEntity, NSCopying> {
@private
    id _authenticationCredentials;
}
@property (readwrite, copy, nonatomic) id<FLAuthenticationCredentials> authenticationCredentials;

@property (readonly, strong, nonatomic) NSString* userName;

@property (readonly, assign, nonatomic, getter=isLoginAuthenticated) BOOL loginAuthenticated;
- (void) setLoginUnathenticated;

// TODO: abstract this better.
- (NSString*) cacheFolderPath;
- (NSString*) userFolderPath;
- (NSString*) userDataFolderPath;

@end
