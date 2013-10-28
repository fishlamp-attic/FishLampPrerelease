//
//  FLTestableRunOrder.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableRunOrder.h"

@implementation FLTestableRunOrder
@synthesize dependencies = _dependencies;

+ (id) testableRunOrder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	self = [super init];
	if(self) {
		_dependencies = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_dependencies release];
	[super dealloc];
}
#endif

- (void) runTestsForClass:(Class) aClass
       afterTestsForClass:(Class) anotherTestable {
    
    [_dependencies addObject:anotherTestable];
}


//- (id) initWithTestList:(NSMutableArray*) list {
//    self = [super init];
//    if(self) {
//        _testList = list;
//    }
//    return self;
//}
//
//+ (id) testableRunOrder:(NSMutableArray*) list {
//   return FLAutorelease([[[self class] alloc] initWithTestList:list]);
//}
//
//#if FL_MRC
//- (void)dealloc {
//	[_testList release];
//	[superdealloc];
//}
//#endif
//
//- (NSUInteger) runOrder {
//    return [_testCaseList indexOfObject:self];
//}
//
//- (void) setRunOrder:(NSUInteger) runOrder {
//    [_testCaseList setRunOrder:runOrder forTestCase:self];
//}
//
//- (void) runSooner {
//    [_testCaseList setRunOrder:self.runOrder - 1 forTestCase:self];
//}
//
//- (void) runLater {
//    [_testCaseList setRunOrder:self.runOrder + 1 forTestCase:self];
//}
//
//- (void) runFirst {
//    [_testCaseList setRunOrder:0 forTestCase:self];
//}
//
//- (void) runLast {
//    [_testCaseList setRunOrder:INT_MAX forTestCase:self];
//}
//
//- (void) runBefore:(FLTestCase*) anotherTestCase {
//    NSUInteger idx = [anotherTestCase runOrder];
//    [self setRunOrder:idx - 1];
//}
//
//- (void) runAfter:(FLTestCase*) anotherTestCase {
//    NSUInteger idx = [anotherTestCase runOrder];
//    [self setRunOrder:idx + 1];
//}
//
//- (void) setRunOrder:(NSUInteger) order forTestCase:(FLTestCase*) testCase {
//    FLConfirmNotNil(testCase);
//
//    [_testCases removeObject:FLRetainWithAutorelease(testCase)];
//
//    if(order == 0) {
//        [_testCases insertObject:testCase atIndex:0];
//    }
//    else if(order >= (_testCases.count - 1)) {
//        [_testCases addObject:testCase];
//    }
//    else {
//        [_testCases insertObject:testCase atIndex:order];
//    }
//}
//
//- (void) setRunOrder:(NSUInteger) order forSelector:(SEL) selector {
//    [self setRunOrder:order forTestCase:[self testCaseForSelector:selector]];
//}


@end
