//
//  FLTestCaseList.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseList.h"
#import "FLTestCase.h"
#import "FLObjcRuntime.h"
#import "FLAssertions.h"

@implementation FLTestCaseList

- (id) init {	
	self = [super init];
	if(self) {
        _testCases = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) testCaseList {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
    [_testCases release];
	[super dealloc];
}
#endif

- (FLTestCase*) testCaseForName:(NSString*) name {

    for(FLTestCase* testCase in _testCases) {
        if([testCase.testCaseName isEqual:name]) {
            return testCase;
        }
    }
    
    return nil;
}
- (FLTestCase*) testCaseForSelector:(SEL) selector {
    for(FLTestCase* testCase in _testCases) {
        if(FLSelectorsAreEqual(testCase.testCaseSelector, selector)) {
            return testCase;
        }
    }
    
    return nil;
}

- (void) addTestCase:(FLTestCase*) testCase {
    [_testCases addObject:testCase];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_testCases countByEnumeratingWithState:state objects:buffer count:len];
}

- (void) sort {
    [_testCases sortUsingComparator:^NSComparisonResult(FLTestCase* obj1, FLTestCase* obj2) {

        NSString* lhs = NSStringFromSelector(obj1.testCaseSelector);
        NSString* rhs = NSStringFromSelector(obj2.testCaseSelector);

        if( [lhs rangeOfString:@"firstTest" options:NSCaseInsensitiveSearch].length > 0 ||
            [rhs rangeOfString:@"lastTest" options:NSCaseInsensitiveSearch].length > 0) {
            return NSOrderedAscending;
        }
        else if ([rhs rangeOfString:@"firstTest" options:NSCaseInsensitiveSearch].length > 0 ||
                 [lhs rangeOfString:@"lastTest" options:NSCaseInsensitiveSearch].length > 0) {
            return NSOrderedDescending;
        }

        if(obj1.runOrder != obj2.runOrder) {
            return obj1.runOrder < obj2.runOrder ? NSOrderedAscending : NSOrderedDescending;
        }

        return [lhs compare:rhs];
    }];
}

- (void) setRunOrder:(long) order forTestCase:(FLTestCase*) testCase {
    FLConfirmNotNil(testCase);
    testCase.runOrder = order;
    [self sort];
}


- (void) setRunOrder:(long) order forSelector:(SEL) selector {
    [self setRunOrder:order forTestCase:[self testCaseForSelector:selector]];
}

@end
