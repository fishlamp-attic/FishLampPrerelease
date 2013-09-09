//
//  FLTestToolMain.m
//  FLCore
//
//  Created by Mike Fullerton on 11/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestToolMain.h"
#import "FLTestRunner.h"

#import "FLAsyncQueue.h"
#import "FLOperation.h"

#import "FLTestable.h"
#import "FLAppInfo.h"

#import "FLDispatchQueue.h"


#import "FLTestLoggingManager.h"

int FLTestToolMain(int argc, const char *argv[], NSString* bundleIdentifier, NSString* appName, NSString* version) {
    @autoreleasepool {
        @try {

            [FLPrintf appendLine:@"hello world"];
            [FLPrintf appendLine:@"this is a test"];
            [FLPrintf appendLine:@"hello"];


            [FLAppInfo setAppInfo:bundleIdentifier
                          appName:appName
                          version:version];            
        
            FLLogger* logger = [FLLogger logger];
            [logger addLoggerSink:[FLConsoleLogSink consoleLogSink:FLLogOutputSimple]];
            [FLTestOutput addLogger:logger];
        
            FLTestRunner* runner = [FLTestRunner testRunner];
            FLPromisedResult result = [FLBackgroundQueue runSynchronously:runner];

            if([result isError]) {
                return 1;
            }

            return 0;
        }
        @catch(NSException* ex) {
            NSLog(@"uncaught exception: %@", [ex reason]);
            return 1;
        }
        
        return 0;
    }
}
