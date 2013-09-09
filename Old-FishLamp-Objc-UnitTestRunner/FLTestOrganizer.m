//
//  FLTestOrganizer.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestOrganizer.h"
#import "FLTestableSubclassFinder.h"
#import "FLTestFactory.h"
#import "FLTestMethod.h"
#import "FLTestable.h"
#import "FLTestGroup.h"

#import "FLTestGroupOrganizer.h"

@interface FLTestOrganizer ()
@property (readwrite, strong, nonatomic) NSArray* unitTestFactories;
@property (readwrite, strong, nonatomic) NSDictionary* unitTestGroups;
@property (readwrite, strong, nonatomic) NSDictionary* testMethods;
@property (readwrite, strong, nonatomic) NSArray* sortedGroupList;
@end

@implementation FLTestOrganizer

@synthesize unitTestFactories = _unitTests;
@synthesize unitTestGroups = _unitTestGroups;
@synthesize testMethods = _testMethods;
@synthesize sortedGroupList = _sortedGroupList;

- (id) init {	
	self = [super init];
	if(self) {
		_unitTestFinders = [[NSMutableArray alloc] init];

        [self addUnitTestFinder:[FLTestableSubclassFinder unitTestSubclassFinder]];
	}
	return self;
}

+ (id) unitTestOrganizer {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
	[_unitTests release];
    [_unitTestFinders release];
    [_unitTestGroups release];
    [_testMethods release];
    [_sortedGroupList release];
    [super dealloc];
}
#endif

- (void) addUnitTestFinder:(FLTestFinder*) finder {
    [_unitTestFinders addObject:finder];
}

- (NSArray*) addUnitTestsForTestMethods:(NSDictionary*) testMethods {

// TODO: create test objects for methods.

    return nil;
}

- (void) findUnitTests {

    NSMutableArray* unitTestFactories = [NSMutableArray array];
    NSMutableDictionary* testMethods = [NSMutableDictionary dictionary];

    FLRuntimeVisitEveryClass(
        ^(FLRuntimeInfo classInfo, BOOL* stop) {
            for(FLTestFinder* finder in _unitTestFinders) {
                FLTestFactory* factory = [finder findPossibleUnitTestClass:classInfo];
                if(factory) {
                    [unitTestFactories addObject:factory];
                }
            }

            FLRuntimeVisitEachSelectorInClass(classInfo.class,
                ^(FLRuntimeInfo methodInfo, BOOL* stopInner) {
                    for(FLTestFinder* finder in _unitTestFinders) {
                        FLTestMethod* testMethod = [finder findPossibleTestMethod:methodInfo];

                        if(testMethod) {
                            NSMutableArray* methods = [testMethods objectForKey:testMethod.className];
                            if(!methods) {
                                methods = [NSMutableArray array];
                                [testMethods setObject:methods forKey:testMethod.className];
                            }
                            [methods addObject:testMethod];
                        }

                    }
                }
            );

        }
    );

    NSArray* testMethodObjectFactories = [self addUnitTestsForTestMethods:testMethods];
    if(testMethodObjectFactories) {
        [unitTestFactories addObjectsFromArray:testMethodObjectFactories];
    }

    self.unitTestFactories = unitTestFactories;
    self.testMethods = testMethods;
}

- (NSDictionary*) sortClassesIntoGroups:(NSArray*) factoryList {
    FLAssertNotNil(factoryList);

    NSMutableDictionary* groups = [NSMutableDictionary dictionary];

    for(id<FLTestFactory> factory in factoryList) {

        FLTestGroup* group = [factory testGroup];
        if(!group) {
            group = [FLTestGroup defaultTestGroup];
        }

        FLTestGroupOrganizer* groupOrganizer = [groups objectForKey:group.groupName];
        if(!groupOrganizer) {
            groupOrganizer = [FLTestGroupOrganizer unitTestGroupOrganizer:group];
            [groups setObject:groupOrganizer forKey:group.groupName];
        }
        
        [groupOrganizer addUnitTestFactory:factory];
    }

    return groups;

}

- (NSArray*) sortedGroupListWithGroupDictionary:(NSDictionary*) groups {
    FLAssertNotNil(groups);

    return [[groups allValues] sortedArrayUsingComparator:
        ^NSComparisonResult(FLTestGroupOrganizer* obj1, FLTestGroupOrganizer* obj2) {
        if(obj1.testGroup.groupPriority == obj2.testGroup.groupPriority) {
            return NSOrderedSame;
        }
    
        return obj1.testGroup.groupPriority  > obj2.testGroup.groupPriority ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (NSArray*) removeUnitTestBaseClasses:(NSArray*) factoryList {

    FLAssertNotNil(factoryList);

    NSMutableArray* newList = [NSMutableArray array];

    for(NSInteger i = 0; i < factoryList.count; i++) {
        FLTestFactory* factory = [factoryList objectAtIndex:i];
        Class outerClass = [factory testableClass];

        BOOL foundSubclass = NO;

        for(NSInteger j = 0; j < factoryList.count; j++) {

            if( i == j ) {
                continue;
            }

            Class innerClass = [[factoryList objectAtIndex:j] testableClass];

            if( [innerClass isSubclassOfClass:outerClass] ) {
                foundSubclass = YES;
                break;
            }

        }

        if(!foundSubclass) {
            [newList addObject:factory];
        }
    }

    return newList;
}

- (BOOL) testableClass:(Class) theClass
dependsOnUnitTestClass:(Class) anotherClass {

    if(!theClass || !anotherClass ) {
        return NO;
    }

    FLConfirmWithComment(theClass != anotherClass, @"%@ can't depend on self", NSStringFromClass(theClass));

    NSArray* dependencies = nil;
    if([theClass respondsToSelector:@selector(testDependencies)]) {
        dependencies = [theClass testDependencies];
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

            BOOL  bottomDependsOnTop = [self testableClass:bottom.testableClass dependsOnUnitTestClass:top.testableClass];
            BOOL  topDependsOnBottom = [self testableClass:top.testableClass dependsOnUnitTestClass:bottom.testableClass];

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


- (void) findAndOrganizeUnitTests {

    [self findUnitTests];

    self.unitTestFactories = [self removeUnitTestBaseClasses:self.unitTestFactories];

    self.unitTestFactories = [self sortFactoryList:self.unitTestFactories];

    self.unitTestGroups = [self sortClassesIntoGroups:self.unitTestFactories];

    self.sortedGroupList = [self sortedGroupListWithGroupDictionary:self.unitTestGroups];
}

@end
