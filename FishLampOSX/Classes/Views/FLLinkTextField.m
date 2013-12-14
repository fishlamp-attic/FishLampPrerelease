//
//  FLLinkTextField.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLLinkTextField.h"
#import "FLAttributedString.h"
#import "FLColorModule.h"

@implementation FLLinkTextField



- (void)removeTrackingTags {
    if(_boundsTrackingTag) {
        [self removeTrackingRect:_boundsTrackingTag];
        _boundsTrackingTag = 0;
    }
}

- (void) dealloc {
    [self removeTrackingTags];
#if FL_MRC
	[super dealloc];
#endif
}

- (void)updateBoundsTrackingTag {
    [self removeTrackingTags];
    
    NSPoint loc = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
   
    BOOL inside = ([self hitTest:loc] == self);
   
    if (inside) {
        [[self window] makeFirstResponder:self]; // if the view accepts first responder status
    }
   
   _boundsTrackingTag = [self addTrackingRect:[self visibleRect] owner:self userData:nil assumeInside:inside];
}

- (BOOL)acceptsFirstResponder { 
    return YES;
} 

- (BOOL)becomeFirstResponder {
    return YES;
}

- (void)resetCursorRects {
	[self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
    [self updateBoundsTrackingTag];
}

- (void)mouseMoved:(NSEvent *)theEvent {
}

- (NSColor*) enabledColor {
    return [NSColor colorWithRGBRed:203 green:102 blue:10 alpha:1.0];
}

- (void) updateText {
    NSRange range = self.attributedStringValue.entireRange;
    NSMutableDictionary* attr = FLMutableCopyWithAutorelease([[self attributedStringValue] attributesAtIndex:0 effectiveRange:&range]);
    
    [attr setObject:[NSNumber numberWithBool:_mouseIn] forKey:NSUnderlineStyleAttributeName];

    if(_mouseDown) {
        [attr setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
    }
    else {
        [attr setObject:[self enabledColor] forKey:NSForegroundColorAttributeName];
    }
    
    
    NSAttributedString* newString = FLAutorelease([[NSAttributedString alloc] initWithString:self.stringValue attributes:attr]);
    
    [self setAttributedStringValue:newString];
    [self setNeedsDisplay:YES];

}

- (void)mouseUp:(NSEvent *)mouseEvent {
    _mouseDown = NO;
    [self updateText];

    if(_mouseIn) {
        [self performClick:self];
        
//        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.urlString]];
    }
}

- (void)mouseDown:(NSEvent *)theEvent  {
    _mouseDown = YES;
    [self updateText];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseIn = YES;
    
    [self updateText];
    
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseIn = NO;

    [self updateText];

    [self setNeedsDisplay:YES];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self updateText];
}

//- (void) setAttributedStringValue:(NSAttributedString *)obj {
//    [super setAttributedStringValue:obj];
//    [self updateText];
//}

//- (void)drawRect:(NSRect)rect {
//	
////    if( _mouseDown && _mouseIn) {
////        self.textColor = [NSColor orangeColor]; 
////    }
////    else {
////        self.textColor = _color;
////    }
////
////    [self.textColor set];
////
////	[super drawRect:rect];
//	
////	if ( _mouseIn ) {
////    	NSRect bounds = [self bounds];
////		[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(bounds)  + 2, NSMaxY(bounds))
////								  toPoint:NSMakePoint(NSWidth(bounds) - 2, NSMaxY(bounds))];
////	}
//}



- (void)viewWillMoveToWindow:(NSWindow*) window {
    
    if(!window) {
        [self removeTrackingTags];
    }
    else {
        [self updateBoundsTrackingTag];
    }
    
    [super viewWillMoveToWindow:window];
}

@end