//
//  viewerLayOutThree.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewerViewController.h"
#import "DetailViewController.h"

@interface viewerLayOutThree : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    @public
    IBOutlet UIImageView *threeimageViewOne;
    IBOutlet UIImageView *threeimageViewTwo;
    IBOutlet UIImageView *threeimageViewThree;
    NSMutableArray *touchImageURL;
    UIImageView *imageView;
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *tapRecognizer1;
    UITapGestureRecognizer *tapRecognizer2;
    ALAssetsLibrary* assetsLibrary;
    NSString *extraString;
    BOOL showExtraImage;
    UIImage *temp;
    BOOL Press;
    BOOL threeFirstSelect;
    BOOL threeSecondSelect;
    BOOL showExifData;
    BOOL showPopUp;
    BOOL firstExif;
    BOOL secondExif;
    BOOL webLink;
    NSString *webString;
}
@property (nonatomic, retain) IBOutlet UIImageView *threeimageViewOne;
@property (nonatomic, retain) IBOutlet UIImageView *threeimageViewTwo;
@property (nonatomic, retain) IBOutlet UIImageView *threeimageViewThree;
@property (nonatomic, retain) NSMutableArray *touchImageURL;

@end
