//
//  viewerLayOutOne.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "XMLParser.h"
#import "viewerLayOutTwo.h"
#import "viewerLayOutThree.h"
#import "viewerLayOutFour.h"
#import "viewerLayOutNine.h"
#import "PopupViewController.h"
#import "DetailViewController.h"
@class ViewerViewController;

@interface viewerLayOutOne: UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UIWebViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    @public
    IBOutlet UIImageView *imageViewOne;
    UIImageView *imageView;
    NSString *touchImageURL;
    UITapGestureRecognizer *tapRecognizer;
    NSString *extraString;
    BOOL showExtraImage;
    BOOL showExifData;
    BOOL showPopUp;
    BOOL Press;
    BOOL webLink;
    NSString *webString;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageViewOne;

@end
