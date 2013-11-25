//
//  AppDelegate.h
//  FishLampCore-OSX-64-MRC-Tester
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject<NSApplicationDelegate> {
@private
    NSWindow* _window;
}

@property (strong, nonatomic, readonly) IBOutlet NSWindow *window;

- (IBAction) runAllTests:(id) sender;
@end
