//
//  FLTestableRunOrder.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

/**
 *  FLTestableRunOrder specifies run order for FLTestable objects. This is passed into FLTestable 
 */
@interface FLTestableRunOrder : NSObject {
@private
    NSMutableArray* _dependencies;
}
+ (id) testableRunOrder;

@property (readonly, strong, nonatomic) NSArray* dependencies;

- (void) runTestsForClass:(Class) aClass afterTestsForClass:(Class) anotherTestable;

@end


//@private
//    NSMutableArray* _testList;
//}
//- (id) initWithTestList:(NSMutableArray*) list;
//+ (id) testableRunOrder:(NSMutableArray*) list;
//
//@property (readwrite, assign, nonatomic) NSUInteger runOrder;
//- (void) runSooner;
//- (void) runLater;
//- (void) runFirst;
//- (void) runLast;
//- (void) runBefore:(Class) anotherTestable;
//- (void) runAfter:(Class) anotherTestable;

