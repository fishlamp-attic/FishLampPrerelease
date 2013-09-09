//
//  FLUserDefaultsCredentialStorage.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCredentialsStorage.h"

@interface FLUserDefaultsCredentialStorage : NSObject<FLCredentialsStorage>
FLSingletonProperty(FLUserDefaultsCredentialStorage);
@end

@interface FLCredentials (NSUserDefaults)
+ (id) authCredentialsFromUserDefaults;

- (void) writeToUserDefaults;
- (void) writePasswordToKeychain;
@end

@interface FLMutableCredentials (NSUserDefaults)
- (void) readFromUserDefaults;
- (void) readPasswordFromKeychain;
- (void) removePasswordFromKeychain;
@end