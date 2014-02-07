//
//  testClasAppDelegate.h
//  picVie
//
//  Created by Pronto on 23/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewerViewController.h"


@class ViewerViewController;

@interface testClasAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    
    ViewerViewController *viewController;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewerViewController *viewController;

@end
