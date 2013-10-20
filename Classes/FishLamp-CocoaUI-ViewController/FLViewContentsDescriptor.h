//
//	FLViewContentsDescriptor.h
//	FishLamp
//
//	Created by Mike Fullerton on 2/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"
#import "FLRectLayout.h"

typedef enum { 
	FLViewContentItemInvalid,
	FLViewContentItemNone,
	FLViewContentItemToolbar,
	FLViewContentItemTabBar,
	FLViewContentItemNavigationBar
} FLViewContentItem;

//#define FLViewContentsDescriptorPadding 1

@interface FLViewContentsDescriptor : NSObject<NSCopying, NSMutableCopying, NSCoding> {
@private
	struct {
        FLViewContentItem topItem:8;
        FLViewContentItem bottomItem:8;
        unsigned int hasStatusBar;
    } _flags;
    
	UIEdgeInsets _padding;
} 

@property (readonly, assign, nonatomic) BOOL hasStatusBar;
@property (readonly, assign, nonatomic) FLViewContentItem topItem;
@property (readonly, assign, nonatomic) FLViewContentItem bottomItem;
@property (readonly, assign, nonatomic) UIEdgeInsets padding;

@property (readonly, assign, nonatomic) BOOL isValid;
@property (readonly, assign, nonatomic) BOOL isEmpty;

- (id) initWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
    hasStatusBar:(BOOL) hasStatusBar;

- (id) initWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
    hasStatusBar:(BOOL) hasStatusBar
    padding:(UIEdgeInsets) padding;

- (id) initWithViewContentsDescriptor:(FLViewContentsDescriptor*) original;

+ (id) viewContentsDescriptor;

+ (id) viewContentsDescriptorWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
    hasStatusBar:(BOOL) hasStatusBar;

+ (id) viewContentsDescriptorWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
    hasStatusBar:(BOOL) hasStatusBar
    padding:(UIEdgeInsets) padding;

+ (id) viewContentsDescriptorWithViewContentsDescriptor:(FLViewContentsDescriptor*) original;

+ (FLViewContentsDescriptor*) emptyDescriptor;

+ (FLViewContentsDescriptor*) descriptorWithStatusBar;

+ (FLViewContentsDescriptor*) descriptorWithTopStatusAndToolbar;

+ (FLViewContentsDescriptor*) descriptorWithTopStatusAndToolbarAndBottomTabBar;

+ (FLViewContentsDescriptor*) descriptorWithTopStatusAndToolbarAndBottomToolbar;


@end

@interface FLMutableViewContentsDescriptor : FLViewContentsDescriptor

+ (FLMutableViewContentsDescriptor*) mutableViewContentsDescriptor;

@property (readwrite, assign, nonatomic) BOOL hasStatusBar;
@property (readwrite, assign, nonatomic) FLViewContentItem topItem;
@property (readwrite, assign, nonatomic) FLViewContentItem bottomItem;
@property (readwrite, assign, nonatomic) UIEdgeInsets padding;

@end

@interface SDKViewController (FLViewContentsDescriptor)

@property (readwrite, retain, nonatomic) FLViewContentsDescriptor* viewContentsDescriptor; // if not set, will get it from parentViewController or return emptyContentsDescriptor.

#if IOS
@property (readonly, assign, nonatomic) BOOL viewEnclosesStatusBar; // defaults to YES
- (CGFloat) statusBarInset; // returns according to settings and if it's visible.
#endif

- (CGFloat) contentViewInsetTop; // topItem + statusBarInset (if any)
- (CGFloat) contentViewInsetRight;
- (CGFloat) contentViewInsetLeft;
- (CGFloat) contentViewInsetBottom;

- (UIEdgeInsets) contentViewInsets;

- (CGRect) contentViewFrameInBounds:(CGRect) bounds;

@end


