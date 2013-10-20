//
//  FLTextViewLogger.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLamp.h"
#import "FLStringFormatter.h"

@interface FLTextViewLogger : FLStringFormatter<FLStringFormatterOutput> {
@private
    NSTextView* _textView;
    NSMutableAttributedString* _buffer;
    NSTimeInterval _lastUpdate;

    NSInteger _indentLevel;
}

@property (readwrite, strong, nonatomic) NSTextView* textView;

- (id) initWithTextView:(NSTextView*) textView;
+ (id) textViewLogger:(NSTextView*) textView;

- (void) clearContents;

@end
