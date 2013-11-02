//
//  FLTTestCaseList.m
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTTestCaseList.h"

#import "FLTestCaseList.h"
#import "FLTestCase.h"
#import "FLObjcRuntime.h"
#import "FLAssertions.h"

@interface FLTTestCase (Internal)
@property (readwrite, assign) FLTTestCaseList* testCaseList;
@end

@interface FLTTestCaseList ()
@property (readwrite, strong) NSString* disabledReason;
@end

@implementation FLTTestCaseList

@synthesize isDisabled = _isDisabled;
@synthesize disabledReason = _disabledReason;
@synthesize prerequisiteTestClasses = _prerequisiteTestClasses;

- (id) initWithArrayOfTestCases:(NSArray*) array {

    self = [super init];
	if(self) {
		_testCases = [array mutableCopy];
	}
	return self;
}

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

+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCases {
    return FLAutorelease([[[self class] alloc] initWithArrayOfTestCases:testCases]);
}

#if FL_MRC
- (void)dealloc {
    [_disabledReason release];
    [_testCases release];
	[super dealloc];
}
#endif

- (void) disableAllTests:(NSString*) reason {
    _disabled = YES;
    self.disabledReason = reason;

    for(id<FLTestCase> testCase in _testCases) {
        [testCase disable:reason];
    }
}

- (id<FLTestCase>) testCaseForName:(NSString*) name {

    for(id<FLTestCase> testCase in _testCases) {
        if([testCase.selector.selectorName isEqual:name] ) {
            return testCase;
        }
    }
    
    return nil;
}

- (id<FLTestCase>) testCaseForSelector:(SEL) selector {
    for(id<FLTestCase> testCase in _testCases) {
        if([testCase.selector isEqualToSelector:selector]) {
            return testCase;
        }
    }
    return nil;
}

- (NSUInteger) runOrderForTestCase:(id<FLTestCase>) testCase {
    return [_testCases indexOfObject:testCase];
}

- (void) addTestCase:(FLTTestCase*) testCase {
    [_testCases addObject:testCase];
    testCase.testCaseList = self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_testCases countByEnumeratingWithState:state objects:buffer count:len];
}

- (void) setRunOrder:(NSUInteger) order forTestCase:(id<FLTestCase>) testCase {
    FLConfirmNotNil(testCase);

    [_testCases removeObject:FLRetainWithAutorelease(testCase)];

    if(order == 0) {
        [_testCases insertObject:testCase atIndex:0];
    }
    else if(order >= (_testCases.count - 1)) {
        [_testCases addObject:testCase];
    }
    else {
        [_testCases insertObject:testCase atIndex:order];
    }
}

- (void) setRunOrder:(NSUInteger) order forSelector:(SEL) selector {
    [self setRunOrder:order forTestCase:[self testCaseForSelector:selector]];
}

- (NSArray*) testCases {
    return FLCopyWithAutorelease(_testCases);
}

- (NSString*) description {
    return [_testCases description];
}

- (void) addPrerequisiteTestClass:(Class) aClass {
    if(!_prerequisiteTestClasses) {
        _prerequisiteTestClasses = [[NSMutableArray alloc] init];
    }

    [_prerequisiteTestClasses addObject:aClass];
}

@end
