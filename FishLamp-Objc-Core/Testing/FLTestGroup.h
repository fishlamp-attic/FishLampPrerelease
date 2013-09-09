//
//  FLTestGroup.h
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

#define FLTestPriorityLow           0
#define FLTestPriorityNormal        1000
#define FLTestPriorityHigh          2000
#define FLTestPriorityFramework     3000
#define FLTestPrioritySanityCheck   4000

@interface FLTestGroup : NSObject<NSCopying> {
@private
    NSString* _groupName;
    SInt32 _groupPriority;
}

@property (readonly, strong) NSString* groupName;
@property (readonly, assign) SInt32 groupPriority;

+ (id) testGroup:(NSString*) name priority:(SInt32) priority;

- (id) initWithGroupName:(NSString*) name priority:(SInt32) priority;

// default groups
+ (FLTestGroup*) sanityCheckTestGroup;
+ (FLTestGroup*) frameworkTestGroup;
+ (FLTestGroup*) importantTestGroup;
+ (FLTestGroup*) defaultTestGroup;
+ (FLTestGroup*) lastTestGroup;

@end
