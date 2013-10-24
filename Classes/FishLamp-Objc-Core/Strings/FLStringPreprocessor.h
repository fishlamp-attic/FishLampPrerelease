//
//  FLStringPreprocessor.h
//  FishLamp-Objc
//
//  Created by Mike Fullerton on 10/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCoreRequired.h"

@protocol FLStringPreprocessor;

@protocol FLStringPreprocessorEventHandler <NSObject>

- (void) stringPreprocessor:(id<FLStringPreprocessor>) preprocessor
              didFindString:(NSString*) string;

- (void) stringPreprocessor:(id<FLStringPreprocessor>) preprocessor
    didFindAttributedString:(NSAttributedString*) string;

- (void) stringPreprocessorDidFindEOL:(id<FLStringPreprocessor>) preprocessor;

@end

@protocol FLStringPreprocessor <NSObject>

- (void) processString:(NSString*) string
          eventHandler:(id<FLStringPreprocessorEventHandler>) eventHandler;

- (void) processAttributedString:(NSAttributedString*) string
                    eventHandler:(id<FLStringPreprocessorEventHandler>) eventHandler;
@end

@interface FLStringFormatterLineProprocessor : NSObject<FLStringPreprocessor>
FLSingletonProperty(FLStringFormatterLineProprocessor);
@end


