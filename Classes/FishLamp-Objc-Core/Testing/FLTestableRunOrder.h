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
@protocol FLTestableRunOrder <NSObject>
- (void) orderClassFirst:(Class) aClass;
- (void) orderClassEarly:(Class) aClass;
- (void) orderClassLate:(Class) aClass;
- (void) orderClassLast:(Class) aClass;

- (void) orderClass:(Class) aClass afterClass:(Class) anotherClass;

- (void) orderClass:(Class) aClass beforeClass:(Class) anotherClass;
@end

