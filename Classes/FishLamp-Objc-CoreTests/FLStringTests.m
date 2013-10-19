//
//  FLFancyStringTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 5/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringTests.h"

@implementation FLStringTests

+ (FLTestGroup*) testGroup {
    return [FLTestGroup frameworkTestGroup];
}

- (void) testPrettyString1 {

    FLPrettyString* string = [FLPrettyString prettyString];

//    FLFancyString* builder = [FLFancyString stringBuilder];
//    
//    [builder appendLine:@"Hello"];
//    [builder indent];
//    [builder appendLine:@"World"];
//    [builder indent];
//    [builder appendLine:@"Testing 123"];
//    [builder outdent];
//    [builder appendLine:@"Farkle"];
//    
//    FLTestOutput([builder description]);
    
}

@end
