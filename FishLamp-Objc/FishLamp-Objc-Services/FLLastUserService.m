//
//  FLLastUserService.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/20/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLLastUserService.h"

#import "NSFileManager+FLExtras.h"
#import "FLUserDefaultsCredentialStorage.h"
#import "FLCredentialsStorage.h"

@implementation FLLastUserService

+ (id) lastUserService {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    self = [super init];
    if(self) {
        self.credentialsStorage = [FLUserDefaultsCredentialStorage instance];
    }
    return self;
}

- (void) openService {
    if(self.credentialsStorage) {
        self.credentials = [self.credentialsStorage credentialsForLastUser];
    }

    [super openService];
}

@end



