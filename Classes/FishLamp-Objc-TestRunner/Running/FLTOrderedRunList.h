//
//  FLTOrderedRunList.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTestableRunOrder.h"

typedef void (^FLTOrderedRunListOrganizeBlock)(id objectInArray);

@protocol FLTOrderedClass <NSObject>
+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder;
@end

@interface FLTOrderedRunList : NSObject<NSFastEnumeration, FLTestableRunOrder> {
@private
    NSMutableArray* _runList;
}

- (id) initWithArray:(NSArray*) array;

- (Class) classFromObject:(id) object;

- (void) addObject:(id) object;

- (NSUInteger) count;

- (void) sortUsingComparator:(NSComparator)cmptr;

- (void) organize;

@end
