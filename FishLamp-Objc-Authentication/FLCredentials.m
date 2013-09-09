//
//  FLCredentials.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCredentials.h"

@interface FLCredentials ()
@property (readwrite, assign, nonatomic) BOOL rememberPassword;
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;

@end

@implementation FLCredentials
 
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize rememberPassword = _rememberPassword;

- (id) init {	
    return [self initWithUserName:nil password:nil rememberPassword:NO];
}

- (id) initWithUserName:(NSString*) userName 
               password:(NSString*) password 
       rememberPassword:(BOOL) rememberPassword {

	self = [super init];
	if(self) {
        self.userName = userName;
        self.password = password;
        self.rememberPassword = rememberPassword;
	}
	return self;
}       

+ (id) credentials:(NSString*) userName 
              password:(NSString*) password 
      rememberPassword:(BOOL) rememberPassword {
    return FLAutorelease([[[self class] alloc] initWithUserName:userName 
                                                       password:password 
                                               rememberPassword:rememberPassword]);
}

+ (id) credentials {
    return FLAutorelease([[[self class] alloc] init]);
}


#if FL_MRC
- (void) dealloc {
    [_userName release];
	[_password release];
    [super dealloc];
}
#endif

- (id)mutableCopyWithZone:(NSZone *)zone {
    return FLModelObjectCopy(self, [FLMutableCredentials class]); 
}

- (BOOL) canAuthenticate {
    return FLStringIsNotEmpty(self.userName) && FLStringIsNotEmpty(self.password);
}

//- (id) copyWithZone:(NSZone *)zone {
//    FLCredentials* user = [[FLCredentials alloc] init];
//    user.userName = FLCopyWithAutorelease(self.userName);
//    user.password = FLCopyWithAutorelease(self.password);
//    user.rememberPassword = self.rememberPassword;
//    return user;
//}
@end

@implementation FLMutableCredentials
@dynamic userName;
@dynamic password;
@dynamic rememberPassword;

- (void) clearCredentials {
    self.userName = nil;
    self.password = nil;
}
@end