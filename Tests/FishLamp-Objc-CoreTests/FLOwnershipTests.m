//
//  FLOwnershipTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 9/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOwnershipTests.h"
#import "FishLampTesting.h"

#import "FLObjectProxies.h"
@interface FLObjectProxyTestObject : NSObject {
@private
    BOOL _propertyWasCalled;
}
@property (readwrite, assign, nonatomic) BOOL propertyWasCalled;

@end

static BOOL s_deleted = NO;

@implementation FLObjectProxyTestObject
@synthesize propertyWasCalled = _propertyWasCalled;

+ (id) objectProxyTestObject {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	self = [super init];
	if(self) {
	}
	return self;
}

- (void)dealloc {

    s_deleted = YES;
#if FL_MRC
	[super dealloc];
#endif
}

@end


@implementation FLOwnershipTests

- (void) testMethodForwarding {

    FLObjectProxyTestObject* testObject = [FLObjectProxyTestObject objectProxyTestObject];
    FLTest(!testObject.propertyWasCalled);
    testObject.propertyWasCalled = YES;
    FLTest(testObject.propertyWasCalled);

    testObject.propertyWasCalled = NO;
    id proxy = [FLRetainedObject retainedObject:testObject];

    FLTest([proxy representedObject] == testObject);
    FLTest(![proxy propertyWasCalled]);
    [proxy setPropertyWasCalled:YES];

    FLTest(testObject.propertyWasCalled);
    FLTest([proxy propertyWasCalled]);
}

- (void) testRetainedObjectProxy {
    s_deleted = NO;

    @autoreleasepool {
        FLRetainedObject* object = [FLRetainedObject retainedObject:[FLObjectProxyTestObject objectProxyTestObject]];
        FLTest(!s_deleted);
    }
    FLTest(s_deleted);
}

@end
