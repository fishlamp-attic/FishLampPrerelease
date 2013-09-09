//
//  FLVisitable.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/12/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"

@protocol FLVisitable <NSObject>
@property (readonly, assign, getter=isVisitable) BOOL visitable;
- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor;
@end

@interface FLVisitable : NSObject<FLVisitable> {
@private
    BOOL _visitable;
    NSMutableArray* _children;
    NSArray* _iterationList;
}

@property (readwrite, assign, getter=isVisitable) BOOL visitable;

/**
    add a child notifier.
*/
- (void) addVisitable:(id) object;

/**
    remove a child notifier.
*/
- (void) removeVisitable:(id) object;

/** 
    visit each notifier recursively (disabled notifiers are not visited)
    @return YES if stopped at any point (skipping disabled doesn't count as stopping)
*/
- (BOOL) visit:(void (^)(id object, BOOL* stop)) visitor;

@end