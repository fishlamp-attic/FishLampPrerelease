//
//  FLTestCaseList.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseList.h"
#import "FLTestCase.h"
#import "FishLampMinimum.h"

@interface FLTestCaseList ()
@property (readwrite, strong) NSString* disabledReason;

- (id<FLTestCase>) setRunOrder:(NSUInteger) order forSelector:(SEL) selector;
- (id<FLTestCase>) setRunOrder:(NSUInteger) order forTestCase:(id<FLTestCase>) testCase;
- (NSUInteger) runOrderForTestCase:(id<FLTestCase>) testCase;

@end

@implementation FLTestCaseList

@synthesize isDisabled = _isDisabled;
@synthesize disabledReason = _disabledReason;
@synthesize testCaseArray = _testCaseArray;

- (id) initWithArrayOfTestCases:(NSArray*) array {

    self = [super init];
	if(self) {
		_testCaseArray = [array mutableCopy];
	}
	return self;
}

- (id) init {	
	self = [super init];
	if(self) {
        _testCaseArray = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) testCaseList {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCases {
    return FLAutorelease([[[self class] alloc] initWithArrayOfTestCases:testCases]);
}

#if FL_MRC
- (void)dealloc {
    [_disabledReason release];
    [_testCaseArray release];
	[super dealloc];
}
#endif

- (void) disableAllTests:(NSString*) reason {
    _isDisabled = YES;
    self.disabledReason = reason;

    for(id<FLTestCase> testCase in _testCaseArray) {
        [testCase setDisabledWithReason:reason];
    }
}

- (id<FLTestCase>) testCaseForName:(NSString*) name {

    id<FLTestCase> outTestCase = nil;

    for(id<FLTestCase> testCase in _testCaseArray) {
        if([testCase.selector.selectorName isEqual:name] ) {
            outTestCase  = testCase;
            break;
        }
    }

    FLConfirmNotNilWithComment(outTestCase, @"unable to find test case for \"%@\"", name);
    
    return outTestCase;
}

- (id<FLTestCase>) testCaseForSelector:(SEL) selector {
    for(id<FLTestCase> testCase in _testCaseArray) {
        if([testCase.selector isEqualToSelector:selector]) {
            return testCase;
        }
    }
    return nil;
}

- (id<FLTestCase>) testCaseForObject:(id) object {
    return [object conformsToProtocol:@protocol(FLTestCase)] ? object : [self testCaseForName:object];
}

- (NSUInteger) runOrderForTestCase:(id<FLTestCase>) testCase {
    return [_testCaseArray indexOfObject:testCase];
}

- (void) addTestCase:(id<FLTestCase>) testCase {
    [_testCaseArray addObject:testCase];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_testCaseArray countByEnumeratingWithState:state objects:buffer count:len];
}

- (id<FLTestCase>) setRunOrder:(NSUInteger) order forTestCase:(id<FLTestCase>) testCase {
    FLConfirmNotNil(testCase);

    [_testCaseArray removeObject:FLRetainWithAutorelease(testCase)];

    if(order == 0) {
        [_testCaseArray insertObject:testCase atIndex:0];
    }
    else if(order >= (_testCaseArray.count - 1)) {
        [_testCaseArray addObject:testCase];
    }
    else {
        [_testCaseArray insertObject:testCase atIndex:order];
    }

    return testCase;
}

- (id<FLTestCase>) setRunOrder:(NSUInteger) order forSelector:(SEL) selector {
    return [self setRunOrder:order forTestCase:[self testCaseForSelector:selector]];
}

- (NSString*) description {
    return [_testCaseArray description];
}

//- (void) orderTestCaseFirst:(id<FLTestCase>) testCase {
//    [self setRunOrder:0 forTestCase:testCase];
//}
//
//- (void) orderTestCaseLast:(id<FLTestCase>) testCase {
//    [self setRunOrder:_testCases.count - 1 forTestCase:testCase];
//}
//
//- (void) orderTestCase:(id<FLTestCase>) testCase
//         afterTestCase:(id<FLTestCase>) anotherTestCase {
//    NSInteger idx = [_testCases indexOfObject:anotherTestCase];
//    if(idx != NSNotFound) {
//        [self setRunOrder:idx + 1 forTestCase:anotherTestCase];
//    }
//}
//
//- (void) orderTestCase:(id<FLTestCase>) testCase
//        beforeTestCase:(id<FLTestCase>) anotherTestCase {
//    NSInteger idx = [_testCases indexOfObject:anotherTestCase];
//    if(idx != NSNotFound) {
//        [self setRunOrder:idx - 1 forTestCase:anotherTestCase];
//    }
//}


- (id<FLTestCase>) orderFirst:(id) testCase {
    return [self setRunOrder:0 forTestCase:[self testCaseForObject:testCase]];
}

- (id<FLTestCase>) orderLast:(id) testCase {
    return [self setRunOrder:_testCaseArray.count - 1 forTestCase:[self testCaseForObject:testCase]];
}

- (id<FLTestCase>) order:(id) testCase
                   after:(id) anotherTestCase {
    NSInteger idx = [_testCaseArray indexOfObject:[self testCaseForObject:anotherTestCase]];
    FLConfirmWithComment(idx != NSNotFound, @"run order for %@ not found", testCase);
    return [self setRunOrder:idx + 1 forTestCase:[self testCaseForObject:testCase]];
}

- (id<FLTestCase>) order:(id) testCase
                  before:(id) anotherTestCase {
    NSInteger idx = [_testCaseArray indexOfObject:[self testCaseForObject:anotherTestCase]];
    FLConfirmWithComment(idx != NSNotFound, @"run order for %@ not found", testCase);
    return [self setRunOrder:idx - 1 forTestCase:[self testCaseForObject:testCase]];
}

@end
