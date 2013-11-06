//
//  FLHorizontalCellLayout.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 1/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHorizontalGridArrangement.h"

@implementation FLHorizontalGridArrangement

+ (FLHorizontalGridArrangement*) horizontalCellLayout
{
    return FLAutorelease([[[self class] alloc] init]);
}

//- (CGSize) performArrangement:(NSArray*) views 
//                         inBounds:(CGRect) bounds
//{
////	CGFloat colWidth = bounds.size.width;
////
////// TODO: Not sure how the margins and innerInsets should work here.
////
//////    CGRect frame = bounds;
//////    bounds.origin.x += self.innerInsets.left;
//////    bounds.origin.y += self.innerInsets.top;
//////    bounds.size.width -= (self.innerInsets.left + self.innerInsets.right);
//////    bounds.size.height -= (self.innerInsets.top + self.innerInsets.bottom);
////
////    CGRect containerBounds = bounds;
////
////    NSInteger count = 0;
////	for(id view in views)
////	{
////		if([view isHidden]) 
////		{
////			continue;
////		}
////
////        containerBounds.origin.x = (containerBounds.size.width * count++);
////
//////        CGRect frame = containerBounds;
//////        bounds.origin.x += self.innerInsets.left;
//////        bounds.origin.y += self.innerInsets.top;
//////        bounds.size.width -= (self.innerInsets.left + self.innerInsets.right);
//////        bounds.size.height -= (self.innerInsets.top + self.innerInsets.bottom);
////
//////		UIEdgeInsets adjustedMargins = [self addouterInsetsToInsets:view];
//////		origin.x += adjustedMargins.left;
////		[view setLayoutFrame:containerBounds];
////    }
////    return CGSizeMake(FLRectGetRight(containerBounds), bounds.size.height);
//}

- (CGSize) layoutArrangeableObjects:(NSArray*) objects
                         inBounds:(CGRect) bounds {

/*
    CGSize cellSize = [self.delegate cellViewLayoutGetCellSize:self inBounds:bounds];

    NSInteger itemCount = views.count;
    NSInteger rowCount = bounds.size.height / cellSize.height;

    NSInteger columnCount = ((itemCount / rowCount) + (((itemCount % rowCount) > 0) ? 1 : 0));
    
    bounds.origin.x += self.innerInsets.left;
    bounds.origin.y += self.innerInsets.top;
    bounds.size.width = (columnCount * cellSize.width) + (self.innerInsets.left + self.innerInsets.right);
    bounds.size.height = (rowCount * cellSize.height) + self.innerInsets.top + self.innerInsets.bottom;

    NSInteger itemIndex = 0;

    for(NSInteger col = 0; col < columnCount; col++)
    {
        for(NSInteger row = 0; row < rowCount; row++)
        {
            id view = [views objectAtIndex:itemIndex++];
            if([view isHidden])
            {
                row--;
                continue;
            }
            
            
            CGRect frame = FLRectMake(  bounds.origin.x + (col * cellSize.width), 
                                        bounds.origin.y + (row * cellSize.height), 
                                        cellSize.width, 
                                        cellSize.height);

            UIEdgeInsets adjustedMargins = [self addouterInsetsToInsets:view];
            frame.origin.x += adjustedMargins.left;
            frame.origin.y += adjustedMargins.top;
            frame.size.width -= (adjustedMargins.left + adjustedMargins.right);
            frame.size.height -= (adjustedMargins.top + adjustedMargins.bottom);
            [view setFrame:frame];            
        }
    }
*/

    
//    for(NSInteger i = 0; i < rowCount; i++)
//    {
//        for(int j = 0; j < columnCount && itemIndex < itemCount; j++)
//        {
//            id view = [views objectAtIndex:itemIndex++];
//            if([view isHidden])
//            {
//                j--;
//                continue;
//            }
////            UIEdgeInsets adjustedMargins = [self addouterInsetsToInsets:view];
//            
//            CGRect frame = FLRectMake(bounds.origin.x + (j * cellSize.width), top, cellSize.width, cellSize.height);
//
////            frame.origin.x += adjustedMargins.left;
////            frame.origin.y += adjustedMargins.top;
////            frame.size.width -= (adjustedMargins.left + adjustedMargins.right);
////            frame.size.height -= (adjustedMargins.top + adjustedMargins.bottom);
//        
//            [view setLayoutFrame:frame];
//        }
//        
//        top += cellSize.height;
//    }
//    
    return bounds.size;
}



@end
