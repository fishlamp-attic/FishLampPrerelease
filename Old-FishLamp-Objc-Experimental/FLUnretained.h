//
//  FLUnretained.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/16/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"

#import "FishLampCore.h"
#import "FLSimpleNotifier.h"
#import "FLWeakReference.h"

@interface FLUnretained : NSProxy {
@private
	FLWeakReference* _weakRef;
	__unsafe_unretained id _deadObject;
}
@property (readonly, strong) FLSimpleNotifier* notifier;
@property (readwrite, assign) id object;
- (id) initWithObject:(id) object;
+ (id) unretained:(id) object;
@end

@interface NSObject (FLUnretained)
- (id) unretained;
@end