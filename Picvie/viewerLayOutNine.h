//
//  viewerLayOutNine.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailViewController.h"

@class DetailViewController;
@interface viewerLayOutNine : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    @public
    IBOutlet UIImageView *nineimageViewOne;
    IBOutlet UIImageView *nineimageViewTwo;
    IBOutlet UIImageView *nineimageViewThree;
    IBOutlet UIImageView *nineimageViewFour;
    IBOutlet UIImageView *nineimageViewFive;
    IBOutlet UIImageView *nineimageViewSix;
    IBOutlet UIImageView *nineimageViewSeven;
    IBOutlet UIImageView *nineimageViewEight;
    IBOutlet UIImageView *nineimageViewNine;
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *tapRecognizer1;
    UITapGestureRecognizer *tapRecognizer2;
    UITapGestureRecognizer *tapRecognizer3;
    UITapGestureRecognizer *tapRecognizer4;
    UITapGestureRecognizer *tapRecognizer5;
    UITapGestureRecognizer *tapRecognizer6;
    UITapGestureRecognizer *tapRecognizer7;
    UITapGestureRecognizer *tapRecognizer8;
    NSMutableArray *touchImageURL;
    UIImageView *imageView;
    ALAssetsLibrary* assetsLibrary;
    BOOL Press;
    BOOL nineFirstSelect;
    BOOL nineSecondSelect;
    BOOL nineThirdSelect;
    BOOL nineFourSelect;
    BOOL nineFiveSelect;
    BOOL nineSixSelect;
    BOOL nineSevenSelect;
    BOOL nineEightSelect;
    NSString *extraString;
    BOOL showExtraImage;
    BOOL showExifData;
    BOOL showPopUp;
    BOOL firstExif;
    BOOL secondExif;
    BOOL thirdExif;
    BOOL fourExif;
    BOOL fiveExif;
    BOOL sixExif;
    BOOL sevenExif;
    BOOL eightExif;
    BOOL webLink;
    NSString *webString;
}
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewOne;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewTwo;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewThree;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewFour;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewFive;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewSix;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewSeven;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewEight;
@property (nonatomic, retain) IBOutlet UIImageView *nineimageViewNine;
@property (nonatomic, retain) NSMutableArray *touchImageURL;

@end
