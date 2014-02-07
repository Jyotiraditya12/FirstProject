//
//  testClasViewController.h
//  picVie
//
//  Created by Pronto on 23/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h> 
#import "oneLayOut.h"
#import "twoLayOut.h"
#import "threeLayOut.h"
#import "fourLayOut.h"
#import "nineLayOut.h"
#import "pagesViewController.h"
#import "XMLWriter.h"
#import "AccordionView.h"
#import "XMLParser.h"
#import "ViewerViewController.h"
#import "Reachability.h"

@class pagesViewController;
@class XMLParser;
@class ViewerViewController;

@interface testClasViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, MPMediaPickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
@public
    
    //Three View On Start of the Apps
    IBOutlet UIView *leftView;  
    IBOutlet UIView *toprightView;
    IBOutlet UIView *bottomrightView;
    IBOutlet UINavigationBar *navigationBar;
  
    //ALAssetsLibray Variable
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groups;
    ALAssetsGroup *assetsGroup;
    ALAsset *asset;
  
    //store the image url here
    NSMutableArray *assets;
    NSString *Path ;
    
    //show all images on UIScrollView
    UIScrollView *myScrollView;
    UIScrollView *videoScrollView;
     UIScrollView *audioScrollView;
    UIActivityIndicatorView *activityIndicator;
    CGFloat scaleSize;
    IBOutlet UILabel *pageCountLabel;
    
    //Object initialization
    //ViewerViewController
    
    // Will handle thumbnail of images
    NSMutableArray *imageThumbnailArray;
    NSMutableArray *videoThumbnailArray;
    
    // Will handle original images
    UIButton *buttonImage;
    BOOL clicked;
    
    //object of PagesViewController For Layout
    pagesViewController *pages;
    
    int oneImageCounter;
    int twoImageCounter;
    int threeImageCounter;
    int fourImageCounter;
    int nineImageCounter;
    BOOL builderNav;
    UILongPressGestureRecognizer *longPressGesture;
    
    //final Storing Dynamic Array
    NSMutableArray *pageCollection;
    NSMutableArray *imageURL;
    NSString * currentYear ;
    BOOL Allow;
    BOOL pageFill;
    int extraImageCount;
    int extraVideoCount;
    int extraAudioCount;
    
    //for layout Buttons
    UIButton *onelayOut;
    UIButton *twolayOut;
    UIButton *threelayOut;
    UIButton *fourlayOut;
    UIButton *ninelayOut;
    UIButton *nextButton;
    UIButton *saveButton;
    UIButton *nextPageButton;
    UIButton *previousPageButton;
    UIImage *temp;
    BOOL editOpen;
    BOOL finished;
    BOOL directNext;
    BOOL imageChange;
    BOOL replaceImage;
    BOOL mainMusic;
    BOOL editImage;
    
    //Changes 28
    BOOL NewPageEditACase;  
    
    //for layout Condition
    BOOL secondimageArray;
    BOOL thirdimageArray;
    BOOL fourimageArray;
    BOOL nineimageArray;
    NSString *finalcounter1;
    NSString *finalcounter2;
    NSString *finalcounter3;
    NSString *finalcounter4;
    NSString *finalcounter5;
    NSString *finalcounter6;
    NSString *finalcounter7;
    NSString *finalcounter8;
    NSString *finalcounter9;
    NSString *editalbumName;
    NSFileManager *fileManager;
    NSString *finalPath;
    NSString *dirName;
    NSArray *paths;
    NSString *yourDirPath;
    
   //for CommentLine
    UIAlertView *commentLine;
    UIAlertView *discardPage;
    BOOL pageDiscard,omitPage1,omitPage2,omitPage3,omitPage4,omitPage9,omitPage;
    //for Next Button AlertView
    UIAlertView *message;
    UIAlertView *longPressWebLink;
   
    //for Accordian
   // UIImageView *extraImageView;
    NSArray *accordianList;
    AccordionView *accordion;
    UITableView *view1;
    UITableView *view2;
    UITableView *view3;
    UITableView *view4;
    NSMutableArray *extraitem;
    int accordianCount;
    UILabel *titleLabel;
    UILabel *secondTitleLabel;
    UIImageView *indicatorImageView;
    UITableViewCell *cell;
    NSMutableArray *editArray1;
    
    //for extraImage
    int layOutClicked;
    NSString *totalpages;
    
    //for Music
    NSMutableArray *musicArray;
    NSMutableArray *musictitle;
    MPMediaQuery *query;
    NSString *audioURL;
    NSMutableArray *extraAudioItem;
    NSMutableArray *extraAudioTitle;

    
    //for Video
    NSMutableArray *extraVideoItem;
    BOOL accordianOpen;
    BOOL isInitAccordian;
    BOOL setAccordian;
    BOOL additem;
    BOOL editClicked;
    BOOL buildingAlbum;
    BOOL press;
    BOOL cancel;
    NSString *videoURL;
    BOOL defaultTheme;
    
    //for weblink
    NSMutableArray *extraWebItem;
    int extraWebCounter;
    int editWebCounter;
    BOOL web;
    BOOL editWeb;
    
    //for SaveButton
    UIAlertView *saveAlert;
    UIAlertView *autoDissmissalertView;
    UITableView *tableView;
    NSArray *themeList;
    NSArray *themeImageList;
    NSString *themeString;
    IBOutlet UIBarButtonItem *videoButton;
    IBOutlet UIBarButtonItem *audioButton;
    
    //for editalbum
    BOOL enterEditAlbum;
    BOOL editURL;
    BOOL navigationedit;
    BOOL layOutIsFilled;
    BOOL isalbumFinished;
    BOOL remove;
    BOOL final;
    BOOL editAccordianOpen;
    BOOL save;
    BOOL editSave;
    BOOL overWrite;
    BOOL videoWarning;
    BOOL firstPageVideo;
    int oneFilled;
    int twoFilled;
    int threeFilled;
    int fourFilled;
    int nineFilled;
    int currentCP,CurrentPP;
    int oneNextClicked;
    int twoNextClicked;
    int threeNextClicked;
    int fourNextClicked;
    int nineNextClicked;
    UILabel *webStatus;
}
//property initialization
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIView *toprightView;
@property (strong, nonatomic) IBOutlet UIView *bottomrightView;
@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *videoScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *audioScrollView;
@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, retain) NSMutableArray *imageThumbnailArray;
@property (nonatomic, retain) NSMutableArray *pageCollection;
@property (nonatomic, retain) NSMutableArray *musicArray;
@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *buttonImage;
@property(nonatomic, retain) pagesViewController *pages;
@property (strong, nonatomic) IBOutlet UILabel *extraLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageLabel;
@property (strong, nonatomic) IBOutlet UILabel *audioLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPagesLabel;
@property (nonatomic) BOOL startStopButtonIsActive;
@property (nonatomic) BOOL videoButtonIsActive;
@property (nonatomic) BOOL audioButtonIsActive;
@property (nonatomic) BOOL accordianButtonIsActive;

//Action method
-(void)displayImages;
-(void)loadScrollView;
- (IBAction)Audio:(id)sender;
- (IBAction)Video:(id)sender;
- (void)oneClicked;
- (void)twoClicked;
- (void)threeClicked;
- (void)fourClicked;
- (void)nineClicked;
-(void)accordianButton;
-(void)destroyImageView;
-(void)copyLink;
- (void)controlAccrodian;
-(void)accordianClicked;
@end
