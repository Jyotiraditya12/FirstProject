//
//  DetailViewController.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 08/07/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewerViewController.h"
#import "viewerLayOutOne.h"
#import "viewerLayOutTwo.h"
#import "viewerLayOutThree.h"
#import "viewerLayOutFour.h"
#import "viewerLayOutNine.h"
#import "testClasViewController.h"
#import "PopupViewController.h"

@class  viewerLayOutOne;
@class viewerLayOutTwo;
@class viewerLayOutThree;
@class viewerLayOutFour;
@class viewerLayOutNine;
@class ViewerViewController;
@class testClasViewController;
@class PopupViewController;



@interface DetailViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIAlertViewDelegate>
{
@public
    UIImageView *popupView;
    UIScrollView *scrollView;
    UIWebView *webView;
    UIImage  *temp;
    NSMutableArray *exifArray;
    UITableView *exifTableView;
    NSArray *substrings;
    
    //for webBrowser
    IBOutlet UITextField *browserAddressbar;
    IBOutlet UIToolbar *browserToolBar;
    IBOutlet UIWebView *webBrowserView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIBarButtonItem *done;
    IBOutlet UIBarButtonItem *close;
    NSString *browserLink;
    UIAlertView *addWebLink;
    NSString *videoAlbumExtraImageString;
    BOOL videoExtraImage;
    BOOL videoExtraWebLink;

}
-(IBAction)Done:(id)sender;
-(IBAction)close:(id)sender;
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

@end
