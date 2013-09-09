// 
// FLUserLogin.h

// Project: FishLamp
// Schema: FLSessionObjects
//
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
//

#import "FLModelObject.h"
#import "FLCredentials.h"

@interface FLUserLogin : FLModelObject<FLCredentials> {
@private
    NSString* _password;
    BOOL _isAuthenticated;
    NSString* _userName;
    double _authTokenLastUpdateTime;
    NSString* _authToken;
    NSString* _userGuid;
    NSString* _email;
    NSMutableDictionary* _userInfo;
    BOOL _rememberPassword;
}

@property (readwrite, strong, nonatomic) NSString* password;
@property (readwrite, assign, nonatomic) BOOL isAuthenticated;
@property (readwrite, assign, nonatomic) BOOL rememberPassword;
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, assign, nonatomic) double authTokenLastUpdateTime;
@property (readwrite, strong, nonatomic) NSString* authToken;
@property (readwrite, strong, nonatomic) NSString* userGuid;
@property (readwrite, strong, nonatomic) NSString* email;
@property (readwrite, strong, nonatomic) NSMutableDictionary* userInfo;

+ (id) userLogin;
+ (id) userLogin:(NSString*) userName password:(NSString*) password;
+ (id) userLoginWithCredentials:(id<FLCredentials>) credentials;

@end
