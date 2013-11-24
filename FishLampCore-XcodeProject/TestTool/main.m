//
//  main.m
//  FishLamp-Objc-Test-OSX-Universal-MRC
//
//  Created by Mike Fullerton on 9/9/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

////extern int FLTestToolMain(int argc, const char *argv[], NSString* bundleIdentifier, NSString* appName, NSString* version);
//
//int main(int argc, const char * argv[]) {
//#pragma unused (argc)
//#pragma unused (argv)
//
//    @autoreleasepool {
//        NSLog(@"hello world");
//        
////        FLTestToolMain(argc, argv, @"com.mycompany.FishLamp-Objc", "1.0.0");
//    }
//    return 0;
//}

#import "FLTTestToolMain.h"

int main(int argc, const char * argv[]) {
    return FLTTestToolMain(argc, argc, @"com.fishlamp.cocoa.tests", @"FLCocoaTestTool", @"1.0.0");
}

