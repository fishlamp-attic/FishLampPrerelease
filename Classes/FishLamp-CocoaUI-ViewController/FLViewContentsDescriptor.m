//
//	FLViewContentsDescriptor.m
//	FishLamp
//
//	Created by Mike Fullerton on 2/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewContentsDescriptor.h"
#import "FLProperties.h"
#import "FLViewController.h"

@interface FLViewContentsDescriptor ()
@property (readwrite, assign, nonatomic) UIEdgeInsets padding;
@end

@implementation FLViewContentsDescriptor

@synthesize padding = _padding;

FLSynthesizeStructProperty(hasStatusBar, setHasStatusBar, BOOL, _flags);
FLSynthesizeStructProperty(topItem, setTopItem, FLViewContentItem, _flags);
FLSynthesizeStructProperty(bottomItem, setBottomItem, FLViewContentItem, _flags);

- (BOOL) isValid {
    return self.topItem != FLViewContentItemInvalid && self.bottomItem != FLViewContentItemInvalid;
}

- (BOOL) isEmpty {
    return	self.topItem == FLViewContentItemNone && 
			self.bottomItem == FLViewContentItemNone;
}

- (id) init {
    self = [super init];
    if(self) {
        self.topItem = FLViewContentItemNone;
        self.bottomItem = FLViewContentItemNone;
    }
    
    return self;
}

- (id) initWithTop:(FLViewContentItem) top
            bottom:(FLViewContentItem) bottom
      hasStatusBar:(BOOL) hasStatusBar {
    self = [super init];
    if(self) {
        self.topItem = top;
        self.bottomItem = bottom;
        self.hasStatusBar = hasStatusBar;
    }
    
    return self;
}
    
- (id) initWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
      hasStatusBar:(BOOL) hasStatusBar
    padding:(UIEdgeInsets) padding {
    self = [super init];
    if(self) {
        self.topItem = top;
        self.bottomItem = bottom;
        self.padding = padding;
        self.hasStatusBar = hasStatusBar;
    }
    
    return self;
}
    
+ (id) viewContentsDescriptorWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
      hasStatusBar:(BOOL) hasStatusBar {
    return FLAutorelease([[[self class] alloc] initWithTop:top bottom:bottom hasStatusBar:hasStatusBar]);
}

+ (id) viewContentsDescriptorWithTop:(FLViewContentItem) top
    bottom:(FLViewContentItem) bottom
      hasStatusBar:(BOOL) hasStatusBar
    padding:(UIEdgeInsets) padding {
    return FLAutorelease([[[self class] alloc] initWithTop:top bottom:bottom hasStatusBar:hasStatusBar padding:padding]);
}

+ (id) viewContentsDescriptorWithViewContentsDescriptor:(FLViewContentsDescriptor*) original {
    return FLAutorelease([[[self class] alloc] initWithViewContentsDescriptor:original]);
}

