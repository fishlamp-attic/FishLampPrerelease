//
//	FLUserService.m
//	FishLamp
//
//	Created by Mike Fullerton on 12/13/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUserService.h"
#import "FLCredentialsEditor.h"
#import "FLCredentials.h"
#import "FLCredentialsStorage.h"

@implementation FLUserService

@synthesize credentials = _credentials;
@synthesize credentialStorage = _credentialStorage;

- (id) initWithCredentials:(id<FLCredentials>) credentials {
    self = [super init];
    if(self) {
        _credentials = FLRetain(credentials);
    }
    return self;
}

+ (id) userService {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) userService:(id<FLCredentials>) credentials {
    return FLAutorelease([[[self class] alloc] initWithCredentials:credentials]);
}

#if FL_MRC
- (void) dealloc {
    [_credentialStorage release];
    [_credentials release];
    [super dealloc];
}
#endif

- (BOOL) canAuthenticate {
    return [self.credentials canAuthenticate];
}

- (void) openSelf:(FLFinisher*) finisher {
    [self.listeners.notify userServiceDidOpen:self];
    [finisher setFinished];
}

- (void) closeSelf:(FLFinisher*) finisher {

    FLCredentialsEditor* editor = [self credentialEditor];
    editor.password = nil;
    [editor stopEditing];

    [self.listeners.notify userServiceDidClose:self];
    [finisher setFinished];
}

- (FLCredentialsEditor*) credentialEditor {
    FLCredentialsEditor* editor = [FLCredentialsEditor authCredentialEditor:self.credentials];
    editor.delegate = self;
    return editor;
}

- (void) credentialsEditor:(FLCredentialsEditor*) editor
willStartEditingCredentials:(id<FLCredentials>) credentials {

   [self closeService:nil];
}

- (void) credentialsEditor:(FLCredentialsEditor*) editor
      credentialsDidChange:(id<FLCredentials>) credentials {

    self.credentials = editor.credentials;
}

- (void) credentialsEditor:(FLCredentialsEditor*) editor
didFinishEditingCredentials:(id<FLCredentials>) credentials {
    self.credentials = editor.credentials;
    if(self.credentialStorage) {
        [self.credentialStorage writeCredentials:self.credentials];
    }

    [self openService:nil];
}

@end