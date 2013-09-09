//
//  FLReadStream.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCocoaRequired.h"
#import "FLNetworkStream.h"
#import "FLInputSink.h"

@protocol FLReadStreamDelegate;

#define FLReadStreamBufferSize 32768

@interface FLReadStream : FLNetworkStream  {
@private
    CFReadStreamRef _streamRef;
    id<FLInputSink> _inputSink;
    uint8_t _buffer[FLReadStreamBufferSize];
}

- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security 
                    inputSink:(id<FLInputSink>) inputSink;

@property (readonly, assign, nonatomic) CFReadStreamRef streamRef;

// info
@property (readonly, assign) BOOL hasBytesAvailable;
@property (readonly, assign) unsigned long bytesRead;

// reading data from stream 
- (NSUInteger) readBytes:(uint8_t*) bytes 
               maxLength:(NSUInteger) maxLength;

- (CFReadStreamRef) allocReadStreamRef;

@end

@protocol FLReadStreamDelegate <FLNetworkStreamDelegate>
@optional
- (void) readStream:(FLReadStream*) stream willCloseWithResponseData:(id<FLInputSink>) sink;
@end