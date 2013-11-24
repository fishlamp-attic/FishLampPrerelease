//
//  FLTSortedTestGroupList.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLTTestFactoryList.h"
#import "FLTOrderedRunList.h"

@interface FLTSortedTestGroupList : FLTOrderedRunList {
@private
    NSDictionary* _groupDictionary;
    NSUInteger _totalTestCount;
}

@property (readonly, strong, nonatomic) NSDictionary* groupDictionary;

@property (readonly, assign, nonatomic) NSUInteger testCount;

- (id) initWithGroupDictionary:(NSDictionary*) groups;
+ (id) sortedTestGroupList:(NSDictionary*) groups;

- (NSArray*) allTests;

@end
