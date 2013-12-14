//
//  NSObject+FLPrettyDescribe.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampObjc.h"
#import "FLStringFormatter.h"

@protocol FLDescribable <NSObject>
- (void) prettyDescription:(id<FLStringFormatter>) stringFormatter;
@end

@interface NSObject (FLPrettyDescribe)

/*!
 *  Override this in your subclass. If you need to describe another object,
 *  call [stringFormatter describeObject:object]
 *  
 *  @param stringFormatter to describe to.
 */
- (void) prettyDescription:(id<FLStringFormatter>) stringFormatter;

/*!
 *  This creates a pretty string and then calls [self prettyDescribe:]
 *  
 *  @return the formatted string
 */
- (NSString*) prettyDescription;

@end

#define FLSynthesizePrettyDescription() \
            - (NSString*) description { \
                return [self prettyDescription]; \
            }


