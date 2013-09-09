//
//  FLHttpStream.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLReadStream.h"
#import "FLHttpMessage.h"
#import "FLHttpRequestHeaders.h"
#import "FLStreamWorker.h"

@interface FLHttpStream : FLReadStream {
@private
    FLHttpMessage* _requestHeaders;
    FLHttpMessage* _responseHeaders;
    NSInputStream* _bodyStream;
}

@property (readonly, assign, nonatomic) unsigned long bytesWritten;

// if bodyStream == nil, it will use bodyData in request.
- (id) initWithHttpMessage:(FLHttpMessage*) request 
            withBodyStream:(NSInputStream*) bodyStream
            streamSecurity:(FLNetworkStreamSecurity) security
            inputSink:(id<FLInputSink>) inputSink;

+ (id) httpStream:(FLHttpMessage*) request 
   withBodyStream:(NSInputStream*) bodyStream
   streamSecurity:(FLNetworkStreamSecurity) security
        inputSink:(id<FLInputSink>) inputSink;


@end

@protocol FLHttpStreamDelegate <FLReadStreamDelegate>
- (void) httpStream:(FLHttpStream*) stream 
willCloseWithResponseHeaders:(FLHttpMessage*) responseHeaders 
       responseData:(id<FLInputSink>) responseData;
@end



