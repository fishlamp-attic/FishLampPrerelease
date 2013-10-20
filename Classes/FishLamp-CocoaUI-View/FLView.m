//
//  FLView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/16/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLView.h"

@implementation FLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#if OSX
//- (void)drawRect:(NSRect)dirtyRect {
//    // set any NSColor for filling, say white:
//    SDKColor* bgColor = self.backgroundColor;
//    if(bgColor) {
//        [bgColor setFill];
//        NSRectFill(dirtyRect);
//    }
//}
#endif

//- (void) didAddSubview:(NSView*) view {
//    [super didAddSubview:view];
//    [self setNeedsLayout];
//}
//
//- (void) viewDidMoveToSuperview {
//    [super viewDidMoveToSuperview];
//    [self setNeedsLayout];
//}
//
//
//- (void)willRemoveSubview:(NSView *)subview {
//    [super willRemoveSubview:subview];
//    [self setNeedsLayout];
//}
//
//- (void) removeFromSuperview {
//    NSView* superview = FLAutoreleaseRetained([self superview]);
//    [super removeFromSuperview];
//    [superview setNeedsLayout]
//}
//
//- (void)setFrameSize:(NSSize)newSize {
//    if(!CGSizeEqualToSize(newSize, self.frame.size)) {
//        [[self superview]]
//    }
//    [super setFrameSize:newSize];
//}
//- (void)setFrame:(NSRect)frameRect {
//    if(!CGSizeEqualToSize(newSize.size, self.frame.size)) {
//    }
//    [super setFrame:frameRect];
//}


@end
