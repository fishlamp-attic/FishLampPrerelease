//
//  ZFActivityLogView.m
//  FishLamp
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLActivityLogViewController.h"
#import "FLTextViewLogger.h"

#define kInterval 0.5

@implementation FLActivityLogViewController

@synthesize activityLog = _activityLog;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

#if FL_MRC
    [_queue release];
    [_activityLog release];
    [super dealloc];
#endif
}

- (void) update {

    if(self.activityLog) {
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        if(_nextUpdate < now) {
            for(NSAttributedString* string in _queue) {
                [self.logger appendAttributedString:string];
            }
            [_queue removeAllObjects];
            [self.textView scrollRangeToVisible:NSMakeRange([[self.textView string] length], 0)];

            _nextUpdate = [NSDate timeIntervalSinceReferenceDate] + kInterval;
        }
        else {
            [FLForegroundQueue dispatch_after:0.1 block:^{
                [self update];
            }];
        }
    }
}


- (void) logWasUpdated:(NSNotification*) note {

    NSAttributedString* string = [[note userInfo] objectForKey:FLActivityLogStringKey];

    if(string) {
        [FLForegroundQueue dispatch_async:^{

            if(!_queue) {
                _queue = [[NSMutableArray alloc] init];
            }

            [_queue addObject:string];
            [self update];
        }];
    }
}


- (void) setActivityLog:(FLActivityLog*) log {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    FLSetObjectWithRetain(_activityLog, log);
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(logWasUpdated:) 
                                                 name:FLActivityLogUpdated 
                                               object:[self activityLog]];

    [self.logger clearContents];

    // don't think we need this...???
    [self setLinkAttributes];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self.textView setEditable:NO];
}

@end