+ (id) viewContentsDescriptor {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (FLViewContentsDescriptor*) emptyDescriptor {
    FLReturnStaticObject(
        [[FLViewContentsDescriptor alloc] init];
    );
}

+ (FLViewContentsDescriptor*) descriptorWithTopStatusAndToolbar {
    FLReturnStaticObject([[FLViewContentsDescriptor alloc] initWithTop:FLViewContentItemToolbar bottom:FLViewContentItemNone hasStatusBar:YES]; );
}

+ (FLViewContentsDescriptor*) descriptorWithTopStatusAndToolbarAndBottomTabBar {
    FLReturnStaticObject([[FLViewContentsDescriptor alloc] initWithTop:FLViewContentItemToolbar bottom:FLViewContentItemTabBar hasStatusBar:YES]; );
}

+ (FLViewContentsDescriptor*) descriptorWithStatusBar {
    FLReturnStaticObject([[FLViewContentsDescriptor alloc] initWithTop:FLViewContentItemNone bottom:FLViewContentItemNone hasStatusBar:YES]; );
}

+ (FLViewContentsDescriptor*) descriptorWithTopStatusAndToolbarAndBottomToolbar {
    FLReturnStaticObject([[FLViewContentsDescriptor alloc] initWithTop:FLViewContentItemToolbar bottom:FLViewContentItemToolbar hasStatusBar:YES]; );
}

- (BOOL)isEqual:(id)object {
    if(!object) return NO;
    FLViewContentsDescriptor* desc = object;
    return  desc.topItem == self.topItem &&
            desc.bottomItem == self.bottomItem && 
            UIEdgeInsetsEqualToEdgeInsets(desc.padding, self.padding);    
}

- (NSUInteger)hash {
    return self.topItem + self.bottomItem + _padding.left + _padding.right + _padding.top + _padding.bottom;
}

- (id) initWithViewContentsDescriptor:(FLViewContentsDescriptor*) original {
    self = [super init];
    if(self) {
        self.topItem = original.topItem;
        self.bottomItem = original.bottomItem;
        self.padding = original.padding;
        self.hasStatusBar = original.hasStatusBar;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[FLViewContentsDescriptor alloc] initWithViewContentsDescriptor:self];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.topItem forKey:@"top"];
    [aCoder encodeInt:self.bottomItem forKey:@"bottom"];
    [aCoder encodeBool:self.hasStatusBar forKey:@"status"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:_padding] forKey:@"padding"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.topItem = [aDecoder decodeIntForKey:@"top"];
        self.bottomItem = [aDecoder decodeIntForKey:@"bottom"];
        self.hasStatusBar = [aDecoder decodeBoolForKey:@"status"];
        self.padding = [[aDecoder decodeObjectForKey:@"padding"] UIEdgeInsetsValue];
    }
    
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[FLMutableViewContentsDescriptor alloc] initWithViewContentsDescriptor:self];
}

@end

@implementation FLMutableViewContentsDescriptor

+ (FLMutableViewContentsDescriptor*) mutableViewContentsDescriptor {
    return FLAutorelease([[FLMutableViewContentsDescriptor alloc] init]);
}

@dynamic topItem;
@dynamic bottomItem;
@dynamic padding;
@dynamic hasStatusBar;
@end

@implementation SDKViewController (FLViewContentsDescriptor)

FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, _viewContentsDescriptor, setViewContentsDescriptor, FLViewContentsDescriptor*);

- (BOOL) viewEnclosesStatusBar {
#if IOS
    return YES;
#else 
    return NO;
#endif
}

- (FLViewContentsDescriptor*) viewContentsDescriptor {
    FLViewContentsDescriptor* descriptor = self._viewContentsDescriptor;
    if(!descriptor) {
        descriptor = [self.parentViewController viewContentsDescriptor];
    }
    
    if(!descriptor) {
        descriptor = [FLViewContentsDescriptor descriptorWithStatusBar];
    }
    
    return descriptor;
}

#if IOS
- (CGFloat) statusBarInset {
    FLViewContentsDescriptor* contents = self.viewContentsDescriptor;
    if (contents.hasStatusBar && 
        self.viewEnclosesStatusBar &&
        ![[UIApplication sharedApplication] isStatusBarHidden]) {
        return [UIDevice currentDevice].statusBarHeight;
    } 
    return 0;
}
#endif

- (CGFloat) contentViewInsetTop {
    FLViewContentsDescriptor* contents = self.viewContentsDescriptor;
    
#if IOS
	CGFloat outTop = contents.padding.top + self.statusBarInset;
	switch(contents.topItem) {
		case FLViewContentItemToolbar:
			outTop += [UIDevice currentDevice].toolbarHeight;
			break;
			
		case FLViewContentItemNavigationBar:
			outTop += [UIDevice currentDevice].navigationBarHeight;
			break;
			
		default:
			break;
	}
    
	return outTop;
#else
    return contents.padding.top;
#endif
}

- (CGFloat) contentViewInsetBottom {
    FLViewContentsDescriptor* contents = self.viewContentsDescriptor;
    
#if IOS
    CGFloat outBottom = contents.padding.bottom;
	switch(contents.bottomItem) {
		case FLViewContentItemToolbar:
			outBottom += [UIDevice currentDevice].toolbarHeight;
			break;
			
		case FLViewContentItemTabBar:
			outBottom += [UIDevice currentDevice].tabBarHeight;
			break;
			
		default:
		break;
		
	}
	
	return outBottom;
#else
    return contents.padding.bottom;
#endif
}

