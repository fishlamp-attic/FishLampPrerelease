//
//  FLTTestGroupFinder.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestGroupFinder.h"
#import "FLTTestableSubclassFinder.h"
#import "FLTTestFactory.h"
#import "FLTTestMethod.h"
#import "FLTestable.h"
#import "FLTTestFactoryList.h"

@interface FLTTestGroupFinder ()
@property (readwrite, strong, nonatomic) NSDictionary* testGroups;
@end

@implementation FLTTestGroupFinder

@synthesize testGroups = _testGroups;

- (id) init {	
	self = [super init];
	if(self) {
		_testFinders = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) testGroupFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
    [_testFinders release];
    [super dealloc];
}
#endif

- (NSArray*) removeUnitTestBaseClasses:(NSArray*) factoryList {

    FLAssertNotNil(factoryList);

    NSMutableArray* newList = [NSMutableArray array];

    for(NSInteger i = 0; i < factoryList.count; i++) {
        id<FLTTestFactory> factory = [factoryList objectAtIndex:i];
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

- (void) addTestFinder:(FLTTestFinder*) finder {
    [_testFinders addObject:finder];
}

- (NSArray*) addUnitTestsForTestMethods:(NSDictionary*) testMethods {

// TODO: create test objects for methods.

    return nil;
}

- (NSDictionary*) sortClassesIntoGroups:(NSArray*) allTestFactories {
    FLAssertNotNil(allTestFactories);

    NSMutableDictionary* groups = [NSMutableDictionary dictionary];

    for(id<FLTTestFactory> factory in allTestFactories) {

        Class testGroupClass = [[factory testableClass] testGroup];
        if(!testGroupClass) {
            testGroupClass = [FLTestGroup class];
        }

        FLTTestFactoryList* factoryList = [groups objectForKey:[testGroupClass groupName]];
        if(!factoryList) {
            factoryList = [FLTTestFactoryList testFactoryList:testGroupClass];
            [groups setObject:factoryList forKey:[testGroupClass groupName]];
        }
        
        [factoryList addObject:factory];
    }

    for(FLTTestFactoryList* group in [groups allValues]) {
        [group organizeTests];
    }

    return groups;

}

- (NSDictionary*) findTestGroups {

    NSMutableArray* unitTestFactories = [NSMutableArray array];
    NSMutableDictionary* testMethods = [NSMutableDictionary dictionary];

    FLRuntimeVisitEveryClass(
        ^(FLRuntimeInfo classInfo, BOOL* stop) {
            for(FLTTestFinder* finder in _testFinders) {
                id<FLTTestFactory> factory = [finder findPossibleUnitTestClass:classInfo];
                if(factory) {
                    [unitTestFactories addObject:factory];
                }
            }

            FLRuntimeVisitEachSelectorInClass(classInfo.class,
                ^(FLRuntimeInfo methodInfo, BOOL* stopInner) {
                    for(FLTTestFinder* finder in _testFinders) {
                        FLTTestMethod* testMethod = [finder findPossibleTestMethod:methodInfo];

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

    NSArray* finalizedFactoryList = [self removeUnitTestBaseClasses:unitTestFactories];

    return [self sortClassesIntoGroups:finalizedFactoryList];
}

@end
