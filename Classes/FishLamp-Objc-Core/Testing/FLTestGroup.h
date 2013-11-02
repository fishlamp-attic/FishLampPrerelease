//
//  FLTestableGroup.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTestableRunOrder.h"

@protocol FLTestGroup <NSObject>

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder;

+ (NSString*) groupName;

@end

@interface FLTestGroup : NSObject<FLTestGroup>
@end