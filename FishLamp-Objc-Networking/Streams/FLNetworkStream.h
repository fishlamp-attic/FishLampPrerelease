//
//  FLNetworkStream.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLTimer.h"

@protocol FLNetworkStreamDelegate;
@protocol FLNetworkStreamEventHandler;

#define FLNetworkingIndividualThreads 1

typedef enum {
    FLNetworkStreamSecurityNone,
    FLNetworkStreamSecuritySSL
} FLNetworkStreamSecurity;

@interface FLNetworkStream : NSObject<FLTimerDelegate> {
@private
    FLTimer* _timer;
    FLNetworkStreamSecurity _streamSecurity;
    id<FLNetworkStreamEventHandler> _eventHandler;
    BOOL _open;
    BOOL _wasTerminated;
    NSTimeInterval _idleDuration;
    __unsafe_unretained id<FLNetworkStreamDelegate> _delegate;
}

@property (readonly, assign, nonatomic) FLNetworkStreamSecurity streamSecurity;

@property (readwrite, assign) id<FLNetworkStreamDelegate> delegate;
@property (readonly, strong) id<FLNetworkStreamEventHandler> eventHandler;

@property (readonly, assign, getter=isOpen) BOOL open;

@property (readonly, strong) FLTimer* timer;

- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security;
- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security
                 eventHandler:(id<FLNetworkStreamEventHandler>) eventHandler;

- (void) openStreamWithDelegate:(id<FLNetworkStreamDelegate>) delegate;

- (void) terminateStream;

+ (Class) defaultEventHandlerClass;
+ (void) setDefaultEventHandlerClass:(Class) aClass;

@end

@protocol FLNetworkStreamDelegate <NSObject>

- (NSTimeInterval) networkStreamGetTimeoutInterval:(FLNetworkStream*) stream;

@optional

- (void) networkStreamWillOpen:(FLNetworkStream*) networkStream;

- (void) networkStreamDidOpen:(FLNetworkStream*) networkStream;

- (void) networkStreamDidClose:(FLNetworkStream*) networkStream;

- (void) networkStream:(FLNetworkStream*) networkStream encounteredError:(NSError*) error;

- (void) networkStreamHasBytesAvailable:(FLNetworkStream*) networkStream;

- (void) networkStreamCanAcceptBytes:(FLNetworkStream*) networkStream;

- (void) networkStream:(FLNetworkStream*) networkStream didReadBytes:(NSNumber*) amountRead;

- (void) networkStream:(FLNetworkStream*) networkStream didWriteBytes:(NSNumber*) amountRead;

@end

@protocol FLNetworkStreamEventHandler <NSObject>

// treat this like a delegate - set it to nil in dealloc
@property (readwrite, assign) FLNetworkStream* stream;

+ (id) networkStreamEventHandler;

- (void) handleStreamEvent:(CFStreamEventType) eventType;
- (void) queueSelector:(SEL) selector;
- (void) queueSelector:(SEL) selector withObject:(id) object;

- (void) streamWillOpen:(void (^)()) completion;
- (void) streamDidClose;

- (NSRunLoop*) runLoop;
- (NSString*) runLoopMode;

@end

