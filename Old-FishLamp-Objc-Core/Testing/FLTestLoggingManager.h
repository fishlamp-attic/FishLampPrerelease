//
//  FLTestLoggingManager.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"
#import "FLStringFormatter.h"
#import "FLLogger.h"

/**
 *  Manages the loggers. A logger is just a destinations for strings.
 */
@interface FLTestLoggingManager: FLLogger {
@private
    NSMutableArray* _loggers;
}

FLSingletonProperty(FLTestLoggingManager);

/**
 *  Add A logger a the end of the logger list. The first logger in the list gets the input.
 *  
 *  @param formatter a string formmater
 */
- (void) addLogger:(id<FLStringFormatter>) formatter;

/**
 *  Add a logger at the beginning of the logger list. The first logger in the list gets input.
 *  
 *  @param formatter a string formatter
 */
- (void) pushLogger:(id<FLStringFormatter>) formatter;

/**
 *  remove the first logger
 */
- (void) popLogger;


- (id<FLStringFormatter>) logger;
@end

/**
 *  helper macro for getting the singleton
 *  example: [FLTestOutput indent];
 */
#define FLTestOutput [FLTestLoggingManager instance]

/**
 *  Macro that all the tests should use for output.
 */
#define FLTestLog(__FORMAT__, ...) [[FLTestLoggingManager instance] appendLineWithFormat:__FORMAT__, ##__VA_ARGS__]