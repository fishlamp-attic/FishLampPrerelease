//
//  FLStashedCallback.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStashedCallback.h"

@interface FLStashedCallback ()
@property (readwrite, strong, nonatomic) FLArgumentList* arguments;
@end

@implementation FLStashedCallback 

@synthesize arguments = _arguments;

- (id) initWithTarget:(id) target action:(SEL) action arguments:(FLArgumentList*) arguments {
    self = [super initWithTarget:target action:action];
    if(self) {
        self.arguments = arguments;
    }
    return self;
}

- (id) initWithBlock:(FLCallbackBlock) block arguments:(FLArgumentList*) arguments {
    self = [super initWithBlock:block];
    if(self) {
        self.arguments = arguments;
    }
    return self;
}

+ (id) callbackWithTarget:(id) target action:(SEL) action arguments:(FLArgumentList*) arguments {
    return FLAutorelease([[[self class] alloc] initWithTarget:target action:action arguments:arguments]);
}

+ (id) callbackWithBlock:(FLCallbackBlock) block arguments:(FLArgumentList*) arguments {
    return FLAutorelease([[[self class] alloc] initWithBlock:block arguments:arguments]);
}

- (void) runAsynchronously:(FLFinisher*) finisher {
    switch(_arguments.count) {
        case 0:
            [self perform];
            break;
        
        case 1:
            [self performWithObject:[_arguments argument:0]];
            break;
        
        case 2:
            [self performWithObject:[_arguments argument:0] 
                         withObject:[_arguments argument:1]];
            break;

        case 3:
            [self performWithObject:[_arguments argument:0] 
                         withObject:[_arguments argument:1]
                         withObject:[_arguments argument:2]];
            break;
    }
    
    [finisher setFinished];
}

#if FL_MRC
- (void) dealloc {
    [_arguments release];
    [super dealloc];
}
#endif

        
@end

