//
//  ZFActivityLogView.h
//  FishLamp
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Cocoa/Cocoa.h>

#import "FLActivityLog.h"
#import "FLTextViewController.h"

@interface FLActivityLogViewController : FLTextViewController {
@private
    id<FLActivityLog> _activityLog;
    NSMutableArray* _queue;
    NSTimeInterval _nextUpdate;
}

@property (readwrite, strong, nonatomic) id<FLActivityLog> activityLog;

@end
