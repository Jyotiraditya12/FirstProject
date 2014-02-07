//
//  AccordianView.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 06/05/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "pagesViewController.h"

@class AccordionView;
@protocol AccordionViewDelegate <NSObject>
@optional
- (void)accordion:(AccordionView *)accordion didChangeSelection:(NSIndexSet *)selection;
@end

@interface AccordionView : UIView <UIScrollViewDelegate>
{
    @public
    NSMutableArray *views;
    NSMutableArray *headers;
    NSMutableArray *originalSizes;
    UIScrollView *scrollView;
}

- (void)addHeader:(id)aHeader withView:(id)aView;
- (void)setOriginalSize:(CGSize)size forIndex:(NSUInteger)index;
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (readonly) BOOL isHorizontal;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) UIViewAnimationCurve animationCurve;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, strong) NSIndexSet *selectionIndexes;
@property (nonatomic, strong) id <AccordionViewDelegate> delegate;

@end
