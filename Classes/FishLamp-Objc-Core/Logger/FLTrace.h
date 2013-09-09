//
//  FLTrace.h
//  FishLampCore
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreRequired.h"

#if DEBUG
#undef TRACE
#undef FLTrace
#undef FLTraceIf

#define FLTrace(__FORMAT__, ...) \
            FLLogToLogger([FLLogLogger instance], FLLogTypeTrace, __FORMAT__, ##__VA_ARGS__)

#define FLTraceIf(__CONDITION__, __FORMAT__, ...) \
            if(__CONDITION__) FLTrace(__FORMAT__, ##__VA_ARGS__)

#define TRACE 1

#endif
