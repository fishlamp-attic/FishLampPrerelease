//
//  FLTestGroupRunner.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLSortedTestGroup.h"
#import "FLTestGroup.h"
#import "FLTestFactory.h"

@interface FLSortedTestGroup ()
@property (readwrite, strong, nonatomic) NSArray* testFactories;
- (NSArray*) sortFactoryList:(NSArray*) list;
@end

@implementation FLSortedTestGroup

@synthesize testFactories = _testFactories;
@synthesize testGroup = _testGroup;

- (id) initWithGroup:(FLTestGroup*) group {
	self = [super init];
	if(self) {
        FLAssertNotNil(group);
		_testGroup = FLRetain(group);
        _testFactories = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_testGroup release];
    [_testFactories release];
	[super dealloc];
}
#endif

+ (id) sortedTestGroup:(FLTestGroup*) group {
    return FLAutorelease([[[self class] alloc] initWithGroup:group]);
}

- (void) addUnitTestFactory:(id<FLTestFactory>) unitTestFactory {
    [_testFactories addObject:unitTestFactory];
}

- (NSUInteger) testCount {
    return [_testFactories count];
}

- (BOOL) testableClass:(Class) theClass
dependsOnUnitTestClass:(Class) anotherClass {

    if(!theClass || !anotherClass ) {
        return NO;
    }

    FLConfirmWithComment(theClass != anotherClass, @"%@ can't depend on self", NSStringFromClass(theClass));

    NSArray* dependencies = nil;
    if([theClass respondsToSelector:@selector(specifyRunOrder:)]) {
        FLTestableRunOrder* runOrder = [FLTestableRunOrder testableRunOrder];
        [theClass specifyRunOrder:runOrder];
        dependencies = FLRetainWithAutorelease([runOrder dependencies]);
    }

    if(!dependencies) {
        return NO;
    }
    
    for(Class aClass in dependencies) {
        FLConfirmWithComment(theClass != aClass, @"%@ can't depend on self", NSStringFromClass(theClass));
   
        if(aClass == anotherClass) {
            return YES;
        }
        
        if([self testableClass:aClass dependsOnUnitTestClass:anotherClass]) {
            return YES;
        }
    }

    return NO;
}

- (NSArray*) sortFactoryList:(NSArray*) list {

    FLAssertNotNil(list);

// TODO: someone write a better sort algorigthm please... :-/ This one is 0^2

    NSMutableArray* newList = FLAutorelease([list mutableCopy]);

    int i = newList.count - 1;
    while(i >= 0) {
        
        id<FLTestFactory> bottom = [newList objectAtIndex:i];
        
        int newIndex = i;
        
        for(int j = i - 1; j >= 0; j--) {
            id<FLTestFactory> top = [newList objectAtIndex:j];

            BOOL  bottomDependsOnTop = [self testableClass:bottom.testableClass
                                    dependsOnUnitTestClass:top.testableClass];

            BOOL  topDependsOnBottom = [self testableClass:top.testableClass
                                    dependsOnUnitTestClass:bottom.testableClass];

            FLConfirmWithComment(bottomDependsOnTop == NO || topDependsOnBottom == NO,
                @"%@ and %@ can't depend on each other", NSStringFromClass(top.testableClass), NSStringFromClass(bottom.testableClass));
            
            if(topDependsOnBottom) {
                newIndex = j;
            }
        }
        
        if(newIndex != i) {
            [newList removeObjectAtIndex:i];
            [newList insertObject:bottom atIndex:newIndex];
        }
        else {
            --i;
        }
    }

    return newList;
}

- (void) organizeTests {
    self.testFactories = [self sortFactoryList:self.testFactories];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.testFactories countByEnumeratingWithState:state objects:buffer count:len];
}

@end
