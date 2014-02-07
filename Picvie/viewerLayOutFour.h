//
//  viewerLayOutFour.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailViewController.h"
@class DetailViewController;
@interface viewerLayOutFour : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
@public
    IBOutlet UIImageView *fourimageViewOne;
    IBOutlet UIImageView *fourimageViewTwo;
    IBOutlet UIImageView *fourimageViewThree;
    IBOutlet UIImageView *fourimageViewFour;
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *tapRecognizer1;
    UITapGestureRecognizer *tapRecognizer2;
    UITapGestureRecognizer *tapRecognizer3;
    NSMutableArray *touchImageURL;
    UIImageView *imageView;
    ALAssetsLibrary* assetsLibrary;
    BOOL Press;
    BOOL fourFirstSelect;
    BOOL fourSecondSelect;
    BOOL fourThirdSelect;
    NSString *extraString;
    BOOL showExtraImage;
    BOOL showExifData;
    BOOL showPopUp;
    BOOL firstExif;
    BOOL secondExif;
    BOOL thirdExif;
    BOOL webLink;
    NSString *webString;
}
@property (nonatomic, retain) IBOutlet UIImageView *fourimageViewOne;
@property (nonatomic, retain) IBOutlet UIImageView *fourimageViewTwo;
@property (nonatomic, retain) IBOutlet UIImageView *fourimageViewThree;
@property (nonatomic, retain) IBOutlet UIImageView *fourimageViewFour;
@property (nonatomic, retain) NSMutableArray *touchImageURL;

@end
