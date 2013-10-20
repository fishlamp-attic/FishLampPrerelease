//
//  FLStatusBarViewController.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewController.h"

#if REFACTOR
@interface FLStatusBarViewController : FLViewController {
@private
    NSMutableArray* _stack;
}
- (void) setStatusView:(SDKView*) view 
              animated:(BOOL) animated
              completion:(void (^)()) completion;

- (void) pushStatusView:(SDKView*) view 
               animated:(BOOL) animated
               completion:(void (^)()) completion;
               
- (void) popStatusViewAnimated:(BOOL) animated 
                    completion:(void (^)()) completion;

- (void) removeAllStatusViewsAnimated:(BOOL) animated 
                           completion:(void (^)()) completion;
@end
#endif
