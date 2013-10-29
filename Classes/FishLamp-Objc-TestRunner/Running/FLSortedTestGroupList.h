//
//  FLSortedTestGroupList.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLSortedTestGroup;

@interface FLSortedTestGroupList : NSObject<NSFastEnumeration> {
@private
    NSDictionary* _groupDictionary;
    NSArray* _groupList;

    NSUInteger _totalTestCount;
}

@property (readonly, strong, nonatomic) NSDictionary* groupDictionary;
@property (readonly, strong, nonatomic) NSArray* groups;
@property (readonly, assign, nonatomic) NSUInteger groupCount;
@property (readonly, assign, nonatomic) NSUInteger testCount;

- (id) initWithGroupDictionary:(NSDictionary*) groups;
+ (id) sortedTestGroupList:(NSDictionary*) groups;

- (NSArray*) allTests;

- (FLSortedTestGroup*) groupAtIndex:(NSUInteger) theIndex;

@end
