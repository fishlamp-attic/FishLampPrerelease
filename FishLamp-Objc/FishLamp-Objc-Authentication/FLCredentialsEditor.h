//
//  FLCredentialsEditor.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@protocol FLCredentials;
@protocol FLMutableCredentials;
@protocol FLCredentialsEditorDelegate;

@interface FLCredentialsEditor : NSObject {
@private
    id<FLMutableCredentials> _credentials;
    __unsafe_unretained id<FLCredentialsEditorDelegate> _delegate;
    BOOL _editing;
}

@property (readwrite, assign, nonatomic) id<FLCredentialsEditorDelegate> delegate;
@property (readonly, assign, nonatomic, getter=isEditing) BOOL editing;
@property (readonly, strong, nonatomic) id<FLCredentials> credentials;

@property (readwrite, assign, nonatomic) BOOL rememberPassword;
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;

- (id) initWithCredentials:(id<FLCredentials>) creds;
+ (id) authCredentialEditor:(id<FLCredentials>) creds;

- (void) startEditing;
- (void) stopEditing;

@end

@protocol FLCredentialsEditorDelegate <NSObject>

- (void) credentialsEditor:(FLCredentialsEditor*) editor
willStartEditingCredentials:(id<FLCredentials>) credentials;

- (void) credentialsEditor:(FLCredentialsEditor*) editor
      credentialsDidChange:(id<FLCredentials>) credentials;

- (void) credentialsEditor:(FLCredentialsEditor*) editor
didFinishEditingCredentials:(id<FLCredentials>) credentials;

@end
