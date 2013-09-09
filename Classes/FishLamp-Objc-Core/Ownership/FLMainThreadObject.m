//
//  FLMainThreadObject.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLMainThreadObject.h"
#import "FLAssertions.h"

@implementation FLMainThreadObject

+ (id) mainThreadObject:(id) object {
    return FLAutorelease([[[self class] alloc] initWithRetainedObject:object]);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    id object = [self representedObject];
    FLAssertNotNil(object);
    
    if(![NSThread isMainThread] &&
        [object respondsToSelector:[anInvocation selector]]) {

        [anInvocation retainArguments];
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [anInvocation invokeWithTarget:object];
            }
            @catch(NSException* ex) {
//                FLLog([ex description]);
            }
        });
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end

@implementation NSObject (FLMainThreadObject)
- (id) onMainThread {
    return [FLMainThreadObject mainThreadObject:self];
}
@end