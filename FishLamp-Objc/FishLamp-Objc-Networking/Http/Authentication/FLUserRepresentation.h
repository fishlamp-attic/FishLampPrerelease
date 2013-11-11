//
//  FLUserRepresentation.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/9/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLUserRepresentation <NSObject>
- (id) authenticationCredentials;
- (void) setAuthenticationCredentials:(id) credentials;
@end
