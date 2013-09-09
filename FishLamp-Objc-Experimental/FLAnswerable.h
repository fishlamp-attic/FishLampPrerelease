//
//  FLAnswerable.h
//  FLCore
//
//  Created by Mike Fullerton on 11/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"

@protocol FLAnswerable <NSObject>
@property (readwrite, assign, nonatomic) BOOL answer;
@property (readonly, strong, nonatomic) id object;
@property (readonly, assign, nonatomic) BOOL defaultAnswer;
@end

@interface FLAnswerable : NSObject<FLAnswerable> {
@private
    BOOL _answer;
    BOOL _defaultAnswer;
    id _object;
}

- (id) initWithDefaultAnswer:(BOOL) answer withObject:(id) object;
- (id) initWithDefaultAnswer:(BOOL) answer;
+ (id) answerable:(BOOL) defaultAnswer;
+ (id) answerable:(BOOL) defaultAnswer withObject:(id) object;
+ (id) answerable;
@end

