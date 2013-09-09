//
//  FLUserDefaultsCredentialStorage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUserDefaultsCredentialStorage.h"
#import "FLAppInfo.h"
#import "FLKeychain.h"

NSString* const FLDefaultsKeyWizardLastUserNameKey = @"CredentialStorageLastUser";
NSString* const FLDefaultsKeyWizardSavePasswordKey = @"CredentialStorageServiceSavePassword";

@implementation FLUserDefaultsCredentialStorage

FLSynthesizeSingleton(FLUserDefaultsCredentialStorage);

- (id<FLCredentials>) readCredentialsForLastUser {
    return [FLCredentials authCredentialsFromUserDefaults];
}

- (void) writePasswordToKeychain:(id<FLCredentials>) creds {
    FLAssertStringIsNotEmptyWithComment([FLAppInfo bundleIdentifier], @"bundle identifier must be set to use keychain for password");

    if(FLStringIsNotEmpty(creds.userName)) {
        if(creds.rememberPassword && FLStringIsNotEmpty(creds.password)) {
            
            NSString* existingPassword = [FLKeychain httpPasswordForUserName:creds.userName withDomain:[FLAppInfo bundleIdentifier]];
            
            if(FLStringsAreNotEqual(existingPassword, creds.password)) {
                [FLKeychain setHttpPassword:creds.password forUserName:creds.userName withDomain:[FLAppInfo bundleIdentifier]];
            }
        }
        else {
            [FLKeychain removeHttpPasswordForUserName:creds.userName withDomain:[FLAppInfo bundleIdentifier]];
        }
    }
}

- (void) writeCredentials:(id<FLCredentials>) creds {
    if(FLStringIsEmpty(creds.userName)) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:FLDefaultsKeyWizardLastUserNameKey];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:creds.userName 
                                                  forKey:FLDefaultsKeyWizardLastUserNameKey];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:creds.rememberPassword] 
                                              forKey:FLDefaultsKeyWizardSavePasswordKey];

    [[NSUserDefaults standardUserDefaults] synchronize];

    [self writePasswordToKeychain:creds];
}

@end

@implementation FLCredentials (NSKeychain)


+ (id) authCredentialsFromUserDefaults {
    FLMutableCredentials* credentials = [FLMutableCredentials credentials];
    [credentials readFromUserDefaults];
    return credentials;
}

- (void) writeToUserDefaults {
    [[FLUserDefaultsCredentialStorage instance] writeCredentials:self];
}

- (void) writePasswordToKeychain {
    [[FLUserDefaultsCredentialStorage instance] writePasswordToKeychain:self];
}



@end

@implementation FLMutableCredentials (NSUserDefaults)

- (void) readFromUserDefaults {
    if(!self.userName) {
        self.rememberPassword = NO;
        self.password = @"";
        
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:FLDefaultsKeyWizardLastUserNameKey];
        
        NSNumber* saved = [[NSUserDefaults standardUserDefaults] objectForKey:FLDefaultsKeyWizardSavePasswordKey];
        self.rememberPassword = saved ? [saved boolValue] : NO;

        [self readPasswordFromKeychain];
    }
}

- (void) readPasswordFromKeychain {
    FLAssertStringIsNotEmptyWithComment([FLAppInfo bundleIdentifier], @"bundle identifier must be set to use keychain for password");

    if(FLStringIsNotEmpty(self.userName)) {
        if(self.rememberPassword) {
            self.password = [FLKeychain httpPasswordForUserName:self.userName withDomain:[FLAppInfo bundleIdentifier]];
        }
        else {
            [FLKeychain removeHttpPasswordForUserName:self.userName withDomain:[FLAppInfo bundleIdentifier]];
            self.password = @"";
        }
    }
}

- (void) removePasswordFromKeychain {
    FLAssertStringIsNotEmptyWithComment([FLAppInfo bundleIdentifier], @"bundle identifier must be set to use keychain for password");

    if(FLStringIsNotEmpty(self.userName)) {
        [FLKeychain removeHttpPasswordForUserName:self.userName withDomain:[FLAppInfo bundleIdentifier]];
        self.password = @"";
    }
}



@end