/*
extern
const FLViewContentsDescriptor FLViewContentsDescriptorInvalid;

extern
const struct FLViewContentsDescriptor FLViewContentsDescriptorNone;

NS_INLINE
BOOL FLViewContentsDescriptorEqualToViewContentsDescriptor(FLViewContentsDescriptor lhs, FLViewContentsDescriptor rhs)
{
	return lhs.top == rhs.top && lhs.bottom == rhs.bottom;
}

NS_INLINE
FLViewContentsDescriptor FLViewContentsDescriptorMake(	FLViewContentItem top, 
								FLViewContentItem bottom)
{
#if FLViewContentsDescriptorPadding
	 FLViewContentsDescriptor contents = { top, bottom, { 0, 0, 0, 0 } };
#else
	 FLViewContentsDescriptor contents = { top, bottom };
#endif
	return contents;
} 

#if FLViewContentsDescriptorPadding
NS_INLINE
FLViewContentsDescriptor FLViewContentsDescriptorMakeWithItemsAndPadding( FLViewContentItem top, 
											FLViewContentItem bottom,
											UIEdgeInsets padding)
{
	FLViewContentsDescriptor contents;
	contents.top = top;
	contents.bottom = bottom;
	contents.padding = padding;
	return contents;
} 
					   

NS_INLINE
FLViewContentsDescriptor FLViewContentsDescriptorMakeWithPadding( UIEdgeInsets padding)
{
	FLViewContentsDescriptor contents;
	contents.top = FLViewContentItemNone;
	contents.bottom = FLViewContentItemNone;
	contents.padding = padding;
	return contents;
}
#endif	
NS_INLINE
BOOL FLViewContentsDescriptorIsEmpty( FLViewContentsDescriptor contents)
{
#if FLViewContentsDescriptorPadding
	return	contents.top == FLViewContentItemNone && contents.padding.top == 0 && 
			contents.bottom == FLViewContentItemNone && contents.padding.bottom == 0;
#else
	return	contents.top == FLViewContentItemNone && 
			contents.bottom == FLViewContentItemNone;
#endif
}

//NS_INLINE
//BOOL FLViewContentsDescriptorTopIsValid(FLViewContentsDescriptor contents)
//{
//	  return contents.top != FLViewContentItemInvalid;
//}
//
//NS_INLINE
//BOOL FLViewContentsDescriptorBottomIsValid(FLViewContentsDescriptor contents)
//{
//	  return contents.bottom != FLViewContentItemInvalid;
//}

NS_INLINE
BOOL FLViewContentsDescriptorIsValid( FLViewContentsDescriptor contents)
{
	return !FLViewContentsDescriptorEqualToViewContentsDescriptor(contents, FLViewContentsDescriptorInvalid);
}

//NS_INLINE
//BOOL FLViewContentsDescriptorHasLayout( FLViewContentsDescriptor contents)
//{
//	  return FLViewContentsDescriptorIsEmpty(contents);
//}


#if FLViewContentsDescriptorPadding
NS_INLINE
CGFloat FLViewContentsDescriptorMinWidth(CGFloat width, FLViewContentsDescriptor contents)
{
	return width + contents.padding.left + contents.padding.right;
}

NS_INLINE
CGFloat FLViewContentsDescriptorMinHeight(CGFloat height, FLViewContentsDescriptor contents)
{
	return height + contents.padding.top + contents.padding.bottom;
}
#endif	

extern CGFloat FLViewContentsDescriptorCalculateTop( FLViewContentsDescriptor contents);
extern CGFloat FLViewContentsDescriptorCalculateBottom( FLViewContentsDescriptor contents);
extern CGRect FLViewContentsDescriptorCalculateContainerRect(CGRect bounds, FLViewContentsDescriptor contents);

#if FLViewContentsDescriptorPadding
extern UIEdgeInsets FLViewContentsDescriptorPaddingForRectLayout(FLViewContentsDescriptor contents);
#else
NS_INLINE
UIEdgeInsets FLViewContentsDescriptorPaddingForRectLayout(FLViewContentsDescriptor contents)
{
	return UIEdgeInsetsMake(FLViewContentsDescriptorCalculateTop(contents), 0, FLViewContentsDescriptorCalculateBottom(contents), 0);
}
#endif


NS_INLINE
CGRect FLViewContentsDescriptorCalculateRectVertically(CGRect containeeRect, 
	CGRect containerRect,	  
	FLViewContentsDescriptor contents,
	FLRectLayout rectLayout)
{
	return FLRectPositionRectInRectVerticallyWithPadding(rectLayout, containerRect, containeeRect, FLViewContentsDescriptorPaddingForRectLayout(contents));
}

NS_INLINE
CGRect FLViewContentsDescriptorCalculateRectHorizonally(CGRect containeeRect, 
	CGRect containerRect,	  
	FLViewContentsDescriptor contents,
	FLRectLayout rectLayout)
{
	return FLRectPositionRectInRectHorizontallyWithPadding(rectLayout, containerRect, containeeRect, FLViewContentsDescriptorPaddingForRectLayout(contents));
}
	
NS_INLINE
CGRect FLViewContentsDescriptorCalculateRect(
	CGRect containeeRect, 
	CGRect containerRect,	  
	FLViewContentsDescriptor contents,
	FLRectLayout rectLayout)
{
	return FLViewContentsDescriptorCalculateRectVertically(
		FLViewContentsDescriptorCalculateRectHorizonally(containeeRect, containerRect, contents, rectLayout), 
		containerRect, 
		contents, 
		rectLayout);
}
*/
