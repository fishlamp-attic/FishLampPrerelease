//
//	SDKLabel+FLExtras.m
//	FishLamp
//
//	Created by Mike Fullerton on 10/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKLabel+FLExtras.h"
#import "SDKColor+FLUtils.h"
#import "FLColorModule.h"

@implementation SDKLabel (FLExtras)

- (CGSize) sizeThatFitsText:(CGSize) size
{
#if IOS
	return FLStringIsEmpty(self.text)? CGSizeZero : 
									[self.text sizeWithFont:self.font
									constrainedToSize:size
									lineBreakMode:self.lineBreakMode];
#else
// FIXME
    return CGSizeZero;
#endif
}
- (CGSize) sizeThatFitsText {
	return [self sizeThatFitsText:CGSizeMake(2048.0, 2048.0)];
}

- (CGSize) sizeToFitText {
	return [self sizeToFitText:CGSizeMake(2048.0, 2048.0)];

//	  return [self sizeToFitText:CGSizeMake(self.superview ? self.superview.bounds.size.width : 2048.0, 2048.0)];
}

- (CGSize) sizeToFitText:(CGSize) size {
	CGSize outSize = FLSizeOptimizeForView([self sizeThatFitsText:size]);
	
	CGRect r = self.frame;
	r.size = outSize;
	r = FLRectOptimizedForViewSize(r);
    
    if( !CGRectEqualToRect(r, self.frame)) {
        self.frame = r;
    }

	return outSize;
}

- (void) drawUnderline:(CGRect) inRect 
             withColor:(SDKColor*) color
         withLineWidth:(CGFloat) width {

	CGContextRef context = UIGraphicsGetCurrentContext();

    FLColorValues values = self.textColor.rgbColorValues;

	CGContextSetRGBStrokeColor(context, values.red, values.green, values.blue, values.alpha);

	// Draw them with a 1.0 stroke width.
	CGContextSetLineWidth(context, width);

	CGContextSetLineCap(context, kCGLineCapRound);

	float top = FLRectGetBottom(inRect) - 0.5;

	// Draw a single line from left to right
	CGContextMoveToPoint(context, FLRectGetLeft(inRect), top);
	CGContextAddLineToPoint(context, FLRectGetRight(inRect), top);
	CGContextStrokePath(context);
}

- (CGSize)sizeThatFitsWidth:(CGFloat)fixedWidth {   
    return [self sizeThatFitsText:CGSizeMake(fixedWidth, 2048)];
}

- (void)sizeToFitWidth:(CGFloat)fixedWidth {
#if IOS
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 0);
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0;
	[self sizeToFit];
#endif

// FIXME
}

- (void) addGlow {
#if IOS
    self.layer.shadowColor = [self.textColor CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.shadowRadius = 10.0;
    self.layer.shadowOpacity = 0.5;
    self.clipsToBounds = NO;
#endif
}

@end
