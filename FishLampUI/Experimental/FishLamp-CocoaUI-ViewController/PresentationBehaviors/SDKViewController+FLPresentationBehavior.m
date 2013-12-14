//
//  SDKViewController+FLPresentationBehavior.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 7/17/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKViewController+FLPresentationBehavior.h"

#if IOS
#import "FLNormalPresentationBehavior.h"
#endif

@implementation SDKViewController (FLPresentationBehavior)

FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, _presentationBehavior, setPresentationBehavior, id<FLPresentationBehavior>);

- (id<FLPresentationBehavior>) presentationBehavior {
    id<FLPresentationBehavior> behavior = [self _presentationBehavior];
    if(!behavior) {
        behavior = [[self class] defaultPresentationBehavior];
    }
    
    return behavior;
}

void (^FLGlobalPresentBlock)(id controller) = ^(id controller) {
#if IOS
    [[UIApplication visibleViewController] showChildViewController:controller];
#endif
};

+ (void (^)(id controller)) defaultPresentModalViewControllerBlock {
    return FLGlobalPresentBlock;
}

+ (id<FLPresentationBehavior>) defaultPresentationBehavior {
#if IOS
    return [FLNormalPresentationBehavior instance];
#else
    return nil;
#endif
}

@end
