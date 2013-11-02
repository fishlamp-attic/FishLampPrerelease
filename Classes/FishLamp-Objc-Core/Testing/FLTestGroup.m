//
//  FLTestGroup.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestGroup.h"

@implementation FLTestGroup

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {

}

+ (NSString*) groupName {
    return NSStringFromClass([self class]);
}

@end
