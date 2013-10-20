//
//	FLGradientView.h
//	ShadowedTableView
//
//	Created by Mike Fullerton on 2009/08/21.
//	Copyright (c) 2013 Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#if IOS
//#import "FLWidgetView.h"
//#import "FLGradientWidget.h"
#endif

#import "FLView.h"
#import "FLColorRange.h"

@interface FLGradientView : FLCompatibleView {
@private
#if REFACTOR
	FLGradientWidget* _gradientWidget;
#endif

/*
    FLColorRange* _normalColorRange;
    FLColorRange* _highlightedColorRange;
    FLColorRange* _selectedColorRange;
    FLColorRange* _disabledColorRange;
    
    UIControlStateNormal       = 0,                       
    UIControlStateHighlighted  = 1 << 0,                  // used when UIControl isHighlighted is set
    UIControlStateDisabled     = 1 << 1,
    UIControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
*/
    
}

@property (readwrite, assign, nonatomic, getter=isHighlighted) BOOL highlighted;

#if REFACTOR
#if IOS
@property (readonly, strong, nonatomic) FLGradientWidget* gradient;
#endif
#endif

- (void) setColorRange:(FLColorRange*) range forControlState:(UIControlState) state;

// returns normal if a colorRange isn't set for state;
- (FLColorRange*) colorRangeForControlState:(UIControlState) state; 


@end

@interface FLBlackGradientView : FLCompatibleView
@end
