//
//  FLArgumentList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"

#define FLArgumentListMaxArgumentCount 5

@interface FLArgumentList : NSObject<NSFastEnumeration /*, NSCoding, NSCopying*/> {
@private
    int _count;
    id _arguments[FLArgumentListMaxArgumentCount];
}

@property (readonly, assign, nonatomic) int count;
@property (readonly, strong, nonatomic) id argument; // zero
- (id) argument:(NSUInteger) index;

- (id) initWithArgument:(id) argument1;
- (id) initWithArgument:(id) argument1 withObject:(id) argument2;
- (id) initWithArgument:(id) argument1 withObject:(id) argument2 withObject:(id) argument3;
- (id) initWithArguments:(id) argument, ... NS_REQUIRES_NIL_TERMINATION;
- (id) initWithArgumentCount:(int) count arguments:(id[]) arguments;
- (id) initWithFirstArgument:(id) first valist:(va_list) valist;

+ (id) argumentList:(id) argument1;
+ (id) argumentList:(id) argument1 withObject:(id) argument2;
+ (id) argumentList:(id) argument1 withObject:(id) argument2 withObject:(id) argument3;
+ (id) argumentListWithArgumentCount:(int) count arguments:(id[]) arguments;
+ (id) argumentListWithArguments:(id) argument, ... NS_REQUIRES_NIL_TERMINATION;

@end
