//
//  viewerLayOutTwo.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 04/02/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewerViewController.h"
#import "DetailViewController.h"

@interface viewerLayOutTwo : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
@public
    IBOutlet UIImageView *twoimageViewOne;
    IBOutlet UIImageView *twoimageViewTwo;
    NSMutableArray *touchImageURL;
    UIImageView *imageView;
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *tapRecognizer1;
    ALAssetsLibrary* assetsLibrary;
    BOOL Press;
    BOOL firstSelect;
    NSString *extraString;
    BOOL showExtraImage;
    BOOL showExifData;
    BOOL showPopUp;
    BOOL firstExif;
    BOOL webLink;
    NSString *webString;
}
@property (nonatomic, retain) IBOutlet UIImageView *twoimageViewOne;
@property (nonatomic, retain) IBOutlet UIImageView *twoimageViewTwo;
@property (nonatomic, retain) NSMutableArray *touchImageURL;

@end

