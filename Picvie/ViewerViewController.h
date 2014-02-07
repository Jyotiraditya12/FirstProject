//
//  ViewerViewController.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 25/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import<AudioToolbox/AudioToolbox.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccount.h>
#import "oneLayOut.h"
#import "twoLayOut.h"
#import "threeLayOut.h"
#import "fourLayOut.h"
#import "nineLayOut.h"
#import "pagesViewController.h"
#import "XMLWriter.h"
#import "XMLParser.h"
#import "Album.h"
#import "viewerLayOutOne.h"
#import "viewerLayOutTwo.h"
#import "viewerLayOutThree.h"
#import "viewerLayOutFour.h"
#import "viewerLayOutNine.h"
#import "SlideMenuView.h"
#import "testClasViewController.h"
#import <sqlite3.h>
#import "DetailViewController.h"
#import "Reachability.h"

@class pagesViewController;
@class testClasViewController;
@class DetailViewController;
@class XMLWriter;
@class XMLParser;
@class oneLayOut;
@class twoLayOut;
@class threeLayOut;
@class fourLayOut;
@class nineLayOut;
@class Album;


@interface ViewerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    @public
    
    pagesViewController *page;
    UIView *builderView;
    BOOL thumbnailFinish;
    
    //for Displaying Albums and PageLabels
    IBOutlet UINavigationBar *topNavigationBar;
    UIAlertView *loadingAlertView;
    BOOL Finishes;
    int m,n,p,q,s,t;
    UIImage *albumImage;
    BOOL Press;
    int extraButtontag;
    int videoButtonTag;
    int settingCode;
    //int check;
    Boolean isToBeStopped;
    UIImageView *imageView;
    UIActivityIndicatorView *spinners;
    NSString *finalPath;
    UIView *newView ;
    UIButton *albumButton;
    int checkPage;
    BOOL buttonClicked;
    BOOL noimagesandvideos;
    UIAlertView *noImagesView ;

    //for HelpButton
    UIWebView *faqWebView;
    UIButton *faqButton;
    UILabel *faqLabel;
    UIImage *nextImage;
    UIImage *oneLayOutImage;
    UIButton *faqStartButton;
    UIImageView *helpImageView1;
    UIAlertView *faqAlert;
    BOOL callFaq;
    UIButton *checkBox;
    BOOL checkBoxSelected;
    UILabel *checkLabel;
    
    //for Image
    UIImage *temp;
    UISwipeGestureRecognizer *oneFingerSwipeLeft;
    UISwipeGestureRecognizer *oneFingerSwipeRight;
    UISwipeGestureRecognizer *swipeUpGestureRecognizer;
    UISwipeGestureRecognizer *swipeDownGestureRecognizer;
    NSMutableArray *thumbnailArray;
    UIButton *thumbnailButton;
    UIImageView *image1;
    BOOL videoAlbumShowing;
    UIImage *imagePath ;
    
    //for ExtraImage
    UITableView *extraImageTableView;
    int extraImageCount;
    int extraVideoCount;
    int extraAudioCount;
    NSString *loadExtraImage;
    NSMutableArray *tableViewImages;
    BOOL extraImage;
    
    //for Videos
    int videosCount;
    UITableView *videosTableView;
    NSMutableArray *tableViewVideos;
    MPMoviePlayerViewController *moviePlayerVC;
    BOOL extraVideo;
    NSString *loadVideo;
    BOOL videoCheck;
    BOOL videoInFirstPage;
    
    //for Audios
    int audiosCount;
    UITableView *audiosTableView;
    NSMutableArray *tableViewAudios;
    NSMutableArray *tableViewAudioTitle;
    AVPlayer *player;
    AVPlayerItem *playerItem;
    BOOL audioStop;
    
    //for webLink
    NSMutableArray *tableViewWebLink;
    UITableView *webLinkTableVIew;
    BOOL extraWebLInk;
    int webLinkCount;
    
    //for Delete Album
    UIActionSheet *popupQuery;
    UILongPressGestureRecognizer *longPressGesture;
    NSString *longPath;
    NSString *defaultUserContents;
    BOOL clicked;
    
    //for Theme
    NSString *themeName;
    NSString *backGroundTheme;
    NSArray *themeList;
    NSArray *themeImageList;
    UITableView *changeThemeTableView;
    NSString *changeThemeString;
    int tag;
    
    //for Comment
    UILabel *commentLabel;
    
    //For AutoPlay
    UIButton *autoPlayButton;
    UIButton *autoPlayStopButton;
    
    //Exif Data and create year Book
    NSMutableArray *imageAssets;
    NSMutableArray *videoAssets;
    NSDate *date;
    NSString *getYear;
    NSMutableArray *dateArray;
    int year;
    NSString *xmlString1 ;
    NSMutableArray *imageURL;
    NSString * currentYear ;
    NSString *yearPath;
    NSString *finalTemp,*finalTemp1;
    BOOL videoShow;
    NSString *checkYB;
    
    //ALAssetsLibray Variable
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groups;
    ALAssetsGroup *assetsGroup;
    ALAsset *asset;
    
    //for buttons
    NSString *finalaudioButton;
    NSString *finalVideoButton;
    NSString *finalExtraImageButton;
    NSString *finalWebLnkButton;
    NSString *finalFacebookButton;
    NSString *finalNextButton;
    NSString *finalPreviousButton;
    
    //dataBase Alert
    UIAlertView *dataBaseAlert;
    NSString *albumName;
    NSString *passCode;
    NSString *albumProtect;
    UIAlertView *passcodeAlert;
    NSString *passcodeAlbum;
    NSMutableArray *databaseArray;
    NSString *aName;
    NSString *aPassword;
    UITextField *textField;
    NSMutableArray *finalArray;
    
    //for Settings of App
    UITableView *settingsTableView;
    NSArray *settingsList;
    IBOutlet UIBarButtonItem *settings;
    IBOutlet UIBarButtonItem *viewer;
    UIAlertView *settingsAlert;
    NSUserDefaults *passcodePref;
    
    //for ViewScroll
    NSMutableArray *firstButtonArray;
    NSMutableArray *secondButtonArray;
     NSMutableArray *thirdButtonArray;
    SlideMenuView *slideMenuView, *slideMenuView1, *slideMenuView2, *slideMenuView3;
    UIView *lineView, *lineView1;
    UIImageView *indicationImageView;
    UIImageView *rightIndicatorImageView;
    UIImageView *indicationImageView1;
    UIImageView *secondRowrightIndicatorImageView;
    UIImageView *indicationImageView2;
    UIImageView *thirdRowrightIndicatorImageView;
    
    
    //for Edit Album
    NSString *albumXmlPath;
    NSString *unEdit;
    NSMutableArray *unEditAlbum;
    BOOL noEdit;
    UIActionSheet *noEditActionSheet;
    
    //For camera
    BOOL showCameraAlert;
    UIActionSheet *cameraControl;
    UIAlertView *newAlbumAlert;
    UITextField *cameraNewAlbumTextField;
    UIView *cameraView;
    UITableView *cameraAlbumTableView;
    NSMutableArray *cameraImageURL;
    NSString *dirName;
    NSString *CamerafinalPath;
    BOOL existingAlbum;
    NSString *albumExists;
    int existingPageCount;
    NSFileManager *filemanager;
    NSMutableArray *albumString;
    
    //for dynamic Buttons
    UIButton *audioButton;
    UIButton *videoButton;
    UIButton *extraImgButton;
    UIButton *weblinkButton;
    UIButton *fbButton;
    UIButton *nextButton;
    UIButton *prevButton;
    
    //for canceling ThemeTableView
    BOOL back;
    BOOL tableviewRemove;
    BOOL builderClick;

    //for AlertView buttons
    BOOL camera;
    BOOL faceBook;
    BOOL editProtect;
    BOOL editUnProtect;
    BOOL setting;
    BOOL unEditProtect;
    BOOL unEditUnProtect;
    BOOL showAlbum;
    BOOL backToAlbum;
    
    //For Help Button all things
    UIView *helpView;
    UIImageView *helpImageView;
    UIButton *nextHelpButton;
    UIButton *prevHelpButton;
    NSString *nextHelpImagePicture;
    UIAlertView *helpViewingALert;
    UIButton *skipButton;
    BOOL skip;
    UIAlertView *albumProtected;
}
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
- (IBAction)viewer:(id)sender;
- (IBAction)settings:(id)sender;
//- (IBAction)autoplayClicked;
//- (IBAction)isAutoPlayToBeStopped;
- (void) builderClicked;
- (void)updateUI;
- (void)builderButton;
- (void)cameraButton;
- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer;
@property (nonatomic) IBOutlet UIScrollView* scrollView;
@property (nonatomic) BOOL startStopButtonIsActive;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *albumDB;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (nonatomic, retain) SlideMenuView *slideMenuView;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;

@end
