//
//  FLAsyncMessageBroadcaster.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBroadcaster.h"
#import "FLCoreRequired.h"

@protocol FLAsyncMessageBroadcaster <NSObject>
@property (readonly, strong) FLBroadcaster* listeners;
//- (BOOL) hasListener:(id) listener;
//- (void) addListener:(id) listener;
//- (void) removeListener:(id) listener;
@end

#define FLSynthesizeDeprecatedObservableProperties() \
            - (void) addObserver:(id) observer { \
                [self addListener:observer]; \
            } \
            - (void) removeObserver:(id) listener { \
                [self removeListener:listener]; \
            } \
            - (FLBroadcaster*) observers { \
                return self.listeners; \
            }

//#define FLDeclareNotifierProperties() \
//            - (BOOL) hasListener:(id) listener;
//            - (void) addListener:(id) observer;
//
//            - (void) removeListener:(id) listener;
//            /* deprecated*/ \
//            @property (readonly, strong) FLBroadcaster* observers

#define FLSynthesizeAsyncMessageBroadcasterProperties(__IVAR_NAME__) \
            FLSynthesizeLazyGetter(listeners, FLBroadcaster*, __IVAR_NAME__, FLBroadcaster)

//            FLSynthesizeDeprecatedObservableProperties()

//            - (BOOL) hasListener:(id) listener { \
//                return [self.listeners hasListener:listener]; \
//            } \
//            - (void) addListener:(id) observer { \
//                [self.listeners addListener:observer]; \
//            } \
//            \
//            - (void) removeListener:(id) listener { \
//                [self.listeners removeListener:listener]; \
//            } 



@interface FLAsyncMessageBroadcaster : NSObject<FLAsyncMessageBroadcaster> {
@private
    FLBroadcaster* _notifier;
}
@end

