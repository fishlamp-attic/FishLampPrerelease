//
//  FLConsoleLogSink.m
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLConsoleLogSink.h"
#import "FLPrintf.h"
#import "FLStringUtils.h"
#import "FLLogEntry.h"
#import "FLStackTrace.h"
#import "FLWhitespace.h"
#import "NSError+FLExtras.h"

@implementation FLConsoleLogSink

+ (id) consoleLogSink {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (FLLogSink*) consoleLogSink:(FLLogSinkOutputFlags) outputFlags {
    return FLAutorelease([[[self class] alloc] initWithOutputFlags:outputFlags]);
}


- (void) printLine:(FLLogEntry*) entry 
         logString:(NSString*) logString 
             range:(NSRange) range {
         
    if(FLTestAnyBit(self.outputFlags, FLLogOutputWithLocation | FLLogOutputWithStackTrace)) { 
        [FLPrintf appendLineWithFormat:@"%@    (%s:%d)",
                 [[logString substringWithRange:range] stringWithPadding_fl:80],
                 entry.stackTrace.fileName,
                 entry.stackTrace.lineNumber];
    } 
    else { 
        [FLPrintf appendLineWithFormat:@"%@", [[logString substringWithRange:range] stringWithPadding_fl:80]];
    }
}            

- (void) indent {
    [FLPrintf indent];
}

- (void) outdent {
    [FLPrintf outdent];
}

- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {

    NSString* logString = entry.logString;

//    if(FLTestAnyBit(self.outputFlags, FLLogOutputWithLocation | FLLogOutputWithStackTrace)) {
//        FLPrintFormat(@"%@%s:%d:\n", 
//                      whitespace,
//                      entry.stackTrace.fileName, 
//                      entry.stackTrace.lineNumber
//                      );
//        whitespace = [[FLWhitespace tabbedWithSpacesWhitespace] tabStringForScope:entry.indentLevel + 1];                      
//    }
//    
//    NSUInteger lastIndex = 0;
//    for(NSUInteger i = 0; i < logString.length; i++) {
//        
//        unichar c = [logString characterAtIndex:i];
//        if(c == '\n') {
//        
//            if(i > lastIndex) {
//                NSRange  range = NSMakeRange(lastIndex, i - lastIndex); 
//                [self printLine:entry logString:logString range:range];
//            }
//            else {
//                [FLPrintf appendBlankLine];
//            }
//        
//            lastIndex = i + 1;
//        }
//    }
//    
//    if(lastIndex < (logString.length - 1)) {
//        NSRange  range = NSMakeRange(lastIndex, logString.length - lastIndex); 
//        [self printLine:entry logString:logString range:range];
//    }

    if(FLTestAnyBit(self.outputFlags, FLLogOutputWithLocation | FLLogOutputWithStackTrace)) { 
        [FLPrintf appendLineWithFormat:@"%@    (%s:%d)",
                 [logString stringWithPadding_fl:80],
                 entry.stackTrace.fileName,
                 entry.stackTrace.lineNumber];
    } 
    else { 
        [FLPrintf appendLineWithFormat:@"%@", [logString stringWithPadding_fl:80]];
    }


    if(FLTestBits(self.outputFlags, FLLogOutputWithStackTrace)) {

        [[FLPrintfStringFormatter instance] indent:^{
            if(entry.stackTrace.callStack.depth) {
                for(int i = 0; i < entry.stackTrace.callStack.depth; i++) {
                    [FLPrintf appendLineWithFormat:@"%s", [entry.stackTrace stackEntryAtIndex:i]];
                }
            }
        }];
    }
    
//    if(FLTestAnyBit(self.outputFlags, FLLogOutputWithLocation | FLLogOutputWithStackTrace)) {
//        whitespace = [[FLWhitespace tabbedWithSpacesWhitespace] tabStringForScope:entry.indentLevel];                      
//        FLPrintFormat(@"%@}\n", whitespace);
//    }
}    

@end