- (CGFloat) contentViewInsetLeft {
    return self.viewContentsDescriptor.padding.left;
}

- (CGFloat) contentViewInsetRight {
    return self.viewContentsDescriptor.padding.right;
}

- (UIEdgeInsets) contentViewInsets {
#if IOS
	return UIEdgeInsetsMake([self contentViewInsetTop], 
                            [self contentViewInsetLeft], 
                            [self contentViewInsetBottom], 
                            [self contentViewInsetRight]);
#endif
    
    return UIEdgeInsetsZero;
}

- (CGRect) contentViewFrameInBounds:(CGRect) bounds {
    return UIEdgeInsetsInsetRect(bounds, self.contentViewInsets);
} 

@end

/*
#if FLViewContentsDescriptorPadding
const struct FLViewContentsDescriptor FLViewContentsDescriptorInvalid = { FLViewContentItemInvalid, FLViewContentItemInvalid, {0, 0, 0, 0}};
const struct FLViewContentsDescriptor FLViewContentsDescriptorNone = { FLViewContentItemNone, FLViewContentItemNone, {0, 0, 0, 0}};
#else
const struct FLViewContentsDescriptor FLViewContentsDescriptorInvalid = { FLViewContentItemInvalid, FLViewContentItemInvalid};
const struct FLViewContentsDescriptor FLViewContentsDescriptorNone = { FLViewContentItemNone, FLViewContentItemNone};
#endif
 
CGFloat FLViewContentsDescriptorCalculateTop( FLViewContentsDescriptor contents)
{
#if FLViewContentsDescriptorPadding
	CGFloat top = contents.padding.top;
#else
	CGFloat top = 0;
#endif	  
	switch(contents.top)
	{
		case FLViewContentItemNavigationBarAndStatusBar:
			top += [UIDevice currentDevice].navigationBarHeight + [UIDevice currentDevice].statusBarHeight;
			break;
			
		case FLViewContentItemToolbarAndStatusBar:
			top += [UIDevice currentDevice].toolbarHeight + [UIDevice currentDevice].statusBarHeight;
			break;
	
		case FLViewContentItemToolbar:
			top += [UIDevice currentDevice].toolbarHeight;
			break;
			
		case FLViewContentItemNavigationBar:
			top += [UIDevice currentDevice].navigationBarHeight;
			break;
			
		case FLViewContentItemStatusBar:
			top += [UIDevice currentDevice].statusBarHeight;
			break;
			
		default:
			break;
	}
	
	return top;
}

CGFloat FLViewContentsDescriptorCalculateBottom( FLViewContentsDescriptor contents)
{
#if FLViewContentsDescriptorPadding
   CGFloat bottom = contents.padding.bottom;
#else
   CGFloat bottom = 0;
#endif
						
   switch(contents.bottom)
	{
		case FLViewContentItemNavigationBarAndStatusBar:
		case FLViewContentItemToolbarAndStatusBar:
			FLAssertFailedWithComment(@"can't have status bar on bottom");
			break;
		
		case FLViewContentItemToolbar:
			bottom += [UIDevice currentDevice].toolbarHeight;
			break;
			
		case FLViewContentItemTabBar:
			bottom += [UIDevice currentDevice].tabBarHeight;
			break;
			
		default:
		break;
		
	}
	
	return bottom;
}

CGRect FLViewContentsDescriptorCalculateContainerRect(CGRect bounds, FLViewContentsDescriptor contents)
{
	CGFloat top = FLViewContentsDescriptorCalculateTop(contents);
	bounds.origin.y = top;
	bounds.size.height -= (top + FLViewContentsDescriptorCalculateBottom(contents));
	return bounds;
} 

#if FLViewContentsDescriptorPadding
UIEdgeInsets FLViewContentsDescriptorPaddingForRectLayout(FLViewContentsDescriptor contents)
{
	UIEdgeInsets padding = contents.padding;
	padding.top += FLViewContentsDescriptorCalculateTop(contents);
	padding.bottom += FLViewContentsDescriptorCalculateBottom(contents);
	return padding;
	return UIEdgeInsetsMake(FLViewContentsDescriptorCalculateTop(contents), 0, FLViewContentsDescriptorCalculateBottom(contents), 0);
}
#endif	  

*/