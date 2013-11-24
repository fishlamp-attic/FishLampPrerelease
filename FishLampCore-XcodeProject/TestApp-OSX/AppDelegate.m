//
//  AppDelegate.m
//  FishLamp-Objc-OSX-64-MRC-Tester
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "AppDelegate.h"
#import "FishLampTestRunner.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self runAllTests:nil];
}

#if FL_MRC
- (void)dealloc {
	[_window release];
	[super dealloc];
}
#endif

- (IBAction) runAllTests:(id) sender {
    FLLogger* logger = [FLLogger logger];
    [logger addLoggerSink:[FLConsoleLogSink consoleLogSink:FLLogOutputSimple]];
    [FLTestOutput addLogger:logger];

    dispatch_async(dispatch_get_main_queue(), ^{
        FLRunAllTestsOperation* runner = [FLRunAllTestsOperation testRunner];
        FLPromisedResult result = [FLBackgroundQueue runSynchronously:runner];

        [[NSApplication sharedApplication] terminate:self];
    });
}

@end
