//
//  FLTestGroup.m
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestGroup.h"

@interface FLTestGroup ()
@property (readwrite, strong) NSString* groupName;
@property (readwrite, assign) SInt32 groupPriority;
@end

@implementation FLTestGroup

@synthesize groupName = _groupName;
@synthesize groupPriority = _groupPriority;

- (id) initWithGroupName:(NSString*) name priority:(SInt32) priority {
    self = [super init];
    if(self) {
        self.groupName = name;
        self.groupPriority = priority;
    }
    return self;
}

+ (id) testGroup:(NSString*) name priority:(SInt32) priority {
    return FLAutorelease([[[self class] alloc] initWithGroupName:name priority:priority]);
}

#if FL_MRC
- (void) dealloc {
    [_groupName release];
    [super dealloc];
}
#endif

- (BOOL)isEqual:(id)object {
    return  object == self ||
            [self.groupName isEqual:[object groupName]];
}

- (id) copyWithZone:(NSZone*) zone {
    return FLRetain(self);
}

- (NSUInteger)hash {
    return [self.groupName hash];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { name=%@, priority=%d }", [super description], self.groupName, (int) [self groupPriority]];
}

+ (FLTestGroup*) sanityCheckTestGroup {
    FLReturnStaticObject([[FLTestGroup alloc] initWithGroupName:@"Sanity Checks" priority:FLTestPrioritySanityCheck]);
}

+ (FLTestGroup*) frameworkTestGroup {
    FLReturnStaticObject( [[FLTestGroup alloc] initWithGroupName:@"Framework Tests" priority:FLTestPriorityFramework]);
}

+ (FLTestGroup*) defaultTestGroup {
    FLReturnStaticObject( [[FLTestGroup alloc] initWithGroupName:@"Normal Tests" priority:FLTestPriorityNormal]);
}

+ (FLTestGroup*) importantTestGroup {
    FLReturnStaticObject( [[FLTestGroup alloc] initWithGroupName:@"Important Tests" priority:FLTestPriorityHigh]);
}

+ (FLTestGroup*) lastTestGroup {
    FLReturnStaticObject( [[FLTestGroup alloc] initWithGroupName:@"Last Tests" priority:FLTestPriorityLow]);
}


@end
