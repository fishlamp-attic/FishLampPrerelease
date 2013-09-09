//
//  FLCredentials.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLModelObject.h"

@protocol FLCredentials <NSObject, NSCopying, NSMutableCopying>
@property (readonly, assign, nonatomic) BOOL rememberPassword;
@property (readonly, strong, nonatomic) NSString* userName;
@property (readonly, strong, nonatomic) NSString* password;
@property (readonly, assign, nonatomic) BOOL canAuthenticate;
@end

@protocol FLMutableCredentials <FLCredentials>
@property (readwrite, assign, nonatomic) BOOL rememberPassword;
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;
- (void) clearCredentials;
@end


@interface FLCredentials : FLModelObject<FLCredentials> {
@private
    NSString* _userName;
    NSString* _password;
    BOOL _rememberPassword;
}

- (id) initWithUserName:(NSString*) userName 
               password:(NSString*) password 
       rememberPassword:(BOOL) rememberPassword;

+ (id) credentials:(NSString*) userName 
              password:(NSString*) password 
      rememberPassword:(BOOL) rememberPassword;

+ (id) credentials;
@end

@interface FLMutableCredentials : FLCredentials<FLMutableCredentials>
@end


