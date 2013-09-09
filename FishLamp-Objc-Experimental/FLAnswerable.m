//
//  FLAnswerable.m
//  FLCore
//
//  Created by Mike Fullerton on 11/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnswerable.h"

@interface FLAnswerable ()
@property (readwrite, strong, nonatomic) id object;
@end

@implementation FLAnswerable

@synthesize object = _object;
@synthesize answer = _answer;
@synthesize defaultAnswer = _defaultAnswer;

- (id) initWithDefaultAnswer:(BOOL) answer withObject:(id) object {
    self = [super init];
    if(self) {
        _defaultAnswer = answer;
        _answer = answer;
        self.object = object;
    }
    
    return self;
}

- (id) initWithDefaultAnswer:(BOOL) answer {
    return [self initWithDefaultAnswer:answer withObject:nil];
}

- (id) init {
    return [self initWithDefaultAnswer:NO withObject:nil];
}

+ (id) answerable:(BOOL) defaultAnswer {
    return FLAutorelease([[[self class] alloc] initWithDefaultAnswer:defaultAnswer]);
}

+ (id) answerable:(BOOL) defaultAnswer withObject:(id) object {
    return FLAutorelease([[[self class] alloc] initWithDefaultAnswer:defaultAnswer withObject:object]);
}

+ (id) answerable {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_object release];
    [super dealloc];
}
#endif

@end
