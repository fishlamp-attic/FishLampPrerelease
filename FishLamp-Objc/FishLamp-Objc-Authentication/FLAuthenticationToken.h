//
//  FLAuthenticationToken.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@protocol FLAuthenticationSession <NSObject, NSCopying>
- (BOOL) hasExpired;
- (id<FLAuthenticationSession>) authenticatedSessionWithUpdatedTimestamp;
@end

@interface FLAuthenticationToken : NSObject<FLAuthenticationSession>

@property (readonly, strong, nonatomic) NSString* token;
@property (readonly, assign, nonatomic) NSTimeInterval lastAuthenticationTimestamp;
@property (readonly, assign, nonatomic) NSTimeInterval authTokenLastUpdateTime;
@property (readonly, assign, nonatomic) NSTimeInterval timeoutInterval;

+ (id) authenticationToken:(NSString*) authenticationToken;

- (id<FLAuthenticationSession>) authenticatedSessionWithUpdatedTimestamp;

@end
