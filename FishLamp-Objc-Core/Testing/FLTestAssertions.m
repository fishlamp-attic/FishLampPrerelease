//
//  FLTestAssertions.m
//  FishLampCore
//
//  Created by Mike Fullerton on 9/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestAssertions.h"
#import "FLTestLoggingManager.h"

NSException* FLLogTestException(NSException* ex) {

    id logger = [[FLTestLoggingManager instance] logger];

    [logger appendLineWithFormat:[ex.error description]];

//    [ appendLineWithFormat logObject:ex];
    return ex;
}
