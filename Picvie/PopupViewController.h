//
//  UIViewController+PopupViewController.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 08/07/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@class DetailViewController;

typedef enum
{
    PopupViewAnimationFade = 0,

} PopupViewAnimation;
@interface UIViewController  (MJPopupViewController)

@property (nonatomic, retain) UIViewController *mj_popupViewController;

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(PopupViewAnimation)animationType;
- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(PopupViewAnimation)animationType dismissed:(void(^)(void))dismissed;
- (void)dismissPopupViewControllerWithanimationType:(PopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimation:(id)sender;

@end
