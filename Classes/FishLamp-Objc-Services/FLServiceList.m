//
//  FLServiceList.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLServiceList.h"

@interface FLServiceList ()
@property (readwrite, assign) BOOL isOpen;
@end

@implementation FLServiceList

@synthesize services = _services;
@synthesize isOpen = _isOpen;

+ (id) serviceList {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	self = [super init];
	if(self) {
		_services = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_services release];
    [super dealloc];
}
#endif

- (void) willOpen {
}

- (void) didCloseWithResult:(FLPromisedResult) result {
}

- (void) didOpenWithResult:(FLPromisedResult) result {
}

- (void) willClose {

}

- (FLPromise*) openService:(fl_result_block_t) completion {

    FLConfirmWithComment(!self.isOpen, @"%@ service is already open", [self description]);

    [self willOpen];

    FLFinisher* finisher = [FLForegroundFinisher finisherWithBlock:completion];

    [finisher addPromiseWithBlock:^(FLPromisedResult result) {
        self.isOpen = YES;
        [self didOpenWithResult:result];
    }];

    // For now do nothing

    [finisher setFinished];

    return finisher.firstPromise;
}

- (FLPromise*) closeService:(fl_result_block_t) completion {

    FLConfirmWithComment(self.isOpen, @"%@ service is already open", [self description]);

    FLFinisher* finisher = [FLForegroundFinisher finisherWithBlock:^(FLPromisedResult result) {
        self.isOpen = NO;
        [self didCloseWithResult:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:FLServiceDidCloseNotificationKey object:self];
    }];

    NSMutableArray* services = FLMutableCopyWithAutorelease(_services);
    __block FLPromisedResult savedResult = FLSuccessfulResult;

    for(id<FLService> service in _services) {

        if([service isOpen]) {
            [service closeService:^(FLPromisedResult result) {

                if([result isError]) {
                    savedResult = [NSError fromPromisedResult:result];
                }

                [services removeObject:service];
                if(services.count == 0) {
                    [finisher setFinishedWithResult:savedResult];
                }
            }];
        }
        else {
            [services removeObject:service];
            if(services.count == 0) {
                [finisher setFinishedWithResult:savedResult];
            }
        }
    }

    return finisher.firstPromise;
}

- (void) addService:(id<FLService>) service {
    if(!_services) {
        _services = [[NSMutableArray alloc] init];
    }
    [_services addObject:service];
    [service.listeners addListener:self];
}

- (void) removeService:(id<FLService>) service {
    [_services removeObject:service];
    [service.listeners removeListener:self];
}

- (void) removeAllServices {
    [_services removeAllObjects];
}

//- (void) visitServicesWithStop:(void (^)(id service, BOOL* stop)) visitor stop:(BOOL*) stop {
//    for(id service in _services) {
//        if(*stop) {
//            break;
//        }
//
//        visitor(service, stop);
//
//        [service visitServicesWithStop:visitor stop:stop];
//        if(*stop) {
//            break;
//        }
//    }
//}

//- (void) visitServices:(void (^)(id service, BOOL* stop)) visitor {
//    BOOL stop = NO;
//    [self visitServicesWithStop:visitor stop:&stop];
//}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_services countByEnumeratingWithState:state objects:buffer count:len];
}

@end
