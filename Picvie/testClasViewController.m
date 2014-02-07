//
//  testClasViewController.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 23/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "testClasViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

static int  p, extraIMageCounter,editImageCounter, editVideoCounter, editAudioCounter;
static int v;
static int cp,pp;
static int m;
static int counter;
static int counter1;
static int counter2;
static int counter3;
static int pagescounter ;
static int storeLayout, page,endOfPage;
int endPage;
ViewerViewController *view;
DetailViewController *detailViewController;
oneLayOut *one;
twoLayOut *two;
threeLayOut *three;
fourLayOut *four;
nineLayOut *nine;
XMLParser *xmlParser;
//---------TotalPages----------//
static int totalPages;

@interface testClasViewController ()


@end

@implementation testClasViewController
@synthesize leftView, toprightView, bottomrightView, myScrollView,videoScrollView, audioScrollView,pages, groups,assets, imageThumbnailArray, pageCollection,extraLabel,imageLabel,audioLabel,videoLabel,titleLabel,  totalPagesLabel,musicArray, startStopButtonIsActive, videoButtonIsActive, audioButtonIsActive;

@synthesize activityIndicator = _activityIndicator;
@synthesize buttonImage = _buttonImage;


- (void)primitiveInit
{
    // Here I setup all my instance variables.
    pageCollection = [[NSMutableArray alloc] init];
}

// Designated initializer for instantiating in code.
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self)
    {
        [self primitiveInit];
    }
    return self;
}

// Always called when instantiated from NIB.
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self primitiveInit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isInitAccordian = true;
    setAccordian = TRUE;
    editClicked = TRUE;
    accordianCount = 0;
    web = FALSE;
    view = [[ViewerViewController alloc]init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            accordion = [[AccordionView alloc] initWithFrame:CGRectMake(240, 0, 148, 288)];
        }
        else
        {
            accordion = [[AccordionView alloc] initWithFrame:CGRectMake(200, 0, 120, 288)];
        }
    }
    else
    {
        accordion = [[AccordionView alloc] initWithFrame:CGRectMake(447, 0, 270, 724)];
    }
    [self onelayOut];
    [self twolayOut];
    [self threelayOut];
    [self fourlayOut];
    [self ninelayOut];
    [self next];
    [self save];
    [self accordianButton];
    [self oneClicked];
    [self pageNavigationNextButton];
    [self pageNavigationPreviousButton];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    oneImageCounter = 0;
    twoImageCounter = 0;
    threeImageCounter = 0;
    fourImageCounter = 0;
    nineImageCounter = 0;
    pp = CurrentPP;
    cp= currentCP;
    
    //Putting Label
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            self->navigationBar.topItem.title = @"Image";
        }
        else
        {
            self->navigationBar.topItem.title = @"Image";
        }
    }
    else
    {
        self->navigationBar.topItem.title = @"Image";
    }

   longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(longPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    press = TRUE;
    [self->toprightView addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapView:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self->toprightView addGestureRecognizer:singleTap];
}

- (void)longPress: (id)sender
{
    __weak Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    detailViewController = [[DetailViewController alloc] initWithNibName:@"webBrowser_iphone5" bundle:nil];
                    [self presentPopupViewController:detailViewController animationType:nil];
                }
                else
                {
                    detailViewController = [[DetailViewController alloc] initWithNibName:@"webBrowser_iphone" bundle:nil];
                    [self presentPopupViewController:detailViewController animationType:nil];
                }
            }
            else
            {
                detailViewController = [[DetailViewController alloc] initWithNibName:@"webBrowser_ipad" bundle:nil];
                
                [self presentPopupViewController:detailViewController animationType:nil];
            }
        });

    };
    reach.unreachableBlock = ^(Reachability * reachability)
    {

        dispatch_async(dispatch_get_main_queue(), ^{
            longPressWebLink = [[UIAlertView alloc] initWithTitle:nil
                                                       message:@"No Internet Connection Available"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];
            [longPressWebLink show];
        });
    };
    
    [reach startNotifier];

}

- (void)singleTapView : (id)sender
{
    commentLine = [[UIAlertView alloc] initWithTitle:nil
                                             message:@"Put Comment for Image"
                                            delegate:self
                                   cancelButtonTitle:@"No Comment"
                                   otherButtonTitles:@"Add Comment", nil];
    commentLine.alertViewStyle = UIAlertViewStylePlainTextInput;
    [commentLine show];
    
}

-(void)destroyImageView
{
    if(one)
    {
        one->firstImageView = nil;
        one = NULL;
    }
    if (two)
    {
        two->twofirstImageView = nil;
        two->twosecondImageView = nil;
        two = NULL;
    }
    if(three)
    {
        three->threefirstImageView = nil;
        three->threesecondImageView = nil;
        three->threethirdImageView = nil;
        three = NULL;
    }
    if(four)
    {
        four->fourfirstImageView = nil;
        four->foursecondImageView = nil;
        four->fourthirdImageView = nil;
        four->fourfourImageView = nil;
        four = NULL;
    }
    if(nine)
    {
        nine->ninefirstImageView = nil;
        nine->ninesecondImageView = nil;
        nine->ninethirdImageView = nil;
        nine->ninefourImageView = nil;
        nine->ninefiveImageView = nil;
        nine->ninesixImageView = nil;
        nine->ninesevenImageView = nil;
        nine->nineeightImageView = nil;
        nine->ninenineImageView = nil;
        nine = NULL;
    }

}

//method for navigation Button
- (void)pageNavigationNextButton
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *nextButtonimage = [UIImage imageNamed:@"next_s.png"];
            nextPageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nextPageButton.frame = CGRectMake( 528.0, 5.0, 40.0, 21.0);
            [nextPageButton setBackgroundImage:nextButtonimage  forState:UIControlStateNormal];
            [nextPageButton addTarget:self action:@selector(pagesNextClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:nextPageButton];
        }
        else
        {
            UIImage *nextButtonimage = [UIImage imageNamed:@"next_s.png"];
            nextPageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nextPageButton.frame = CGRectMake( 433.0, 5.0, 40.0, 21.0);
            [nextPageButton setBackgroundImage:nextButtonimage  forState:UIControlStateNormal];
            [nextPageButton addTarget:self action:@selector(pagesNextClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:nextPageButton];
        }
        
    }
    else
    {
        UIImage *nextButtonimage = [UIImage imageNamed:@"next_s.png"];
        nextPageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nextPageButton.frame = CGRectMake(970.0, 5.0, 40.0, 40.0 );
        [nextPageButton setBackgroundImage:nextButtonimage  forState:UIControlStateNormal];
        [nextPageButton addTarget:self action:@selector(pagesNextClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextPageButton];
    }

}

- (void)pagesNextClicked
{
    pageDiscard = FALSE;
    if(page == storeLayout)
    {
        storeLayout++;
        page++;
    }
    else
    {
        storeLayout++;
    }
    
    //------------------------------- Execute only at Edit Album Case ----------------------------//
    if(editOpen)
    {
        
        pages = [[pagesViewController alloc]init];
        pages->imageURL = [[NSMutableArray alloc]init];
        pages->extraImage = [[NSMutableArray alloc]init];
        pages->musicArray = [[NSMutableArray alloc]init];
        pages->finalMusicTitle = [[NSMutableArray alloc]init];
        pages->videoArray = [[NSMutableArray alloc]init];
        pages->webLink = [[NSMutableArray alloc]init];
       editClicked = FALSE;
        int pageCount =[ pageCollection count] ;
        if((cp == 0) && (cp<pageCount-1))
        {
            cp = cp+1;
        }
        
        if(cp == pageCount-1)
        {
            [nextPageButton setEnabled:NO];
            builderNav = FALSE;
            pageFill = TRUE;
            
        }
        //-------------------------- FROM EDIT ALBUM IF YOU ARE COMING ----------------------------//
        NSString *loadImage;
        switch(((pagesViewController *) pageCollection[cp])->layoutused)
        {
            case 12:
            {
                [self destroyImageView];
                [self oneClicked];
                oneImageCounter =1;
                oneFilled = 1;
                oneNextClicked = 1;
                if(imageChange)
                {
                    loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[0];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                else
                {
                    loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[0];
                    loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                if(directNext)
                {
                    NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                    loadImage = [finalImageURL stringByAppendingString:loadImage];
                    [pages->imageURL addObject:loadImage];
                    
                }
                else
                {
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        [pages->imageURL addObject:myasset];
                        ALAssetRepresentation *rep = [myasset defaultRepresentation];
                        CGImageRef iref = [rep fullScreenImage];
                        temp = [UIImage imageWithCGImage:iref];
                        if (iref)
                        {
                            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                            {
                                //for iPhone5
                                if([[UIScreen mainScreen]bounds].size.height == 568)
                                {
                                    one->firstImageView.image = temp;
                                    [UIView commitAnimations];
                                }
                                else
                                {
                                    one->firstImageView.image = temp;
                                    [UIView commitAnimations];
                                }
                            }
                            else
                            {
                                one->firstImageView.image = temp;
                                [UIView commitAnimations];
                            }
                        }
                        
                    };
                    
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                    
                    if(loadImage && [loadImage length])
                    {
                        
                        NSURL *asseturl = [NSURL URLWithString:loadImage];
                        [assetsLibrary assetForURL:asseturl
                                       resultBlock:resultblock
                                      failureBlock:failureblock];
                    }
                }
                totalpages = [NSString stringWithFormat:@"%d",cp+1];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = cp;
                cp = cp+1;
                [previousPageButton setEnabled:YES];
                imageChange = FALSE;
                break;
            }
                

            case 1:
            {
                [self destroyImageView];
                [self oneClicked];
                oneImageCounter =1;
                oneFilled = 1;
                oneNextClicked = 1;
               if(imageChange)
               {
                   loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[0];
                   [pages->imageURL insertObject:loadImage atIndex:0];
               }
               else
               {
                    loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[0];
                    loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                if(directNext)
                {
                    NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                    loadImage = [finalImageURL stringByAppendingString:loadImage];
                    [pages->imageURL addObject:loadImage];
 
                }
                else
                {
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        [pages->imageURL addObject:myasset];
                        ALAssetRepresentation *rep = [myasset defaultRepresentation];
                        CGImageRef iref = [rep fullScreenImage];
                        temp = [UIImage imageWithCGImage:iref];
                        if (iref)
                        {
                            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                            {
                                //for iPhone5
                                if([[UIScreen mainScreen]bounds].size.height == 568)
                                {
                                    one->firstImageView.image = temp;
                                    [UIView commitAnimations];
                                }
                                else
                                {
                                    one->firstImageView.image = temp;
                                    [UIView commitAnimations];
                                }
                            }
                            else
                            {
                                one->firstImageView.image = temp;
                                [UIView commitAnimations];
                            }
                        }
                    
                    };
                
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                
                    if(loadImage && [loadImage length])
                    {
                    
                        NSURL *asseturl = [NSURL URLWithString:loadImage];
                        [assetsLibrary assetForURL:asseturl
                                   resultBlock:resultblock
                                  failureBlock:failureblock];
                    }
                }
                totalpages = [NSString stringWithFormat:@"%d",cp+1];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = cp;
                cp = cp+1;
                [previousPageButton setEnabled:YES];
                imageChange = FALSE;
                break;
            }
                
            case 2:
            {
                [self destroyImageView];
                [self twoClicked];
                secondimageArray = TRUE;
                twoImageCounter =2;
                twoFilled = 2;
                twoNextClicked = 2;
                for(int i=0;i<2;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                two->twofirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                two->twofirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            two->twofirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    
                                    }
                                
                                
                                };
                            
                            
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                            
                                if(loadImage && [loadImage length])
                                {
                                
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                                }
                            }
                            break;
                            
                        }
                        case 1:
                        {
                             
                            if(imageChange)
                            {
                                
                               loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {

                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                two->twosecondImageView.image = temp;
                                                [UIView commitAnimations];

                                            }
                                            else
                                            {
                                                two->twosecondImageView.image = temp;
                                                [UIView commitAnimations];

                                            }
                                        }
                                        else
                                        {
                                            two->twosecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    
                                    }
                                
                                
                                };
                            
                            
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                            
                                if(loadImage && [loadImage length])
                                {
                                
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                                }
                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                        default:
                            break;
                    }
                    
                }
                if(directNext)
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                    
                }
                else
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                
                break;
            }
            case 3:
            {
                [self destroyImageView];
                [self threeClicked];
                thirdimageArray = TRUE;
                threeImageCounter =3;
                threeFilled = 3;
                threeNextClicked = 3;
                for(int i=0;i<3;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                three->threefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                three->threefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            three->threefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                        failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                three->threesecondImageView.image = temp;
                                                [UIView commitAnimations];

                                            }
                                            else
                                            {
                                                three->threesecondImageView.image = temp;
                                                [UIView commitAnimations];

                                            }
                                        }
                                        else
                                        {
                                            three->threesecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 2:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                three->threethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                three->threethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            three->threethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                        default:
                            break;
                    }
                }
                if(directNext)
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                else
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                break;
                
            }
            case 4:
            {
                [self destroyImageView];
                [self fourClicked];
                fourimageArray = TRUE;
                fourImageCounter =4;
                fourFilled = 4;
                fourNextClicked = 4;
                for(int i=0;i<4;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->fourfirstImageView.image = temp;
                                                [UIView commitAnimations];

                                            }
                                            else
                                            {
                                                four->fourfirstImageView.image = temp;
                                                [UIView commitAnimations];

                                            }
                                        }
                                        else
                                        {
                                            four->fourfirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                            
                            
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->foursecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->foursecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->foursecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 2:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->fourthirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->fourthirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->fourthirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 3:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->fourfourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->fourfourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->fourfourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                            
                        default:
                            break;
                    }
                }
                
                if(directNext)
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                else
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                break;
                
            }
            case 9:
            {
                [self destroyImageView];
                [self nineClicked];
                nineimageArray = TRUE;
                nineImageCounter =9;
                nineFilled = 9;
                nineNextClicked = 9;
                for(int i=0;i<9;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                            
                            
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninesecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninesecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninesecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 2:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninethirdImageView.image = temp;
                                            [UIView commitAnimations];   
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 3:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                            }
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninefourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninefourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninefourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 4:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:4];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:4];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninefiveImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninefiveImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninefiveImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                            
                        case 5:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:5];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:5];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {

                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninesixImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninesixImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninesixImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                [assetsLibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            }
                            break;
                        }
                            
                        case 6:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:6];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:6];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninesevenImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninesevenImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninesevenImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                            
                        case 7:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:7];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:7];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->nineeightImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->nineeightImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->nineeightImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            break;
                        }
                        case 8:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:8];
                                
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[cp])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:8];
                            }
                            
                            if(directNext)
                            {
                                NSString *finalImageURL= @"ALAsset - Type:Photo, URLs:";
                                loadImage = [finalImageURL stringByAppendingString:loadImage];
                                [pages->imageURL addObject:loadImage];
                                
                            }
                            else
                            {
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninenineImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninenineImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninenineImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    [assetsLibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }

                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                            
                        default:
                            break;
                    }
                }
                if(directNext)
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                else
                {
                    totalpages = [NSString stringWithFormat:@"%d",cp+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    pp = cp;
                    cp = cp+1;
                    [previousPageButton setEnabled:YES];
                }
                break;
                
            }
               
                
            default:
                break;
        }
        navigationedit = FALSE;
    }
    
    //-------------------FROM BUILDER CLICKED AFTER THAT IT IS GOING TO EXECUTE---------------------//-
    else
    {
        builderNav = TRUE;
        pageFill = TRUE;     
        layOutIsFilled = TRUE;
        if(page == [pageCollection count])
        {
               [self oneClicked];
               NSString *totalPagesCount = @"Page: ";
               NSString *page = [NSString stringWithFormat:@"%d", [pageCollection count]+1];
               [pageCountLabel setText:[totalPagesCount stringByAppendingString:page]];
               [previousPageButton setEnabled:YES];
               builderNav = FALSE;
        }
        else
        {
        for(int i=storeLayout;i<=page ;i++)
        {
            switch(((pagesViewController *) pageCollection[i])->layoutused)
            {
                case 12:
                {
                    [self destroyImageView];
                    [self oneClicked];
                    for(int j=0;j<1;j++)
                    {
                        
                        NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                        loadImage = [loadImage substringFromIndex:27];
                        
                        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                        {
                            ALAssetRepresentation *rep = [myasset defaultRepresentation];
                            CGImageRef iref = [rep fullScreenImage];
                            temp = [UIImage imageWithCGImage:iref];
                            
                            if (iref)
                            {
                                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                {
                                    //for iPhone5
                                    if([[UIScreen mainScreen]bounds].size.height == 568)
                                    {
                                        one->firstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    else
                                    {
                                        one->firstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                }
                                else
                                {
                                    one->firstImageView.image = temp;
                                    [UIView commitAnimations];
                                }
                                
                            }
                            
                            
                        };
                        
                        
                        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                        {
                            NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                        };
                        
                        if(loadImage && [loadImage length])
                        {
                            
                            NSURL *asseturl = [NSURL URLWithString:loadImage];
                            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                            [assetslibrary assetForURL:asseturl
                                           resultBlock:resultblock
                                          failureBlock:failureblock];
                        }
                        totalpages = [NSString stringWithFormat:@"%d",page+1];
                        NSString *totalPagesCount = @"Page: ";
                        [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                        [previousPageButton setEnabled:YES];
                    }
                    break;
                }   
                case 1:
                {
                    [self destroyImageView];
                    [self oneClicked];
                    for(int j=0;j<1;j++)
                    {
                        
                        NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                        loadImage = [loadImage substringFromIndex:27];
                        
                        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                        {
                            ALAssetRepresentation *rep = [myasset defaultRepresentation];
                            CGImageRef iref = [rep fullScreenImage];
                            temp = [UIImage imageWithCGImage:iref];
                            
                            if (iref)
                            {
                                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                {
                                    //for iPhone5
                                    if([[UIScreen mainScreen]bounds].size.height == 568)
                                    {
                                        one->firstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    else
                                    {
                                        one->firstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                }
                                else
                                {
                                    one->firstImageView.image = temp;
                                    [UIView commitAnimations];
                                }
                                
                            }
                            
                            
                        };
                        
                        
                        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                        {
                            NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                        };
                        
                        if(loadImage && [loadImage length])
                        {
                            
                            NSURL *asseturl = [NSURL URLWithString:loadImage];
                            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                            [assetslibrary assetForURL:asseturl
                                           resultBlock:resultblock
                                          failureBlock:failureblock];
                        }
                        totalpages = [NSString stringWithFormat:@"%d",page+1];
                        NSString *totalPagesCount = @"Page: ";
                        [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                        [previousPageButton setEnabled:YES];
                    }
                    break;
                }
                case 2:
                {
                    [self destroyImageView];
                    [self twoClicked];
                    secondimageArray = TRUE;
                    for(int j=0;j<2;j++)
                    {
                        switch(j)
                        {
                            case 0:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                two->twofirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                two->twofirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            two->twofirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                break;
                            }
                            case 1:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                two->twosecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                two->twosecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            two->twosecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                totalpages = [NSString stringWithFormat:@"%d",page+1];
                                NSString *totalPagesCount = @"Page: ";
                                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                                [previousPageButton setEnabled:YES];

                                break;
                            }
                                
                            default:
                                break;
                        }
                    }
                    break;
                }
                case 3:
                {
                    [self destroyImageView];
                    [self threeClicked];
                    thirdimageArray = TRUE;
                    for(int j=0;j<3;j++)
                    {
                        switch(j)
                        {
                            case 0:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                three->threefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                three->threefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            three->threefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                break;
                            }
                            case 1:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                three->threesecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                three->threesecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            three->threesecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                break;
                            }
                            case 2:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                three->threethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                three->threethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            three->threethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                break;
                            }
                                
                            default:
                                break;
                        }
                    }
                    totalpages = [NSString stringWithFormat:@"%d",page+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    [previousPageButton setEnabled:YES];

                    break;
                }
                case 4:
                {
                    [self destroyImageView];
                    [self fourClicked];
                    fourimageArray = TRUE;
                    for(int j=0;j<4;j++)
                    {
                        switch(j)
                        {
                            case 0:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->fourfirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->fourfirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->fourfirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 1:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->foursecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->foursecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->foursecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 2:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->fourthirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->fourthirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->fourthirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 3:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                four->fourfourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                four->fourfourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            four->fourfourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                                
                            default:
                                break;
                        }
                    }
                    totalpages = [NSString stringWithFormat:@"%d",page+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    [previousPageButton setEnabled:YES];

                    break;
                }
                case 9:
                {
                    [self destroyImageView];
                    [self nineClicked];
                    nineimageArray = TRUE;
                    for(int j=0;j<9;j++)
                    {
                        switch(j)
                        {
                            case 0:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninefirstImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 1:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninesecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninesecondImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninesecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }

                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 2:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninethirdImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }

                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 3:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninefourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninefourImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninefourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 4:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninefiveImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninefiveImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            
                                        }
                                        else
                                        {
                                            nine->ninefiveImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 5:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninesixImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninesixImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninesixImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 6:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninesevenImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninesevenImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninesevenImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 7:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->nineeightImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->nineeightImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->nineeightImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                            case 8:
                            {
                                NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                loadImage = [loadImage substringFromIndex:27];
                                
                                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                                {
                                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                    CGImageRef iref = [rep fullScreenImage];
                                    temp = [UIImage imageWithCGImage:iref];
                                    
                                    if (iref)
                                    {
                                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                        {
                                            //for iPhone5
                                            if([[UIScreen mainScreen]bounds].size.height == 568)
                                            {
                                                nine->ninenineImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                            else
                                            {
                                                nine->ninenineImageView.image = temp;
                                                [UIView commitAnimations];
                                            }
                                        }
                                        else
                                        {
                                            nine->ninenineImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        
                                    }
                                    
                                    
                                };
                                
                                
                                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                                {
                                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                                };
                                
                                if(loadImage && [loadImage length])
                                {
                                    
                                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                    [assetslibrary assetForURL:asseturl
                                                   resultBlock:resultblock
                                                  failureBlock:failureblock];
                                }
                                
                                break;
                            }
                                
                                
                            default:
                                break;
                        }
                    }
                    totalpages = [NSString stringWithFormat:@"%d",page+1];
                    NSString *totalPagesCount = @"Page: ";
                    [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                    [previousPageButton setEnabled:YES];
                    break;
                }
                default:
                    break;
            }
        }

        endOfPage++;
        if(endOfPage == endPage-1)
        {
             totalpages = [NSString stringWithFormat:@"%d",page];
             NSString *totalPagesCount = @"Page: ";
             [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
             [nextPageButton setEnabled:YES];
            [self oneClicked];
            
        }
        
        }
    }
   // pageDiscard = FALSE;

}

- (void)pageNavigationPreviousButton
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *previousButton = [UIImage imageNamed:@"previous.png"];
            previousPageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            previousPageButton.frame = CGRectMake(383.0, 5.0, 40.0, 21.0 );
            [previousPageButton setBackgroundImage:previousButton  forState:UIControlStateNormal];
            [previousPageButton addTarget:self action:@selector(pagesPreviousClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:previousPageButton];
        }
        else
        {
            UIImage *previousButton = [UIImage imageNamed:@"previous.png"];
            previousPageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            previousPageButton.frame = CGRectMake(325.0, 5.0, 40.0, 21.0 );
            [previousPageButton setBackgroundImage:previousButton  forState:UIControlStateNormal];
            [previousPageButton addTarget:self action:@selector(pagesPreviousClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:previousPageButton];
        }
        
    }
    else
    {
        UIImage *previousButton = [UIImage imageNamed:@"previous.png"];
        previousPageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        previousPageButton.frame = CGRectMake(740.0, 5.0, 40.0, 40.0 );
        [previousPageButton setBackgroundImage:previousButton  forState:UIControlStateNormal];
        [previousPageButton addTarget:self action:@selector(pagesPreviousClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:previousPageButton];
    }

}
- (void)pagesPreviousClicked
{
    pageDiscard = FALSE;
    NSString *loadImage;
    if(page == storeLayout)
    {
        storeLayout--;
        page--;
    }
    else
    {
         storeLayout--;
    }
    
    //-------------------------TRAVESRING THROUGH EDIT ALBUM---------------------------------//
   if(editOpen)
   {
       pages = [[pagesViewController alloc]init];
       pages->imageURL = [[NSMutableArray alloc]init];
       pages->extraImage = [[NSMutableArray alloc]init];
       pages->musicArray = [[NSMutableArray alloc]init];
       pages->finalMusicTitle = [[NSMutableArray alloc]init];
       pages->videoArray = [[NSMutableArray alloc]init];
       pages->webLink = [[NSMutableArray alloc]init];
    if(pp<=cp-1)
    {
        isalbumFinished = FALSE;
        pageFill = TRUE;
        switch(((pagesViewController *) pageCollection[pp-1])->layoutused)
        {
            case 12:
            {
                [self destroyImageView];
                [self oneClicked];
                if(imageChange)
                {
                    loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[0];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                else
                {
                    loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[0];
                    loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    
                    if (iref)
                    {
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            //for iPhone5
                            if([[UIScreen mainScreen]bounds].size.height == 568)
                            {
                                one->firstImageView.image = temp;
                                [UIView commitAnimations];
                            }
                            else
                            {
                                one->firstImageView.image = temp;
                                [UIView commitAnimations];
                            }
                        }
                        else
                        {
                            one->firstImageView.image = temp;
                            [UIView commitAnimations];
                        }
                        
                        
                    }
                    
                    
                };
                
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                if(loadImage && [loadImage length])
                {
                    
                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:asseturl
                                   resultBlock:resultblock
                                  failureBlock:failureblock];
                }
                
                totalpages = [NSString stringWithFormat:@"%d",pp];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = pp - 1;
                cp= pp+1;
                [nextPageButton setEnabled:YES];
                imageChange = FALSE;
                break;
            }   
            case 1:
            {
                [self destroyImageView];
                [self oneClicked];
                if(imageChange)
                {
                    loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[0];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                else
                {
                    loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[0];
                    loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                    [pages->imageURL insertObject:loadImage atIndex:0];
                }
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    
                    if (iref)
                    {
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            //for iPhone5
                            if([[UIScreen mainScreen]bounds].size.height == 568)
                            {
                                one->firstImageView.image = temp;
                                [UIView commitAnimations];
                            }
                            else
                            {
                                one->firstImageView.image = temp;
                                [UIView commitAnimations];
                            }
                        }
                        else
                        {
                            one->firstImageView.image = temp;
                            [UIView commitAnimations];
                        }

                        
                    }
                    
                    
                };
                
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                if(loadImage && [loadImage length])
                {
                    
                    NSURL *asseturl = [NSURL URLWithString:loadImage];
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:asseturl
                                   resultBlock:resultblock
                                  failureBlock:failureblock];
                }

                totalpages = [NSString stringWithFormat:@"%d",pp];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = pp - 1;
                cp= pp+1;
                [nextPageButton setEnabled:YES];
                imageChange = FALSE;
                break;
            }
            case 2:
            {
                [self destroyImageView];
                [self twoClicked];
                secondimageArray = TRUE;
                for(int i=0;i<2;i++)
                {
                    switch(i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            two->twofirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            two->twofirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        two->twofirstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            two->twosecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            two->twosecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        two->twosecondImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                           imageChange = FALSE;
                            break;
                        }
                        default:
                            break;
                    }
                }
                totalpages = [NSString stringWithFormat:@"%d",pp];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = pp - 1;
                cp= pp+1;
                [nextPageButton setEnabled:YES];
                break;
            }
            case 3:
            {
                [self destroyImageView];
                [self threeClicked];
                thirdimageArray = TRUE;
                for(int i=0;i<3;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            three->threefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            three->threefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        three->threefirstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                            
                            
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            three->threesecondImageView.image = temp;
                                            [UIView commitAnimations];

                                        }
                                        else
                                        {
                                            three->threesecondImageView.image = temp;
                                            [UIView commitAnimations];

                                        }
                                        
                                    }
                                    else
                                    {
                                        three->threesecondImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 2:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            three->threethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            three->threethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        three->threethirdImageView.image = temp;
                                        [UIView commitAnimations];
                                    }

                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                        default:
                            break;
                    }
                }
                totalpages = [NSString stringWithFormat:@"%d",pp];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = pp - 1;
                cp = pp+1;
                [nextPageButton setEnabled:YES];
                break;
                
            }
            case 4:
            {
                [self destroyImageView];
                [self fourClicked];
                fourimageArray = TRUE;
                for(int i=0;i<4;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            four->fourfirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            four->fourfirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        four->fourfirstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                            
                            
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            four->foursecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            four->foursecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        four->foursecondImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 2:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            four->fourthirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            four->fourthirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        four->fourthirdImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 3:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                            }
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            four->fourfourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            four->fourfourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        four->fourfourImageView.image = temp;
                                        [UIView commitAnimations];
                                    }

                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                            
                        default:
                            break;
                    }
                }
                totalpages = [NSString stringWithFormat:@"%d",pp];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = pp - 1;
                cp= pp+1;
                [nextPageButton setEnabled:YES];
                break;
                
            }
            case 9:
            {
                [self destroyImageView];
                [self nineClicked];
                nineimageArray = TRUE;
                for(int i=0;i<9;i++)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:0];
                            }
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninefirstImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninefirstImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                            
                            
                        }
                        case 1:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:1];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninesecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninesecondImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninesecondImageView.image = temp;
                                        [UIView commitAnimations];
                                    }

                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 2:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:2];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninethirdImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninethirdImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 3:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:3];
                            }
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {

                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninefourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninefourImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninefourImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 4:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:4];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:4];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninefiveImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninefiveImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninefiveImageView.image = temp;
                                        [UIView commitAnimations];
                                    }

                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                            
                        case 5:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:5];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:5];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninesixImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninesixImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninesixImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                            
                        case 6:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:6];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:6];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninesevenImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninesevenImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninesevenImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                            
                        case 7:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:7];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:7];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->nineeightImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->nineeightImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->nineeightImageView.image = temp;
                                        [UIView commitAnimations];
                                    }

                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            break;
                        }
                        case 8:
                        {
                            if(imageChange)
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                [pages->imageURL insertObject:loadImage atIndex:8];
                            }
                            else
                            {
                                loadImage = ((pagesViewController *) pageCollection[pp-1])->imageURL[i];
                                loadImage= [loadImage stringByReplacingOccurrencesOfString:@"'amp'" withString:@"&"];
                                [pages->imageURL insertObject:loadImage atIndex:8];
                            }
                            
                            
                            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                            {
                                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                CGImageRef iref = [rep fullScreenImage];
                                temp = [UIImage imageWithCGImage:iref];
                                
                                if (iref)
                                {
                                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                    {
                                        //for iPhone5
                                        if([[UIScreen mainScreen]bounds].size.height == 568)
                                        {
                                            nine->ninenineImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                        else
                                        {
                                            nine->ninenineImageView.image = temp;
                                            [UIView commitAnimations];
                                        }
                                    }
                                    else
                                    {
                                        nine->ninenineImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                                    
                                }
                                
                                
                            };
                            
                            
                            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                            {
                                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                            };
                            
                            if(loadImage && [loadImage length])
                            {
                                
                                NSURL *asseturl = [NSURL URLWithString:loadImage];
                                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:asseturl
                                               resultBlock:resultblock
                                              failureBlock:failureblock];
                            }
                            imageChange = FALSE;
                            break;
                        }
                            
                            
                        default:
                            break;
                    }
                }
                totalpages = [NSString stringWithFormat:@"%d",pp];
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                pp = pp - 1;
                cp= pp+1;
                [nextPageButton setEnabled:YES];
                break;
            }
                
            default:
                break;
            }
        
        }
       if(pp == 0)
       {
        [previousPageButton setEnabled:NO];
       }
       if([pageCollection count] == 1)
       {
           [nextPageButton setEnabled:NO];
       }
   }
    
    //-----------------TRAVESRING AT THE TIME OF BUILDING ALBUM FROM BUILDER----------------------//
   else
   {
       builderNav = TRUE;
       pageFill = TRUE;     //Changes Here For Direct Next building Album
       layOutIsFilled = TRUE;
       for(int i=storeLayout;i<=page ;i++)
       {
       switch(((pagesViewController *) pageCollection[i])->layoutused)
       {
           case 12:
           {
               [self destroyImageView];
               [self oneClicked];
               for(int j=0;j<1;j++)
               {
                   
                   NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                   loadImage = [loadImage substringFromIndex:27];
                   
                   ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                   {
                       ALAssetRepresentation *rep = [myasset defaultRepresentation];
                       CGImageRef iref = [rep fullScreenImage];
                       temp = [UIImage imageWithCGImage:iref];
                       
                       if (iref)
                       {
                           if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                           {
                               //for iPhone5
                               if([[UIScreen mainScreen]bounds].size.height == 568)
                               {
                                   one->firstImageView.image = temp;
                                   [UIView commitAnimations];
                               }
                               else
                               {
                                   one->firstImageView.image = temp;
                                   [UIView commitAnimations];
                               }
                           }
                           else
                           {
                               one->firstImageView.image = temp;
                               [UIView commitAnimations];
                           }
                           
                           
                       }
                       
                       
                   };
                   
                   
                   ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                   {
                       NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                   };
                   
                   if(loadImage && [loadImage length])
                   {
                       
                       NSURL *asseturl = [NSURL URLWithString:loadImage];
                       ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                       [assetslibrary assetForURL:asseturl
                                      resultBlock:resultblock
                                     failureBlock:failureblock];
                   }
                   
                   totalpages = [NSString stringWithFormat:@"%d",page+1];
                   NSString *totalPagesCount = @"Page: ";
                   [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                   [nextPageButton setEnabled:YES];
               }
               break;
           }   
           case 1:
           {
               [self destroyImageView];
               [self oneClicked];
               for(int j=0;j<1;j++)
               {
               
               NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    loadImage = [loadImage substringFromIndex:27];
               
               ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
               {
                   ALAssetRepresentation *rep = [myasset defaultRepresentation];
                   CGImageRef iref = [rep fullScreenImage];
                   temp = [UIImage imageWithCGImage:iref];
                   
                   if (iref)
                   {
                       if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                       {
                           //for iPhone5
                           if([[UIScreen mainScreen]bounds].size.height == 568)
                           {
                               one->firstImageView.image = temp;
                               [UIView commitAnimations];
                           }
                           else
                           {
                               one->firstImageView.image = temp;
                               [UIView commitAnimations];
                           }
                       }
                       else
                       {
                           one->firstImageView.image = temp;
                           [UIView commitAnimations];
                       }

                       
                   }
                   
                   
               };
               
               
               ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
               {
                   NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
               };
               
               if(loadImage && [loadImage length])
               {
                   
                   NSURL *asseturl = [NSURL URLWithString:loadImage];
                   ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                   [assetslibrary assetForURL:asseturl
                                  resultBlock:resultblock
                                 failureBlock:failureblock];
               }

                totalpages = [NSString stringWithFormat:@"%d",page+1];
                NSString *totalPagesCount = @"Page: ";
               [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
               [nextPageButton setEnabled:YES];
               }
               break;
           }
           case 2:
           {
               [self destroyImageView];
               [self twoClicked];
               secondimageArray = TRUE;
               for(int j=0;j<2;j++)
               {
                   switch(j)
                   {
                       case 0:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           two->twofirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           two->twofirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       two->twofirstImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           break;
                        }
                       case 1:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           two->twosecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           two->twosecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       two->twosecondImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           totalpages = [NSString stringWithFormat:@"%d",page+1];
                           NSString *totalPagesCount = @"Page: ";
                           [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
                           [nextPageButton setEnabled:YES];
                           break;
                       }
                           
                       default:
                           break;
                        }
               }
                break;
               }
           case 3:
           {
               [self destroyImageView];
               [self threeClicked];
               thirdimageArray = TRUE;
               for(int j=0;j<3;j++)
               {
                   switch(j)
                   {
                       case 0:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           three->threefirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           three->threefirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       three->threefirstImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           break;
                       }
                       case 1:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           three->threesecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           three->threesecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       three->threesecondImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           break;
                       }
                       case 2:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           three->threethirdImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           three->threethirdImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       three->threethirdImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           break;
                       }
                           
                       default:
                           break;
                   }
               }
               totalpages = [NSString stringWithFormat:@"%d",page+1];
               NSString *totalPagesCount = @"Page: ";
               [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
               [nextPageButton setEnabled:YES];
               break;
                }
           case 4:
           {
               [self destroyImageView];
               [self fourClicked];
               fourimageArray = TRUE;
               for(int j=0;j<4;j++)
               {
                   switch(j)
                   {
                       case 0:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           four->fourfirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           four->fourfirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       four->fourfirstImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 1:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           four->foursecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           four->foursecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       four->foursecondImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 2:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           four->fourthirdImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           four->fourthirdImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       four->fourthirdImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 3:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           four->fourfourImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           four->fourfourImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       four->fourfourImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                           
                       default:
                           break;
                   }
               }
               totalpages = [NSString stringWithFormat:@"%d",page+1];
               NSString *totalPagesCount = @"Page: ";
               [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
               [nextPageButton setEnabled:YES];
               break;
            }
           case 9:
           {
               [self destroyImageView];
               [self nineClicked];
               nineimageArray = TRUE;
               for(int j=0;j<9;j++)
               {
                   switch(j)
                   {
                       case 0:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninefirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninefirstImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninefirstImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 1:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninesecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninesecondImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninesecondImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 2:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninethirdImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninethirdImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninethirdImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 3:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninefourImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninefourImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninefourImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
    
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 4:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninefiveImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninefiveImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninefiveImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 5:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninesixImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninesixImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                    else
                                    {
                                        nine->ninesixImageView.image = temp;
                                        [UIView commitAnimations];
                                    }
                         

                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 6:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninesevenImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninesevenImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninesevenImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 7:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->nineeightImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->nineeightImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->nineeightImageView.image = temp;
                                       [UIView commitAnimations];
                                   }

                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }
                       case 8:
                       {
                           NSString *loadImage = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                           loadImage = [loadImage substringFromIndex:27];
                           
                           ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                           {
                               ALAssetRepresentation *rep = [myasset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               temp = [UIImage imageWithCGImage:iref];
                               
                               if (iref)
                               {
                                   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                                   {
                                       //for iPhone5
                                       if([[UIScreen mainScreen]bounds].size.height == 568)
                                       {
                                           nine->ninenineImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                       else
                                       {
                                           nine->ninenineImageView.image = temp;
                                           [UIView commitAnimations];
                                       }
                                   }
                                   else
                                   {
                                       nine->ninenineImageView.image = temp;
                                       [UIView commitAnimations];
                                   }
                                   
                               }
                               
                               
                           };
                           
                           
                           ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                           {
                               NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                           };
                           
                           if(loadImage && [loadImage length])
                           {
                               
                               NSURL *asseturl = [NSURL URLWithString:loadImage];
                               ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                               [assetslibrary assetForURL:asseturl
                                              resultBlock:resultblock
                                             failureBlock:failureblock];
                           }
                           
                           break;
                       }

                       default:
                           break;
                   }
               }
               totalpages = [NSString stringWithFormat:@"%d",page+1];
               NSString *totalPagesCount = @"Page: ";
               [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
               [nextPageButton setEnabled:YES];
               break;
           }
                default:
                break;
            }
       }
       endOfPage--;
       if(storeLayout == 0)
       {
           message = [[UIAlertView alloc] initWithTitle:nil
                                                message:@"You are on starting Page"
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles: nil];
           
           
           [message show];
           [self autoDissmissAlert];
           [previousPageButton setEnabled:NO];
           
       }
   }
    //pageDiscard = FALSE;
}

//button Method for creating button, with background image and other properties
- (void)onelayOut
{
   
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *oneLayOutImage = [UIImage imageNamed:@"x1_ios.png"];
            onelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            onelayOut.frame = CGRectMake(393.0, 193.0, 30.0, 30.0 );
            [onelayOut setBackgroundImage:oneLayOutImage  forState:UIControlStateNormal];
            [onelayOut addTarget:self action:@selector(oneClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:onelayOut];
        }
        else
        {
            UIImage *oneLayOutImage = [UIImage imageNamed:@"x1_ios.png"];
            onelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            onelayOut.frame = CGRectMake(322.0, 193.0, 30.0, 30.0 );
            [onelayOut setBackgroundImage:oneLayOutImage  forState:UIControlStateNormal];
            [onelayOut addTarget:self action:@selector(oneClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:onelayOut];
        }
        
    }
    else
    {
        UIImage *oneLayOutImage = [UIImage imageNamed:@"x1_ios.png"];
        onelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        onelayOut.frame = CGRectMake(735.0, 530.0, 45.0 ,45.0 );
        [onelayOut setBackgroundImage:oneLayOutImage  forState:UIControlStateNormal];
        [onelayOut addTarget:self action:@selector(oneClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:onelayOut];
    }
}

- (void)oneClicked
{
    if(pageDiscard)
    {
        omitPage1 = TRUE;
        discardPage = [[UIAlertView alloc]initWithTitle:@"Your page will be discarded" message:@"Do you Want to continue" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [discardPage show];
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                if(final)
                {
                    one = [[oneLayOut alloc] initWithNibName:@"oneLayOut_iphone5" bundle:nil];
                }
                else
                {
                    one = [[oneLayOut alloc] initWithNibName:@"oneLayOut_iphone5" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:one.view];
                [UIView commitAnimations];
            }
            else
            {
                if(final)
                {
                    one = [[oneLayOut alloc] initWithNibName:@"oneLayOut_iphone" bundle:nil];
                }
                else
                {
                    one = [[oneLayOut alloc] initWithNibName:@"oneLayOut_iphone" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:one.view];
                [UIView commitAnimations];
            }
            
        }
        else
        {
            if(final)
            {
                one = [[oneLayOut alloc] initWithNibName:@"oneLayOut_ipad" bundle:nil];
            }
            else
            {
                one = [[oneLayOut alloc] initWithNibName:@"oneLayOut_ipad" bundle:nil];
                pages = [[pagesViewController alloc] init];
                pages->imageURL=[[NSMutableArray alloc]init];
                pages->extraImage = [[NSMutableArray alloc]init];
                pages->videoArray = [[NSMutableArray alloc]init];
                pages->musicArray = [[NSMutableArray alloc]init];
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                pages->webLink=[[NSMutableArray alloc]init];
            }
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [self->toprightView addSubview:one.view];
            [UIView commitAnimations];
        }
        
        layOutClicked = 1;
        oneImageCounter = 0;
        
        if(buildingAlbum)
        {
            two= NULL;
            three = NULL;
            four = NULL;
            nine = NULL;
        }
        else
        {
            two= NULL;
            three = NULL;
            four = NULL;
            nine = NULL;
        }
        pageDiscard = TRUE;
     
    }
}

- (void)twolayOut
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *twoLayOutImage = [UIImage imageNamed:@"x2_ios.png"];
            twolayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            twolayOut.frame = CGRectMake(428.0, 193.0, 30.0, 30.0 );
            [twolayOut setBackgroundImage:twoLayOutImage  forState:UIControlStateNormal];
            [twolayOut addTarget:self action:@selector(twoClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:twolayOut];
        }
        else
        {
            UIImage *twoLayOutImage = [UIImage imageNamed:@"x2_ios.png"];
            twolayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            twolayOut.frame = CGRectMake(354.0, 193.0, 30.0, 30.0 );
            [twolayOut setBackgroundImage:twoLayOutImage  forState:UIControlStateNormal];
            [twolayOut addTarget:self action:@selector(twoClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:twolayOut];
        }
        
    }
    else
    {
        UIImage *twoLayOutImage = [UIImage imageNamed:@"x2_ios.png"];
        twolayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        twolayOut.frame = CGRectMake(791, 530.0, 45.0 ,45.0 );
        [twolayOut setBackgroundImage:twoLayOutImage  forState:UIControlStateNormal];
        [twolayOut addTarget:self action:@selector(twoClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:twolayOut];
    }
}

- (void)twoClicked
{
    if(pageDiscard)
    {
        omitPage2 = TRUE;
        discardPage = [[UIAlertView alloc]initWithTitle:@"Your page will be discarded" message:@"Do you Want to continue" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [discardPage show];
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                if(final)
                {
                    two  = [[twoLayOut alloc] initWithNibName:@"twoLayOut_iphone5" bundle:nil];
                }
                else
                {
                    two  = [[twoLayOut alloc] initWithNibName:@"twoLayOut_iphone5" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:two.view];
                [UIView commitAnimations];
            }
            else
            {
                if(final)
                {
                    two  = [[twoLayOut alloc] initWithNibName:@"twoLayOut_iphone" bundle:nil];
                }
                else
                {
                    two  = [[twoLayOut alloc] initWithNibName:@"twoLayOut_iphone" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:two.view];
                [UIView commitAnimations];
            }
        }
        else
        {
            if(final)
            {
                two  = [[twoLayOut alloc] initWithNibName:@"twoLayOut_ipad" bundle:nil];
            }
            else
            {
                two  = [[twoLayOut alloc] initWithNibName:@"twoLayOut_ipad" bundle:nil];
                pages = [[pagesViewController alloc] init];
                pages->extraImage = [[NSMutableArray alloc]init];
                pages->imageURL=[[NSMutableArray alloc]init];
                pages->videoArray = [[NSMutableArray alloc]init];
                pages->musicArray = [[NSMutableArray alloc]init];
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                pages->webLink=[[NSMutableArray alloc]init];
            }
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [self->toprightView addSubview:two.view];
            [UIView commitAnimations];
        }
        layOutClicked = 2;
        twoImageCounter = 0;
        if(buildingAlbum)
        {
            one = NULL;
            three = NULL;
            four = NULL;
            nine = NULL;
        }
        else
        {
            one = NULL;
            three = NULL;
            four = NULL;
            nine = NULL;
        }
        pageDiscard = TRUE;
    }

}

- (void)threelayOut
{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *threeLayOutImage = [UIImage imageNamed:@"x3_ios.png"];
            threelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            threelayOut.frame = CGRectMake(463.0, 193.0, 30.0,30.0 );
            [threelayOut setBackgroundImage:threeLayOutImage  forState:UIControlStateNormal];
            [threelayOut addTarget:self action:@selector(threeClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:threelayOut];
        }
        else
        {
            UIImage *threeLayOutImage = [UIImage imageNamed:@"x3_ios.png"];
            threelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            threelayOut.frame = CGRectMake(386.0, 193.0, 30.0,30.0 );
            [threelayOut setBackgroundImage:threeLayOutImage  forState:UIControlStateNormal];
            [threelayOut addTarget:self action:@selector(threeClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:threelayOut];
        }
    }
    else
    {
        UIImage *threeLayOutImage = [UIImage imageNamed:@"x3_ios.png"];
        threelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        threelayOut.frame = CGRectMake(846.0, 530.0, 45.0 ,45.0);
        [threelayOut setBackgroundImage:threeLayOutImage  forState:UIControlStateNormal];
        [threelayOut addTarget:self action:@selector(threeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:threelayOut];
    }
}

- (void)threeClicked
{

    if(pageDiscard)
    {
        omitPage3 = TRUE;
        discardPage = [[UIAlertView alloc]initWithTitle:@"Your page will be discarded" message:@"Do you Want to continue" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [discardPage show];
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                if(final)
                {
                    three = [[threeLayOut alloc] initWithNibName:@"threeLayOut_iphone5" bundle:nil];
                    
                }
                else
                {
                    three = [[threeLayOut alloc] initWithNibName:@"threeLayOut_iphone5" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:three.view];
                [UIView commitAnimations];
            }
            else
            {
                if(final)
                {
                    three = [[threeLayOut alloc] initWithNibName:@"threeLayOut_iphone" bundle:nil];
                    
                }
                else
                {
                    three = [[threeLayOut alloc] initWithNibName:@"threeLayOut_iphone" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:three.view];
                [UIView commitAnimations];
            }
        }
        else
        {
            if(final)
            {
                three = [[threeLayOut alloc] initWithNibName:@"threeLayOut_ipad" bundle:nil];
            }
            else
            {
                three = [[threeLayOut alloc] initWithNibName:@"threeLayOut_ipad" bundle:nil];
                pages = [[pagesViewController alloc] init];
                pages->extraImage = [[NSMutableArray alloc]init];
                pages->imageURL=[[NSMutableArray alloc]init];
                pages->videoArray = [[NSMutableArray alloc]init];
                pages->musicArray = [[NSMutableArray alloc]init];
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                pages->webLink=[[NSMutableArray alloc]init];
            }
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [self->toprightView addSubview:three.view];
            [UIView commitAnimations];
        }
        layOutClicked = 3;
        threeImageCounter = 0;
        
        if(buildingAlbum)
        {
            one = NULL;
            two = NULL;
            four = NULL;
            nine = NULL;
        }
        else
        {
            one = NULL;
            two = NULL;
            four = NULL;
            nine = NULL;
        }
        pageDiscard = TRUE;
    }
}

- (void)fourlayOut
{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *fourLayOutImage = [UIImage imageNamed:@"x4_ios.png"];
            fourlayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            fourlayOut.frame = CGRectMake(498.0, 193.0, 30.0, 30.0 );
            [fourlayOut setBackgroundImage:fourLayOutImage forState:UIControlStateNormal];
            [fourlayOut addTarget:self action:@selector(fourClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:fourlayOut];
        }
        else
        {
            UIImage *fourLayOutImage = [UIImage imageNamed:@"x4_ios.png"];
            fourlayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            fourlayOut.frame = CGRectMake(418.0, 193.0, 30.0, 30.0 );
            [fourlayOut setBackgroundImage:fourLayOutImage forState:UIControlStateNormal];
            [fourlayOut addTarget:self action:@selector(fourClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:fourlayOut];
        }
    }
    else
    {
        UIImage *fourLayOutImage = [UIImage imageNamed:@"x4_ios.png"];
        fourlayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        fourlayOut.frame = CGRectMake(902.0, 530.0, 45.0 ,45.0);
        [fourlayOut setBackgroundImage:fourLayOutImage forState:UIControlStateNormal];
        [fourlayOut addTarget:self action:@selector(fourClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fourlayOut];
    }
    
}

- (void)fourClicked
{
    if(pageDiscard)
    {
        omitPage4 = TRUE;
        discardPage = [[UIAlertView alloc]initWithTitle:@"Your page will be discarded" message:@"Do you Want to continue" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [discardPage show];
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                if(final)
                {
                    four = [[fourLayOut alloc] initWithNibName:@"fourLayOut_iphone5" bundle:nil];
                    
                }
                else
                {
                    four = [[fourLayOut alloc] initWithNibName:@"fourLayOut_iphone5" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:four.view];
                [UIView commitAnimations];
            }
            else
            {
                if(final)
                {
                    four = [[fourLayOut alloc] initWithNibName:@"fourLayOut_iphone" bundle:nil];
                    
                }
                else
                {
                    four = [[fourLayOut alloc] initWithNibName:@"fourLayOut_iphone" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:four.view];
                [UIView commitAnimations];
            }
        }
        else
        {
            if(final)
            {
                four = [[fourLayOut alloc] initWithNibName:@"fourLayOut_ipad" bundle:nil];
            }
            else
            {
                four = [[fourLayOut alloc] initWithNibName:@"fourLayOut_ipad" bundle:nil];
                pages = [[pagesViewController alloc] init];
                pages->extraImage = [[NSMutableArray alloc]init];
                pages->imageURL=[[NSMutableArray alloc]init];
                pages->videoArray = [[NSMutableArray alloc]init];
                pages->musicArray = [[NSMutableArray alloc]init];
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                pages->webLink=[[NSMutableArray alloc]init];
            }
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [self->toprightView addSubview:four.view];
            [UIView commitAnimations];
            
        }
        layOutClicked = 4;
        fourImageCounter = 0;
        if(buildingAlbum)
        {
            one = NULL;
            three = NULL;
            two = NULL;
            nine = NULL;
        }
        else
        {
            one = NULL;
            three = NULL;
            two = NULL;
            nine = NULL;
        }
        pageDiscard = TRUE;
    }
}

- (void)ninelayOut
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *nineLayOutImage = [UIImage imageNamed:@"x9_ios.png"];
            ninelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            ninelayOut.frame = CGRectMake(533.0, 193.0, 30.0, 30.0 );
            [ninelayOut setBackgroundImage:nineLayOutImage forState:UIControlStateNormal];
            [ninelayOut addTarget:self action:@selector(nineClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ninelayOut];
        }
        else
        {
            UIImage *nineLayOutImage = [UIImage imageNamed:@"x9_ios.png"];
            ninelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            ninelayOut.frame = CGRectMake(450.0, 193.0, 30.0, 30.0 );
            [ninelayOut setBackgroundImage:nineLayOutImage forState:UIControlStateNormal];
            [ninelayOut addTarget:self action:@selector(nineClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ninelayOut];
        }
    }
    else
    {
        UIImage *nineLayOutImage = [UIImage imageNamed:@"x9_ios.png"];
        ninelayOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        ninelayOut.frame = CGRectMake(958.0, 530.0, 45.0 ,45.0 );
        [ninelayOut setBackgroundImage:nineLayOutImage forState:UIControlStateNormal];
        [ninelayOut addTarget:self action:@selector(nineClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ninelayOut];
        
    }
    
}

- (void)nineClicked
{
    if(pageDiscard)
    {
        omitPage9 = TRUE;
        discardPage = [[UIAlertView alloc]initWithTitle:@"Your page will be discarded" message:@"Do you Want to continue" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [discardPage show];
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                if(final)
                {
                    nine = [[nineLayOut alloc] initWithNibName:@"nineLayOut_iphone5" bundle:nil];
                }
                else
                {
                    nine = [[nineLayOut alloc] initWithNibName:@"nineLayOut_iphone5" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:nine.view];
                [UIView commitAnimations];
            }
            else
            {
                if(final)
                {
                    nine = [[nineLayOut alloc] initWithNibName:@"nineLayOut_iphone" bundle:nil];
                }
                else
                {
                    nine = [[nineLayOut alloc] initWithNibName:@"nineLayOut_iphone" bundle:nil];
                    pages = [[pagesViewController alloc] init];
                    pages->extraImage = [[NSMutableArray alloc]init];
                    pages->imageURL=[[NSMutableArray alloc]init];
                    pages->videoArray = [[NSMutableArray alloc]init];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    pages->webLink=[[NSMutableArray alloc]init];
                }
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
                [self->toprightView addSubview:nine.view];
                [UIView commitAnimations];
            }
        }
        else
        {
            if(final)
            {
                nine = [[nineLayOut alloc] initWithNibName:@"nineLayOut_ipad" bundle:nil];
            }
            else
            {
                nine = [[nineLayOut alloc] initWithNibName:@"nineLayOut_ipad" bundle:nil];
                pages = [[pagesViewController alloc] init];
                pages->extraImage = [[NSMutableArray alloc]init];
                pages->imageURL=[[NSMutableArray alloc]init];
                pages->videoArray = [[NSMutableArray alloc]init];
                pages->musicArray = [[NSMutableArray alloc]init];
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                pages->webLink=[[NSMutableArray alloc]init];
            }
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            [self->toprightView addSubview:nine.view];
            [UIView commitAnimations];
        }
        layOutClicked = 9;
        nineImageCounter = 0;
        
        if(buildingAlbum)
        {
            one = NULL;
            three = NULL;
            four = NULL;
            two = NULL;
        }
        else
        {
            one = NULL;
            three = NULL;
            four = NULL;
            two = NULL;
        }
        pageDiscard = TRUE;
    }
}

- (void)accordianButton
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            accordianButton.frame = CGRectMake(388.0, 145.0, 179.0, 42.0 );
            //for Button 1st label
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 100, 15)];
            titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
            titleLabel.text = @"Tag Additonal";
            titleLabel.numberOfLines = 2;
            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [accordianButton addSubview:titleLabel];
            
            //for button 2nd Label
            secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 25)];
            secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
            secondTitleLabel.text = @"Media";
            [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
            [accordianButton addSubview:secondTitleLabel];
            
            //for setting indicator imageView
            UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
            indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 32, 5)];
            [indicatorImageView setImage:indicatorImage];
            [accordianButton addSubview:indicatorImageView];
            
            [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:accordianButton];
        }
        else
        {
            UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            accordianButton.frame = CGRectMake(320.0, 145.0, 159.0, 42.0 );
            //for Button 1st label
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 100, 15)];
            titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
            titleLabel.text = @"Tag Additonal";
            titleLabel.numberOfLines = 2;
            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [accordianButton addSubview:titleLabel];
            
            //for button 2nd Label
            secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 25)];
            secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
            secondTitleLabel.text = @"Media";
            [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
            [accordianButton addSubview:secondTitleLabel];
            
            //for setting indicator imageView
            UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
            indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 32, 5)];
            [indicatorImageView setImage:indicatorImage];
            [accordianButton addSubview:indicatorImageView];
            
            [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:accordianButton];
        }
    }
    else
    {
        UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        accordianButton.frame = CGRectMake(730.0, 380.0, 280.0, 80.0 );
        //for Button 1st label
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 120, 25)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.text = @"Tag Additonal";
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [accordianButton addSubview:titleLabel];
        
        //for button 2nd Label
        secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 60, 25)];
        secondTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        secondTitleLabel.text = @"Media";
        [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
        [accordianButton addSubview:secondTitleLabel];
        
        //for setting indicator imageView
        UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
        indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 55, 56, 8)];
        [indicatorImageView setImage:indicatorImage];
        [accordianButton addSubview:indicatorImageView];
        
        [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:accordianButton];
    }
}


-(void)accordianClicked
{
    if(isInitAccordian)
    {
        [self controlAccrodian];
        isInitAccordian = false;
        extraitem = [[NSMutableArray alloc]init];
        extraVideoItem = [[NSMutableArray alloc] init];
        extraAudioItem = [[NSMutableArray alloc]init];
        extraAudioTitle = [[NSMutableArray alloc]init];
        extraWebItem = [[NSMutableArray alloc]init];
    }
    if(builderNav)
    {
        for(int i=0;i<[((pagesViewController *) pageCollection[page])->extraImage count];i++)
        {
            
            editImageCounter = 0;
            [view1 reloadData];
        }
        for(int i=0;i<[((pagesViewController *) pageCollection[page])->finalMusicTitle count];i++)
        {
            editAudioCounter = 0;
            [view2 reloadData];
        }
        for(int i=0;i<[((pagesViewController *) pageCollection[page])->videoArray count];i++)
        {
            editVideoCounter = 0;
            [view3 reloadData];
        }
        for(int i=0;i<[((pagesViewController *) pageCollection[page])->webLink count];i++)
        {
            editWebCounter = 0;
            [view4 reloadData];
        }
        
    }
    
    if(editClicked)
    {
        if (setAccordian)
        {
            Allow = TRUE;
            setAccordian = FALSE;
            accordianOpen = TRUE;
            [accordion setHidden:FALSE];
            finished = TRUE;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(388.0, 145.0, 179.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Media Being";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Tagged";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for indicatorimageView
                    UIImage *indicatorImage = [UIImage imageNamed:@"greenline.jpg"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(62, 32, 40, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                }
                else
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(320.0, 145.0, 159.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Media Being";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Tagged";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for indicatorimageView
                    UIImage *indicatorImage = [UIImage imageNamed:@"greenline.jpg"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(62, 32, 40, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                }
            }
            else
            {
                UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                accordianButton.frame = CGRectMake(730.0, 380.0, 280.0, 80.0  );
                //for Button 1st label
                titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 120, 25)];
                titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                titleLabel.text = @"Media Being";
                titleLabel.numberOfLines = 2;
                titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:titleLabel];
                
                //for button 2nd Label
                secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 80, 25)];
                secondTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                secondTitleLabel.text = @"Tagged";
                [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:secondTitleLabel];
                
                //for indicatorimageView
                UIImage *indicatorImage = [UIImage imageNamed:@"greenline.jpg"];
                indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 55, 60, 8)];
                [indicatorImageView setImage:indicatorImage];
                [accordianButton addSubview:indicatorImageView];
                
                [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:accordianButton];
            }
            
        }
        
        else
        {
            Allow = FALSE;
            accordianOpen = FALSE;
            setAccordian = TRUE;
            [accordion setHidden:TRUE];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(388.0, 145.0, 179.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Tag Additonal";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Media";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for setting indicator imageview
                    UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 32, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                }
                else
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(320.0, 145.0, 159.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Tag Additonal";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Media";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for setting indicator imageview
                    UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 32, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                }
            }
            else
            {
                UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                accordianButton.frame = CGRectMake(730.0, 380.0, 280.0, 80.0 );
                //for Button 1st label
                titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 120, 25)];
                titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                titleLabel.text = @"Tag Additonal";
                titleLabel.numberOfLines = 2;
                titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:titleLabel];
                
                //for button 2nd Label
                secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 60, 25)];
                secondTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                secondTitleLabel.text = @"Media";
                [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:secondTitleLabel];
                
                //for setting indicator imageView
                UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
                indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 55, 56, 8)];
                [indicatorImageView setImage:indicatorImage];
                [accordianButton addSubview:indicatorImageView];
                
                [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:accordianButton];
            }
            
        }
        
    }
    
    //FOR EDIT ALBUM LOOP
    else
    {
        if(editAccordianOpen)
        {
            mainMusic = FALSE;
            if(!mainMusic && NewPageEditACase)
                isalbumFinished = TRUE;
            if(isalbumFinished)
            {
                //FOR EXTRA IMAGE IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[pages->extraImage count];i++)
                {
                    editArray1[i] = pages->extraImage[i];
                }
                pages->extraImage = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    NSString *localString = [editArray1[i] description];
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            //for iPhone5
                            if([[UIScreen mainScreen]bounds].size.height == 568)
                            {
                                editImageCounter = 0;
                                [pages->extraImage addObject:myasset];
                                [view1 reloadData];
                            }
                            else
                            {
                                editImageCounter = 0;
                                [pages->extraImage addObject:myasset];
                                [view1 reloadData];
                            }
                        }
                        else
                        {
                            editImageCounter = 0;
                            [pages->extraImage addObject:myasset];
                            [view1 reloadData];
                        }
                        
                    };
                    
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                    if([localString hasPrefix:@"A"])
                    {
                        localString = [localString substringFromIndex:27];
                    }
                    if(localString && [localString length])
                    {
                        
                        NSURL *asseturl = [NSURL URLWithString:localString];
                        
                        [assetsLibrary assetForURL:asseturl
                                       resultBlock:resultblock
                                      failureBlock:failureblock];
                    }
                }
                //FOR EXTRA VIDEO IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[pages->videoArray count];i++)
                {
                    editArray1[i] = pages->videoArray[i];
                }
                pages->videoArray = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    
                    NSString *localString = [editArray1[i] description];
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            //for iPhone5
                            if([[UIScreen mainScreen]bounds].size.height == 568)
                            {
                                editVideoCounter = 0;
                                [pages->videoArray addObject:myasset];
                                [view3 reloadData];
                            }
                            else
                            {
                                editVideoCounter = 0;
                                [pages->videoArray addObject:myasset];
                                [view3 reloadData];
                            }
                        }
                        else
                        {
                            editVideoCounter = 0;
                            [pages->videoArray addObject:myasset];
                            [view3 reloadData];
                        }
                        
                    };
                    
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                    if([localString hasPrefix:@"A"])
                    {
                        localString = [localString substringFromIndex:27];
                    }
                    if(localString && [localString length])
                    {
                        NSURL *asseturl = [NSURL URLWithString:localString];
                        
                        [assetsLibrary assetForURL:asseturl
                                       resultBlock:resultblock
                                      failureBlock:failureblock];
                    }
                }
                //FOR EXTRA AUDIO IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[pages->musicArray count];i++)
                {
                    editArray1[i] = pages->musicArray[i];
                }
                pages->musicArray = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            [pages->musicArray addObject:editArray1[i]];
                        }
                        else
                        {
                            [pages->musicArray addObject:editArray1[i]];
                        }
                    }
                    else
                    {
                        [pages->musicArray addObject:editArray1[i]];
                    }
                }
                //FOR EXTRA AUDIO TITLE IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[pages->finalMusicTitle count];i++)
                {
                    editArray1[i] = pages->finalMusicTitle[i];
                }
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            editAudioCounter = 0;
                            [pages->finalMusicTitle addObject:editArray1[i]];
                            [view2 reloadData];
                        }
                        else
                        {
                            editAudioCounter = 0;
                            [pages->finalMusicTitle addObject:editArray1[i]];
                            [view2 reloadData];
                        }
                    }
                    else
                    {
                        editAudioCounter = 0;
                        [pages->finalMusicTitle addObject:editArray1[i]];
                        [view2 reloadData];
                    }
                }
                
                //FOR WEBLINK IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[pages->webLink count];i++)
                {
                    editArray1[i] = pages->webLink[i];
                }
                pages->webLink = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            editWebCounter = 0;
                            [pages->webLink addObject:editArray1[i]];
                            [view4 reloadData];
                        }
                        else
                        {
                            editWebCounter = 0;
                            [pages->webLink addObject:editArray1[i]];
                            [view4 reloadData];
                        }
                    }
                    else
                    {
                        editWebCounter = 0;
                        [pages->webLink addObject:editArray1[i]];
                        [view4 reloadData];
                    }
                }
                
                
            }
            else
            {
                //FOR EXTRA IMAGE IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController *) pageCollection[pp])->extraImage count];i++)
                {
                    editArray1[i] = ((pagesViewController *) pageCollection[pp])->extraImage[i];
                }
                pages->extraImage = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    NSString *localString = [editArray1[i] description];
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            //for iPhone5
                            if([[UIScreen mainScreen]bounds].size.height == 568)
                            {
                                editImageCounter = 0;
                                [pages->extraImage addObject:myasset];
                                [view1 reloadData];
                            }
                            else
                            {
                                editImageCounter = 0;
                                [pages->extraImage addObject:myasset];
                                [view1 reloadData];
                            }
                        }
                        else
                        {
                            editImageCounter = 0;
                            [pages->extraImage addObject:myasset];
                            [view1 reloadData];
                        }
                        
                    };
                    
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                    if([localString hasPrefix:@"A"])
                    {
                        localString = [localString substringFromIndex:27];
                    }
                    if(localString && [localString length])
                    {
                        
                        NSURL *asseturl = [NSURL URLWithString:localString];
                        
                        [assetsLibrary assetForURL:asseturl
                                       resultBlock:resultblock
                                      failureBlock:failureblock];
                    }
                }
                
                //FOR EXTRA VIDEO IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController *) pageCollection[pp])->videoArray count];i++)
                {
                    editArray1[i] = ((pagesViewController *) pageCollection[pp])->videoArray[i];
                }
                pages->videoArray = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    
                    NSString *localString = [editArray1[i] description];
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            //for iPhone5
                            if([[UIScreen mainScreen]bounds].size.height == 568)
                            {
                                editVideoCounter = 0;
                                [pages->videoArray addObject:myasset];
                                [view3 reloadData];
                            }
                            else
                            {
                                editVideoCounter = 0;
                                [pages->videoArray addObject:myasset];
                                [view3 reloadData];
                            }
                        }
                        else
                        {
                            editVideoCounter = 0;
                            [pages->videoArray addObject:myasset];
                            [view3 reloadData];
                        }
                        
                    };
                    
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                    if([localString hasPrefix:@"A"])
                    {
                        localString = [localString substringFromIndex:27];
                    }
                    if(localString && [localString length])
                    {
                        NSURL *asseturl = [NSURL URLWithString:localString];
                        
                        [assetsLibrary assetForURL:asseturl
                                       resultBlock:resultblock
                                      failureBlock:failureblock];
                    }
                }
                //FOR EXTRA AUDIO IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController *) pageCollection[pp])->musicArray count];i++)
                {
                    editArray1[i] = ((pagesViewController *) pageCollection[pp])->musicArray[i];
                }
                pages->musicArray = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            editAudioCounter = 0;
                            [pages->musicArray addObject:editArray1[i]];
                        }
                        else
                        {
                            editAudioCounter = 0;
                            [pages->musicArray addObject:editArray1[i]];
                        }
                    }
                    else
                    {
                        editAudioCounter = 0;
                        [pages->musicArray addObject:editArray1[i]];
                    }
                }
                //FOR EXTRA AUDIO TITLE IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController *) pageCollection[pp])->finalMusicTitle count];i++)
                {
                    editArray1[i] = ((pagesViewController *) pageCollection[pp])->finalMusicTitle[i];
                }
                pages->finalMusicTitle = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            editAudioCounter = 0;
                            [pages->finalMusicTitle addObject:editArray1[i]];
                            [view2 reloadData];
                        }
                        else
                        {
                            editAudioCounter = 0;
                            [pages->finalMusicTitle addObject:editArray1[i]];
                            [view2 reloadData];
                        }
                    }
                    else
                    {
                        editAudioCounter = 0;
                        [pages->finalMusicTitle addObject:editArray1[i]];
                        [view2 reloadData];
                    }
                }
                //FOR WEBLINK IN EDIT ALBUM
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController *) pageCollection[pp])->webLink count];i++)
                {
                    editArray1[i] = ((pagesViewController *) pageCollection[pp])->webLink[i];
                }
                pages->webLink = [[NSMutableArray alloc]init];
                for(int i=0;i<[editArray1 count];i++)
                {
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            editWebCounter = 0;
                            [pages->webLink addObject:editArray1[i]];
                            [view4 reloadData];
                        }
                        else
                        {
                            editWebCounter = 0;
                            [pages->webLink addObject:editArray1[i]];
                            [view4 reloadData];
                        }
                    }
                    else
                    {
                        editWebCounter = 0;
                        [pages->webLink addObject:editArray1[i]];
                        [view4 reloadData];
                    }
                }
            }
            Allow = TRUE;
            setAccordian = FALSE;
            accordianOpen = TRUE;
            [accordion setHidden:FALSE];
            finished = TRUE;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(388.0, 145.0, 179.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Media Being";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Tagged";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for indicatorimageView
                    UIImage *indicatorImage = [UIImage imageNamed:@"greenline.jpg"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(62, 32, 40, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                    editAccordianOpen = FALSE;
                }
                else
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(320.0, 145.0, 159.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Media Being";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Tagged";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for indicatorimageView
                    UIImage *indicatorImage = [UIImage imageNamed:@"greenline.jpg"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(62, 32, 40, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                    editAccordianOpen = FALSE;
                }
            }
            else
            {
                UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                accordianButton.frame = CGRectMake(730.0, 380.0, 280.0, 80.0  );
                //for Button 1st label
                titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 120, 25)];
                titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                titleLabel.text = @"Media Being";
                titleLabel.numberOfLines = 2;
                titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:titleLabel];
                
                //for button 2nd Label
                secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 80, 25)];
                secondTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                secondTitleLabel.text = @"Tagged";
                [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:secondTitleLabel];
                
                //for indicatorimageView
                UIImage *indicatorImage = [UIImage imageNamed:@"greenline.jpg"];
                indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 55, 60, 8)];
                [indicatorImageView setImage:indicatorImage];
                [accordianButton addSubview:indicatorImageView];
                
                [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:accordianButton];
                editAccordianOpen = FALSE;
            }
        }
        else
        {
            mainMusic = TRUE;
            if(mainMusic)
                isalbumFinished = FALSE;
            editAccordianOpen = TRUE;
            for (UITableView *view in [view1 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view2 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view3 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view4 subviews])
            {
                [view removeFromSuperview];
            }
            Allow = FALSE;
            accordianOpen = FALSE;
            setAccordian = TRUE;
            [accordion setHidden:TRUE];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(388.0, 145.0, 179.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Tag Additonal";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Media";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for setting indicator imageview
                    UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 32, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                }
                else
                {
                    UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    accordianButton.frame = CGRectMake(320.0, 145.0, 159.0, 42.0 );
                    //for Button 1st label
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 2, 100, 15)];
                    titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    titleLabel.text = @"Tag Additonal";
                    titleLabel.numberOfLines = 2;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:titleLabel];
                    
                    //for button 2nd Label
                    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 40, 25)];
                    secondTitleLabel.font = [UIFont boldSystemFontOfSize:11.0];
                    secondTitleLabel.text = @"Media";
                    [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                    [accordianButton addSubview:secondTitleLabel];
                    
                    //for setting indicator imageview
                    UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
                    indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 30, 32, 5)];
                    [indicatorImageView setImage:indicatorImage];
                    [accordianButton addSubview:indicatorImageView];
                    
                    [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:accordianButton];
                }
            }
            else
            {
                UIButton *accordianButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                accordianButton.frame = CGRectMake(730.0, 380.0, 280.0, 80.0 );
                //for Button 1st label
                titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 120, 25)];
                titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                titleLabel.text = @"Tag Additonal";
                titleLabel.numberOfLines = 2;
                titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [titleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:titleLabel];
                
                //for button 2nd Label
                secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 60, 25)];
                secondTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
                secondTitleLabel.text = @"Media";
                [secondTitleLabel setBackgroundColor:[UIColor clearColor]];
                [accordianButton addSubview:secondTitleLabel];
                
                //for setting indicator imageView
                UIImage *indicatorImage = [UIImage imageNamed:@"grey.gif"];
                indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 55, 56, 8)];
                [indicatorImageView setImage:indicatorImage];
                [accordianButton addSubview:indicatorImageView];
                
                [accordianButton addTarget:self action:@selector(accordianClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:accordianButton];
            }
            
        }
    }
}

- (void)controlAccrodian
{
    if(web)
    {
        if(view4)
        {
            webStatus = [[UILabel alloc]init];
            webStatus.text =@"webView";
        }
        else
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    UIButton *header4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
                    [header4 setTitle:@"WebLink" forState:UIControlStateNormal];
                    view4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
                    view4.delegate = self;
                    view4.dataSource = self;
                    view4.tag = 6;
                    view4.backgroundColor = [UIColor grayColor];
                    [accordion addHeader:header4 withView:view4];
                    [accordion setNeedsLayout];
                    // Set this if you want to allow multiple selection
                    [accordion setAllowsMultipleSelection:YES];
                }
                else
                {
                    UIButton *header4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
                    [header4 setTitle:@"WebLink" forState:UIControlStateNormal];
                    view4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
                    view4.delegate = self;
                    view4.dataSource = self;
                    view4.tag = 6;
                    view4.backgroundColor = [UIColor grayColor];
                    [accordion addHeader:header4 withView:view4];
                    [accordion setNeedsLayout];
                    // Set this if you want to allow multiple selection
                    [accordion setAllowsMultipleSelection:YES];
                }
            }
            else
            {
                UIButton *header4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
                [header4 setTitle:@"WebLink" forState:UIControlStateNormal];
                view4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
                view4.delegate = self;
                view4.dataSource = self;
                view4.tag = 6;
                view4.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header4 withView:view4];
                [accordion setNeedsLayout];
                // Set this if you want to allow multiple selection
                [accordion setAllowsMultipleSelection:YES];
            }
             web = FALSE;
        }

    }
    else
    {
        [self.view addSubview:accordion];
        
        // Only height is taken into account, so other parameters are just dummy
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                UIButton *header1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                [header1 setTitle:@"Image" forState:UIControlStateNormal];
                view1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                view1.delegate = self;
                view1.dataSource = self;
                view1.tag = 3;
                view1.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header1 withView:view1];
                
                UIButton *header2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                [header2 setTitle:@"Audio" forState:UIControlStateNormal];
                view2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                view2.delegate = self;
                view2.dataSource = self;
                view2.tag = 4;
                view2.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header2 withView:view2];
                
                UIButton *header3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                [header3 setTitle:@"Video" forState:UIControlStateNormal];
                view3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                view3.delegate = self;
                view3.dataSource = self;
                view3.tag = 5;
                view3.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header3 withView:view3];
                if(editWeb)
                {
                    UIButton *header4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                    [header4 setTitle:@"WebLink" forState:UIControlStateNormal];
                    view4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                    view4.delegate = self;
                    view4.dataSource = self;
                    view4.tag = 6;
                    view4.backgroundColor = [UIColor grayColor];
                    [accordion addHeader:header4 withView:view4];
                }
                
                [accordion setNeedsLayout];
                
                // Set this if you want to allow multiple selection
                [accordion setAllowsMultipleSelection:YES];
            }
            else
            {
                UIButton *header1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                [header1 setTitle:@"Image" forState:UIControlStateNormal];
                view1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                view1.delegate = self;
                view1.dataSource = self;
                view1.tag = 3;
                view1.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header1 withView:view1];
                
                UIButton *header2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                [header2 setTitle:@"Audio" forState:UIControlStateNormal];
                view2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                view2.delegate = self;
                view2.dataSource = self;
                view2.tag = 4;
                view2.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header2 withView:view2];
                
                UIButton *header3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                [header3 setTitle:@"Video" forState:UIControlStateNormal];
                view3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                view3.delegate = self;
                view3.dataSource = self;
                view3.tag = 5;
                view3.backgroundColor = [UIColor grayColor];
                [accordion addHeader:header3 withView:view3];
                if(editWeb)
                {
                    UIButton *header4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
                    [header4 setTitle:@"WebLink" forState:UIControlStateNormal];
                    view4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)style:UITableViewStyleGrouped];
                    view4.delegate = self;
                    view4.dataSource = self;
                    view4.tag = 6;
                    view4.backgroundColor = [UIColor grayColor];
                    [accordion addHeader:header4 withView:view4];
                }
                
                [accordion setNeedsLayout];
                
                // Set this if you want to allow multiple selection
                [accordion setAllowsMultipleSelection:YES];
            }
        }
        else
        {
            UIButton *header1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
            [header1 setTitle:@"Image" forState:UIControlStateNormal];
            view1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
            view1.delegate = self;
            view1.dataSource = self;
            view1.tag = 3;
            view1.backgroundColor = [UIColor grayColor];
            [accordion addHeader:header1 withView:view1];
            
            UIButton *header2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
            [header2 setTitle:@"Audio" forState:UIControlStateNormal];
            view2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
            view2.delegate = self;
            view2.dataSource = self;
            view2.tag = 4;
            view2.backgroundColor = [UIColor grayColor];
            [accordion addHeader:header2 withView:view2];
            
            UIButton *header3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
            [header3 setTitle:@"Video" forState:UIControlStateNormal];
            view3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
            view3.delegate = self;
            view3.dataSource = self;
            view3.tag = 5;
            view3.backgroundColor = [UIColor grayColor];
            [accordion addHeader:header3 withView:view3];
            
            if(editWeb)
             {
                 UIButton *header4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
                 [header4 setTitle:@"WebLink" forState:UIControlStateNormal];
                 view4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 340)style:UITableViewStyleGrouped];
                 view4.delegate = self;
                 view4.dataSource = self;
                 view4.tag = 6;
                 view4.backgroundColor = [UIColor grayColor];
                 [accordion addHeader:header4 withView:view4];
             }
            [accordion setNeedsLayout];
            [accordion setAllowsMultipleSelection:YES];
        }

    }
    
}

//---------------------------------Next Button and Button Action-------------------------------//
- (void)next
{
     
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *nextBUttonImage = [UIImage imageNamed:@"next.png"];
            nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nextButton.frame = CGRectMake(398.0, 240.0, 75.0,30.0 );
            [nextButton setBackgroundImage:nextBUttonImage forState:UIControlStateNormal];
            [nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:nextButton ];
        }
        else
        {
            UIImage *nextBUttonImage = [UIImage imageNamed:@"next.png"];
            nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nextButton.frame = CGRectMake(325.0, 240.0, 75.0,30.0 );
            [nextButton setBackgroundImage:nextBUttonImage forState:UIControlStateNormal];
            [nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:nextButton ];
        }
    }
    else
    {
        UIImage *nextBUttonImage = [UIImage imageNamed:@"next.png"];
        nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nextButton.frame = CGRectMake(735.0, 620.0, 120.0, 40.0 );
        [nextButton setBackgroundImage:nextBUttonImage forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton ];
        
    }
}

- (void)nextClicked
{
    pageDiscard = FALSE;
    //FOR DIRECT NEXT PAGE ANY EDIT ALBUM
    if(enterEditAlbum)
    {
        if(pageFill)
        {
            for (UITableView *view in [view1 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view2 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view3 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view4 subviews])
            {
                [view removeFromSuperview];
            }
            //for getting Original View Again
            for (UIView *view in [toprightView subviews])
            {
                [view removeFromSuperview];
            }
            accordianOpen = FALSE;
            setAccordian = FALSE;
            additem = FALSE;
            [accordion setHidden:TRUE];
            [self accordianButton];
            extraitem = [[NSMutableArray alloc]init];
            extraVideoItem = [[NSMutableArray alloc]init];
            extraAudioItem = [[NSMutableArray alloc]init];
            extraAudioTitle = [[NSMutableArray alloc]init];
            extraWebItem = [[NSMutableArray alloc]init];
            storeLayout++;
            page = [pageCollection count];
            endPage = [pageCollection count];
            totalpages = [NSString stringWithFormat:@"%d",[pageCollection count]+1];
            NSString *totalPagesCount = @"Page: ";
            [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
            isalbumFinished = TRUE;
            editImage = TRUE;
            pageFill = FALSE;
            remove = FALSE;
            NewPageEditACase = TRUE;
            pp = pp+1;
            cp = pp+1;
            counter = 0;
            counter1 = 0;
            counter2 = 0;
            counter3 = 0;
            secondimageArray = FALSE;
            thirdimageArray = FALSE;
            fourimageArray = FALSE;
            nineimageArray = FALSE;
            message = [[UIAlertView alloc] initWithTitle:nil
                                                 message:@"Page is Saved"
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles: nil];
            
            [message show];
            [self oneClicked];
            pages = [[pagesViewController alloc]init];
            pages->imageURL = [[NSMutableArray alloc]init];
            pages->extraImage = [[NSMutableArray alloc]init];
            pages->musicArray = [[NSMutableArray alloc]init];
            pages->finalMusicTitle = [[NSMutableArray alloc]init];
            pages->videoArray = [[NSMutableArray alloc]init];
            pages->webLink = [[NSMutableArray alloc]init];
            [previousPageButton setEnabled:YES];
            [self autoDissmissAlert];
            /*if(mainMusic)
                isalbumFinished = FALSE;*/
        }
        else
        {
            message = [[UIAlertView alloc] initWithTitle:nil
                                                 message:@"Page is not fill"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles: nil];
            
            
            [message show];
            [self autoDissmissAlert];
        }
    }
    //--------------------------FOR BUILDER NEXT PAGE CODE--------------------------------//
    else
    {
        //For Alert Window
        if(pageFill && (layOutIsFilled))
        {
            if(pageFill)
            {
                replaceImage = FALSE;
                if(builderNav)
                    pages->pagecounter = pagescounter;
                else
                {
                    pages->pagecounter = pagescounter;
                    pagescounter++;
                }
                pageFill = FALSE;
                for (UITableView *view in [view1 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UITableView *view in [view2 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UITableView *view in [view3 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UITableView *view in [view4 subviews])
                {
                    [view removeFromSuperview];
                }
                //for getting Original View Again
                for (UIView *view in [toprightView subviews])
                {
                    [view removeFromSuperview];
                }
                accordianOpen = FALSE;
                setAccordian = TRUE;
                additem = FALSE;
                [accordion setHidden:TRUE];
                [self accordianButton];
                extraitem = [[NSMutableArray alloc]init];
                extraVideoItem = [[NSMutableArray alloc]init];
                extraAudioItem = [[NSMutableArray alloc]init];
                extraAudioTitle = [[NSMutableArray alloc]init];
                extraWebItem = [[NSMutableArray alloc]init];
                storeLayout++;
                page = [pageCollection count];
                endPage = [pageCollection count];
                builderNav = FALSE;
                secondimageArray = FALSE;
                thirdimageArray = FALSE;
                fourimageArray = FALSE;
                nineimageArray = FALSE;
                counter = 0;
                counter1 = 0;
                counter2 = 0;
                counter3 = 0;
                
            }
            else
            {
                one = NULL;
                two = NULL;
                three = NULL;
                four = NULL;
                nine = NULL;
                
            }
            totalpages = [NSString stringWithFormat:@"%d",[pageCollection count]+1];
            NSString *totalPagesCount = @"Page: ";
            [pageCountLabel setText:[totalPagesCount stringByAppendingString:totalpages]];
            message = [[UIAlertView alloc] initWithTitle:nil
                                                 message:@"Page is Saved"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles: nil];
            
            [message show];
            [self oneClicked];
            [self autoDissmissAlert];
            //builderNav = FALSE;
            
        }
        else
        {
            message = [[UIAlertView alloc] initWithTitle:nil
                                                 message:@"Page is not fill"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles: nil];
            
            
            [message show];
            [self autoDissmissAlert];
            
        }
        
    }
    layOutIsFilled = FALSE;
    navigationedit = FALSE;
    pageDiscard = FALSE;

}

//----------------for  Automatic Dissmiss AlertView------------------------//

-(void)autoDissmissAlert
{
    [self performSelector:@selector(dismissAlertView:) withObject:message afterDelay:1];
}
-(void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

//-------------------------Save Alert Button Method----------------------------------------//

-(void)copyLink
{
    NSString *finalLink;
    if([detailViewController->browserLink hasPrefix:@"http://"]||[detailViewController->browserLink hasPrefix:@"https://"])
    {
        finalLink = [NSString stringWithString:detailViewController->browserLink];
    }
    else
    {
        finalLink = @"http://";
        finalLink = [finalLink stringByAppendingString:detailViewController->browserLink];
    }
    if(enterEditAlbum)
    {
        if(isalbumFinished)
        {
            
            editWebCounter = 0;
            [pages->webLink addObject:finalLink];
            [view4 reloadData];
            
        }
        else
        {
            editWebCounter = 0;
            editArray1 = [[NSMutableArray alloc]init];
            [pages->webLink addObject:finalLink];
            int layOut = ((pagesViewController*)pageCollection[pp])->layoutused;
            
            //FOR MAIN IMAGE
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->imageURL[i] = editArray1[i];
            }
            
            //FOR EXTRA IMAGE
            editArray1 = [[NSMutableArray alloc]init];
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->extraImage[i] = editArray1[i];
            }
            
            //FOR EXTRA AUDIO
            editArray1 = [[NSMutableArray alloc]init];
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->musicArray[i] = editArray1[i];
            }
            //FOR EXTRA AUDIO TITLE
            editArray1 = [[NSMutableArray alloc]init];
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->finalMusicTitle[i] = editArray1[i];
            }
            //FOR EXTRA VIDEO
            editArray1 = [[NSMutableArray alloc]init];
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->videoArray[i] = editArray1[i];
            }
            pages->layoutused = layOut;
            [pageCollection removeObjectAtIndex:pp];
            [pageCollection insertObject:pages atIndex:pp];
            [view4 reloadData];
        }
        
    }
    else
    {
        if(Allow )
        {
            if(additem)
            {
                if(one)
                {
                    extraWebCounter = 0;
                    [pages->webLink addObject:finalLink];
                    [view4 reloadData];
                    
                }
                if(two)
                {
                    extraWebCounter = 0;
                    [pages->webLink addObject:finalLink];
                    [view4 reloadData];
                }
                if(three)
                {
                    extraWebCounter = 0;
                    [pages->webLink addObject:finalLink];
                    [view4 reloadData];
                }
                if(four)
                {
                    extraWebCounter = 0;
                    [pages->webLink addObject:finalLink];
                    [view4 reloadData];
                }
                if(nine)
                {
                    extraWebCounter = 0;
                    [pages->webLink addObject:finalLink];
                    [view4 reloadData];
                }
            }
            
            else
            {
                if(builderNav)
                {
                    editWebCounter= 0;
                    [((pagesViewController *) pageCollection[page])->webLink addObject:finalLink];
                    [view4 reloadData];
                }
                else
                {
                    extraWebCounter = 0;
                    [extraWebItem addObject:finalLink];
                    [view4 reloadData];
                }
                
            }
            
        }
    }
    finalLink = nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if([title isEqualToString:@"Add Comment"])
    {

        NSString *comment = [[commentLine textFieldAtIndex:0] text];
        if(one)
        {
            pages->comment = [NSString stringWithString:comment];
        }
        if(two)
        {
            pages->comment = [NSString stringWithString:comment];
        }
        if(three)
        {
            pages->comment = [NSString stringWithString:comment];
        }
        if(four)
        {
            pages->comment = [NSString stringWithString:comment];
        }
        if(nine)
        {
            pages->comment = [NSString stringWithString:comment];
        }
        
    }
    if(save)
    {
        if([title isEqualToString:@"Yes"])
        {
            [self yesClicked];
            save = FALSE;
        }
         if([title isEqualToString:@"Cancel"])
         {
             save = FALSE;
         }
    }
   
    if(editSave)
    {
        if([title isEqualToString:@"SelectTheme"])
        {
            [self themeClicked];
        }
        if([title isEqualToString:@"Cancel"])
        {
            editSave = FALSE;
        }
        if([title isEqualToString:@"Yes"])
        {
            [self yesClicked];
            editSave = FALSE;
        }
        if([title isEqualToString:@"Cancel"])
        {
            editSave = FALSE;
        }
    }
    if(overWrite)
    {
        if([title isEqualToString:@"OverWrite"])
        {
            [self overWriteYesClicked];
            overWrite = FALSE;
        }
        if([title isEqualToString:@"No"])
        {
            overWrite = FALSE;
        }
        
    }
    if(omitPage1)
    {
        if([title isEqualToString:@"Yes"])
        {
             pageDiscard = FALSE;
            [self oneClicked];
            if(omitPage)
            {
                [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                isalbumFinished = TRUE;
            }
            omitPage1 = FALSE;
            remove = FALSE;
        }
        if([title isEqualToString:@"No"])
        {
            omitPage1 = FALSE;
        }
    }
    if(omitPage2)
    {
        if([title isEqualToString:@"Yes"])
        {
            pageDiscard = FALSE;
            [self twoClicked];
            if(omitPage)
            {
                [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                isalbumFinished = TRUE;
            }
            omitPage2 = FALSE;
             remove = FALSE;
        }
        if([title isEqualToString:@"No"])
        {
            omitPage2 = FALSE;
        }
    }
    if(omitPage3)
    {
        if([title isEqualToString:@"Yes"])
        {
            pageDiscard = FALSE;
            [self threeClicked];
            if(omitPage)
            {
                
                [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                isalbumFinished = TRUE;
                    
            }
            omitPage3 = FALSE;
             remove = FALSE;
        }
        if([title isEqualToString:@"No"])
        {
            omitPage3 = FALSE;
        }
    }
    if(omitPage4)
    {
        if([title isEqualToString:@"Yes"])
        {
            pageDiscard = FALSE;
            [self fourClicked];
            if(omitPage)
            {
                [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                isalbumFinished = TRUE;
            }
            omitPage4 = FALSE;
             remove = FALSE;
        }
        if([title isEqualToString:@"No"])
        {
            omitPage4 = FALSE;
        }
    }
    if(omitPage9)
    {
        if([title isEqualToString:@"Yes"])
        {
            pageDiscard = FALSE;
            [self nineClicked];
            if(omitPage)
            {
                [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                isalbumFinished = TRUE;
            }
            omitPage9 = FALSE;
             remove = FALSE;
        }
        if([title isEqualToString:@"No"])
        {
            omitPage9 = FALSE;
        }
    }

}

//------------------------------------Save Button and Save Button Function -----------------------------//
- (void)save
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            UIImage *saveButtonImage = [UIImage imageNamed:@"save.png"];
            saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            saveButton .frame = CGRectMake(483.0, 240.0, 75.0,30.0 );
            saveButton.tag = 1;
            [saveButton  setBackgroundImage:saveButtonImage forState:UIControlStateNormal];
            [saveButton  addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:saveButton ];
        }
        else
        {
            UIImage *saveButtonImage = [UIImage imageNamed:@"save.png"];
            saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            saveButton .frame = CGRectMake(405.0, 240.0, 75.0,30.0 );
            saveButton.tag = 1;
            [saveButton  setBackgroundImage:saveButtonImage forState:UIControlStateNormal];
            [saveButton  addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:saveButton ];
        }
    }
    else
    {
        UIImage *saveButtonImage = [UIImage imageNamed:@"save.png"];
        saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        saveButton.frame = CGRectMake(870.0, 620.0, 120.0, 40.0);
        saveButton.tag = 1;
        [saveButton  setBackgroundImage:saveButtonImage forState:UIControlStateNormal];
        [saveButton  addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:saveButton ];
        
    }
}

- (void)saveClicked
{
    themeList = [NSArray arrayWithObjects:@"iOS Theme",@"Colors", @"Party Theme", @"Glass", @"BirthDay", @"Win8 Blue", @"Win8 Pink", @"Indian Wedding", @"Generic Wedding",@"Desert",@"Black and White", nil];
    if(enterEditAlbum)
    {
            editSave = TRUE;
            saveAlert = [[UIAlertView alloc] initWithTitle:nil
                                               message:@"Do You Want to ChangeTheme"
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"SelectTheme", nil];
            [saveAlert show];
    }
    else
    {
        if([pageCollection count]>0)
        {
            save = TRUE;
            [self themeClicked];
        }
        else
        {
        
            autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Sorry!! Can't Save Album"
                                                            message:@"Not Selecting any Media Content"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [autoDissmissalertView show];
            [self performSelector:@selector(saveAlertAutoDissmiss:) withObject:autoDissmissalertView afterDelay:3];
        }
    }
    isalbumFinished = FALSE;

}
-(void)saveAlertAutoDissmiss :(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    autoDissmissalertView = nil;
}
- (void)yesClicked
{
    pageDiscard = FALSE;
    UITextField *textField = [saveAlert textFieldAtIndex:0];
    if ([textField.text length] == 0)
    {
        UIAlertView *saveAlbumAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Enter a Album Name"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:nil];
        [saveAlbumAlert show];
        [self performSelector:@selector(saveAlbumAlertAutoDissmiss:) withObject:saveAlbumAlert afterDelay:2];
        
    }
    else
    {
        //------------------------------------for Edit Album Case-----------------------------//
        if(enterEditAlbum)
        {
            [saveAlert dismissWithClickedButtonIndex:0 animated:YES];
            dirName  = [[saveAlert textFieldAtIndex:0] text];
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *userCreated =[ documentsDirectory stringByAppendingString: @"/User"];
            yourDirPath = [userCreated stringByAppendingPathComponent:dirName];
            fileManager = [NSFileManager defaultManager];
            BOOL isDir = YES;
            BOOL isDirExists = [fileManager fileExistsAtPath:yourDirPath isDirectory:&isDir];
            if (!isDirExists) [fileManager createDirectoryAtPath:yourDirPath withIntermediateDirectories:YES attributes:nil error:nil];
            //putting XML File Into The User Created Directory
            finalPath = [yourDirPath stringByAppendingPathComponent:@"Pronto.xml"];
            NSError *error;
            if (![[NSFileManager defaultManager] fileExistsAtPath:yourDirPath])
            {
                [[NSFileManager defaultManager] createFileAtPath:yourDirPath contents:nil attributes:nil];
                
                [finalPath writeToFile:yourDirPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
            }
            if([dirName isEqualToString:editalbumName])
            {
                overWrite = TRUE;
                saveAlert = nil;
                saveAlert = [[UIAlertView alloc] initWithTitle:@"The album already exists"
                                                       message:@"Do you want to overwrite it ?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"OverWrite",nil];
                [saveAlert show];
            }
            
            //EDITALBUM CHANGE NAME XML WRITE----
            else
            {
                finalPath = [yourDirPath stringByAppendingPathComponent:@"Pronto.xml"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:yourDirPath])
                {
                    [[NSFileManager defaultManager] createFileAtPath:yourDirPath contents:nil attributes:nil];
                    
                    [finalPath writeToFile:yourDirPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    
                }
                XMLWriter* xmlWriter = [[XMLWriter alloc]init];
                [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
                
                // start writing XML elements
                [xmlWriter writeStartElement:@"Album"];
                [xmlWriter writeAttribute:@"name" value:dirName];
                NSString *string = [NSString stringWithFormat:@"%d",[pageCollection count]];
                [xmlWriter writeAttribute:@"TotalPages" value:string];
                [xmlWriter writeAttribute:@"theme" value:themeString];
                
                NSString *xmlString ;
                NSString *intString ;
                //main Xml Writing
                for(int i=0;i<[pageCollection count];i++)
                {
                    switch( ((pagesViewController *) pageCollection[i])->layoutused)
                    {
                        case 12:
                        {
                            for(int j=0;j<1;j++)
                            {
                                [xmlWriter writeStartElement:@"page"];
                                [xmlWriter writeStartElement:@"LU"];
                                [xmlWriter writeCharacters:@"12"];
                                [xmlWriter writeEndElement];
                                [xmlWriter writeStartElement:@"MainImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"MainImages"];
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->extraImage count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"ExtraImages"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"ExtraImages"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->musicArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Audios"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Audios"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"AudioTitle"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"AudioTitle"];
                                    
                                }
                                
                            }
                            
                            if([((pagesViewController*) pageCollection[i])->webLink count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                                {
                                    [xmlWriter writeStartElement:@"WebLink"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"WebLink"];
                                }
                            }
                            
                            intString = [NSString  stringWithFormat:@"%d",i];
                            [xmlWriter writeStartElement:@"CP"];
                            [xmlWriter writeCharacters:intString];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeEndElement];
                        }
                            break;
                        case 1:
                        {
                            for(int j=0;j<1;j++)
                            {
                                [xmlWriter writeStartElement:@"page"];
                                [xmlWriter writeStartElement:@"LU"];
                                [xmlWriter writeCharacters:@"1"];
                                [xmlWriter writeEndElement];
                                [xmlWriter writeStartElement:@"MainImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"MainImages"];
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->extraImage count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"ExtraImages"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"ExtraImages"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->videoArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Videos"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Videos"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->musicArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Audios"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Audios"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"AudioTitle"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"AudioTitle"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->webLink count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                                {
                                    [xmlWriter writeStartElement:@"WebLink"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"WebLink"];
                                }
                            }
                            if(((pagesViewController*) pageCollection[i])->comment)
                            {
                                [xmlWriter writeStartElement:@"Comment"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Comment"];
                            }
                            
                            intString = [NSString  stringWithFormat:@"%d",i];
                            [xmlWriter writeStartElement:@"CP"];
                            [xmlWriter writeCharacters:intString];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeEndElement];
                        }
                            break;
                        case 2:
                        {
                            [xmlWriter writeStartElement:@"page"];
                            [xmlWriter writeStartElement:@"LU"];
                            [xmlWriter writeCharacters:@"2"];
                            [xmlWriter writeEndElement];
                            
                            for(int j=0;j<2;j++)
                            {
                                
                                [xmlWriter writeStartElement:@"MainImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"MainImages"];
                                
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->extraImage count])
                            {
                                for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                                {
                                    [xmlWriter writeStartElement:@"ExtraImages"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"ExtraImages"];
                                }
                            }
                            if([((pagesViewController*) pageCollection[i])->videoArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Videos"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Videos"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->musicArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Audios"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Audios"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"AudioTitle"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"AudioTitle"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->webLink count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                                {
                                    [xmlWriter writeStartElement:@"WebLink"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"WebLink"];
                                }
                            }
                            if(((pagesViewController*) pageCollection[i])->comment)
                            {
                                [xmlWriter writeStartElement:@"Comment"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Comment"];
                            }
                            
                            intString = [NSString stringWithFormat:@"%d", i];
                            [xmlWriter writeStartElement:@"CP"];
                            [xmlWriter writeCharacters:intString];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeEndElement];
                            break;
                        }
                            
                        case 3:
                        {
                            [xmlWriter writeStartElement:@"page"];
                            [xmlWriter writeStartElement:@"LU"];
                            [xmlWriter writeCharacters:@"3"];
                            [xmlWriter writeEndElement];
                            
                            for(int j=0;j<3;j++)
                            {
                                
                                [xmlWriter writeStartElement:@"MainImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"MainImages"];
                                
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->extraImage count])
                            {
                                for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                                {
                                    [xmlWriter writeStartElement:@"ExtraImages"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"ExtraImages"];
                                }
                            }
                            if([((pagesViewController*) pageCollection[i])->videoArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Videos"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                    
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Videos"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->musicArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Audios"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Audios"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"AudioTitle"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"AudioTitle"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->webLink count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                                {
                                    [xmlWriter writeStartElement:@"WebLink"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"WebLink"];
                                }
                            }
                            if(((pagesViewController*) pageCollection[i])->comment)
                            {
                                [xmlWriter writeStartElement:@"Comment"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Comment"];
                            }
                            
                            intString = [NSString stringWithFormat:@"%d", i];
                            [xmlWriter writeStartElement:@"CP"];
                            [xmlWriter writeCharacters:intString];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeEndElement];
                            break;
                        }
                            
                            
                        case 4:
                        {
                            [xmlWriter writeStartElement:@"page"];
                            [xmlWriter writeStartElement:@"LU"];
                            [xmlWriter writeCharacters:@"4"];
                            [xmlWriter writeEndElement];
                            
                            for(int j=0;j<4;j++)
                            {
                                
                                [xmlWriter writeStartElement:@"MainImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"MainImages"];
                                
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->extraImage count])
                            {
                                for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                                {
                                    [xmlWriter writeStartElement:@"ExtraImages"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"ExtraImages"];
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->videoArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Videos"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Videos"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->musicArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Audios"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Audios"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"AudioTitle"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"AudioTitle"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->webLink count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                                {
                                    [xmlWriter writeStartElement:@"WebLink"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"WebLink"];
                                }
                            }
                            if(((pagesViewController*) pageCollection[i])->comment)
                            {
                                [xmlWriter writeStartElement:@"Comment"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Comment"];
                            }
                            intString = [NSString stringWithFormat:@"%d", i];
                            [xmlWriter writeStartElement:@"CP"];
                            [xmlWriter writeCharacters:intString];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeEndElement];
                            break;
                        }
                            
                        case 9:
                        {
                            [xmlWriter writeStartElement:@"page"];
                            [xmlWriter writeStartElement:@"LU"];
                            [xmlWriter writeCharacters:@"9"];
                            [xmlWriter writeEndElement];
                            for(int j=0;j<9;j++)
                            {
                                
                                [xmlWriter writeStartElement:@"MainImages"];
                                
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"MainImages"];
                                
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->extraImage count])
                            {
                                for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                                {
                                    [xmlWriter writeStartElement:@"ExtraImages"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"ExtraImages"];
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->videoArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Videos"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                    if([xmlString hasPrefix:@"A"])
                                    {
                                        xmlString = [xmlString substringFromIndex:27];
                                    }
                                    
                                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Videos"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->musicArray count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"Audios"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"Audios"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                                {
                                    
                                    [xmlWriter writeStartElement:@"AudioTitle"];
                                    xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"AudioTitle"];
                                    
                                }
                                
                            }
                            if([((pagesViewController*) pageCollection[i])->webLink count])
                            {
                                for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                                {
                                    [xmlWriter writeStartElement:@"WebLink"];
                                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                    [xmlWriter writeCData:xmlString];
                                    [xmlWriter writeEndElement:@"WebLink"];
                                }
                            }
                            if(((pagesViewController*) pageCollection[i])->comment)
                            {
                                [xmlWriter writeStartElement:@"Comment"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Comment"];
                            }
                            
                            intString = [NSString stringWithFormat:@"%d",i];
                            [xmlWriter writeStartElement:@"CP"];
                            [xmlWriter writeCharacters:intString];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeEndElement];
                            break;
                        }
                        default:
                            break;
                    }
                    
                }
                
                [xmlWriter writeEndElement:@"Album"];
                // get the resulting XML string
                NSString *xml= [xmlWriter toString];
                NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
                [[NSFileManager defaultManager] createFileAtPath:finalPath contents:data attributes:nil];
                
                NSString *totalPagesCount = @"Page: ";
                [pageCountLabel setText:[totalPagesCount stringByAppendingString:@"1"]];
                pagescounter = 0;
                totalPages =0;
                cp=0;
                pp=0;
                pages->imageURL = NULL;
                pages->extraImage = NULL;
                pages->videoArray = NULL;
                pages->musicArray = NULL;
                pages->finalMusicTitle = NULL;
                pages->webLink = NULL;
                pages->comment = NULL;
                pages->layoutused = 0;
                isalbumFinished = FALSE;
                longPressGesture = NULL;
                extraitem = NULL;
                extraAudioItem = NULL;
                extraAudioTitle = NULL;
                extraVideoItem = NULL;
                extraWebItem = NULL;
                indicatorImageView = nil;
                saveAlert = nil;
                final = FALSE;
                NewPageEditACase = FALSE;
                editArray1 = NULL;
                pages = NULL;
                editImage = FALSE;
                pageCollection = [[NSMutableArray alloc] init];
                [saveAlert dismissWithClickedButtonIndex:2 animated:YES];
                saveAlert = nil;
                for (UITableView *view in [view1 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UITableView *view in [view2 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UITableView *view in [view3 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UITableView *view in [view4 subviews])
                {
                    [view removeFromSuperview];
                }
                for (UIView *view in [toprightView subviews])
                {
                    [view removeFromSuperview];
                }
                view1 = nil;
                view2 = nil;
                view3 = nil;
                view4 = nil;
                longPressGesture = nil;
                editAccordianOpen = FALSE;
                firstPageVideo = FALSE;
                webStatus = nil;
                autoDissmissalertView = nil;
                discardPage = nil;
                commentLine = nil;
                replaceImage = FALSE;
                longPressWebLink = nil;
                mainMusic = FALSE;
                [self accordianClicked];
                [self oneClicked];
               
            }
        }
        
        //------------------------------FROM BUILDING ALBUM XML WRITE------------------------//
        else
        {
            builderNav = FALSE;
            dirName = [[saveAlert textFieldAtIndex:0] text];
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *userCreated =[ documentsDirectory stringByAppendingString: @"/User"];
            yourDirPath = [userCreated stringByAppendingPathComponent:dirName];
            fileManager = [NSFileManager defaultManager];
            BOOL isDir = YES;
            BOOL isDirExists = [fileManager fileExistsAtPath:yourDirPath isDirectory:&isDir];
            if (isDirExists)
            {
                yourDirPath = [yourDirPath stringByAppendingString:@"(1)"];
                [fileManager createDirectoryAtPath:yourDirPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            else
            {
                [fileManager createDirectoryAtPath:yourDirPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //putting XML File Into The User Created Directory
            finalPath = [yourDirPath stringByAppendingPathComponent:@"Pronto.xml"];
            NSError *error;
            if (![[NSFileManager defaultManager] fileExistsAtPath:yourDirPath])
            {
                [[NSFileManager defaultManager] createFileAtPath:yourDirPath contents:nil attributes:nil];
                
                [finalPath writeToFile:yourDirPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
            }
            XMLWriter* xmlWriter = [[XMLWriter alloc]init];
            [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
            
            // start writing XML elements
            [xmlWriter writeStartElement:@"Album"];
            [xmlWriter writeAttribute:@"name" value:dirName];
            NSString *string = [NSString stringWithFormat:@"%d",[pageCollection count]];
            [xmlWriter writeAttribute:@"TotalPages" value:string];
            [xmlWriter writeAttribute:@"theme" value:themeString];
            
            NSString *xmlString ;
            NSString *intString ;
            //main Xml Writing
            for(int i=0;i<[pageCollection count];i++)
            {
                switch(((pagesViewController *) pageCollection[i])->layoutused)
                {
                    //------------For User Create Video Album-----------//
                    case 12:
                    {
                        for(int j=0;j<1;j++)
                        {
                            [xmlWriter writeStartElement:@"page"];
                            [xmlWriter writeStartElement:@"LU"];
                            [xmlWriter writeCharacters:@"12"];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeStartElement:@"MainImages"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                            if([xmlString hasPrefix:@"A"])
                            {
                                xmlString = [xmlString substringFromIndex:27];
                            }
                            xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"MainImages"];
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->extraImage count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"ExtraImages"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"ExtraImages"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->musicArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Audios"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Audios"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"AudioTitle"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"AudioTitle"];
                                
                            }
                            
                        }

                        
                        if([((pagesViewController*) pageCollection[i])->webLink count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                            {
                                [xmlWriter writeStartElement:@"WebLink"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"WebLink"];
                            }
                        }

                        intString = [NSString  stringWithFormat:@"%d",i];
                        [xmlWriter writeStartElement:@"CP"];
                        [xmlWriter writeCharacters:intString];
                        [xmlWriter writeEndElement];
                        [xmlWriter writeEndElement];
                    }
                        break;
                    case 1:
                    {
                        for(int j=0;j<1;j++)
                        {
                            [xmlWriter writeStartElement:@"page"];
                            [xmlWriter writeStartElement:@"LU"];
                            [xmlWriter writeCharacters:@"1"];
                            [xmlWriter writeEndElement];
                            [xmlWriter writeStartElement:@"MainImages"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                            if([xmlString hasPrefix:@"A"])
                            {
                                xmlString = [xmlString substringFromIndex:27];
                            }
                            xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"MainImages"];
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->extraImage count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"ExtraImages"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"ExtraImages"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->videoArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Videos"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Videos"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->musicArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Audios"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Audios"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"AudioTitle"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"AudioTitle"];
                                
                            }
                            
                        }
                        
                        if([((pagesViewController*) pageCollection[i])->webLink count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                            {
                                [xmlWriter writeStartElement:@"WebLink"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"WebLink"];
                            }
                        }
                        if(((pagesViewController*) pageCollection[i])->comment)
                        {
                            [xmlWriter writeStartElement:@"Comment"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"Comment"];
                        }
                        intString = [NSString  stringWithFormat:@"%d",i];
                        [xmlWriter writeStartElement:@"CP"];
                        [xmlWriter writeCharacters:intString];
                        [xmlWriter writeEndElement];
                        [xmlWriter writeEndElement];
                    }
                        break;
                    case 2:
                    {
                        [xmlWriter writeStartElement:@"page"];
                        [xmlWriter writeStartElement:@"LU"];
                        [xmlWriter writeCharacters:@"2"];
                        [xmlWriter writeEndElement];
                        
                        for(int j=0;j<2;j++)
                        {
                            
                            [xmlWriter writeStartElement:@"MainImages"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                            if([xmlString hasPrefix:@"A"])
                            {
                                xmlString = [xmlString substringFromIndex:27];
                            }
                            xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"MainImages"];
                            
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->extraImage count])
                        {
                            for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                            {
                                [xmlWriter writeStartElement:@"ExtraImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"ExtraImages"];
                            }
                        }
                        if([((pagesViewController*) pageCollection[i])->videoArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Videos"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Videos"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->musicArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Audios"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Audios"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"AudioTitle"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"AudioTitle"];
                                
                            }
                            
                        }

                        
                        if([((pagesViewController*) pageCollection[i])->webLink count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                            {
                                [xmlWriter writeStartElement:@"WebLink"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"WebLink"];
                            }
                        }
                        if(((pagesViewController*) pageCollection[i])->comment)
                        {
                            [xmlWriter writeStartElement:@"Comment"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"Comment"];
                        }
                        intString = [NSString  stringWithFormat:@"%d",i];
                        [xmlWriter writeStartElement:@"CP"];
                        [xmlWriter writeCharacters:intString];
                        [xmlWriter writeEndElement];
                        [xmlWriter writeEndElement];
                        break;
                    }
                        
                    case 3:
                    {
                        [xmlWriter writeStartElement:@"page"];
                        [xmlWriter writeStartElement:@"LU"];
                        [xmlWriter writeCharacters:@"3"];
                        [xmlWriter writeEndElement];
                        
                        for(int j=0;j<3;j++)
                        {
                            
                            [xmlWriter writeStartElement:@"MainImages"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                            if([xmlString hasPrefix:@"A"])
                            {
                                xmlString = [xmlString substringFromIndex:27];
                            }
                            xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"MainImages"];
                            
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->extraImage count])
                        {
                            for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                            {
                                [xmlWriter writeStartElement:@"ExtraImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"ExtraImages"];
                            }
                        }
                        if([((pagesViewController*) pageCollection[i])->videoArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Videos"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Videos"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->musicArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Audios"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Audios"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"AudioTitle"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"AudioTitle"];
                                
                            }
                            
                        }

                        
                        if([((pagesViewController*) pageCollection[i])->webLink count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                            {
                                [xmlWriter writeStartElement:@"WebLink"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"WebLink"];
                            }
                        }
                        if(((pagesViewController*) pageCollection[i])->comment)
                        {
                            [xmlWriter writeStartElement:@"Comment"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"Comment"];
                        }
                        
                        intString = [NSString  stringWithFormat:@"%d",i];
                        [xmlWriter writeStartElement:@"CP"];
                        [xmlWriter writeCharacters:intString];
                        [xmlWriter writeEndElement];
                        [xmlWriter writeEndElement];
                        break;
                    }
                        
                    case 4:
                    {
                        [xmlWriter writeStartElement:@"page"];
                        [xmlWriter writeStartElement:@"LU"];
                        [xmlWriter writeCharacters:@"4"];
                        [xmlWriter writeEndElement];
                        
                        for(int j=0;j<4;j++)
                        {
                            
                            [xmlWriter writeStartElement:@"MainImages"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                            if([xmlString hasPrefix:@"A"])
                            {
                                xmlString = [xmlString substringFromIndex:27];
                            }
                            xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"MainImages"];
                            
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->extraImage count])
                        {
                            for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                            {
                                [xmlWriter writeStartElement:@"ExtraImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"ExtraImages"];
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->videoArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Videos"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Videos"];
                                
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->musicArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"Audios"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Audios"];
                                
                            }
                        }
                        if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"AudioTitle"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"AudioTitle"];
                                
                            }
                            
                        }

                        if([((pagesViewController*) pageCollection[i])->webLink count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                            {
                                [xmlWriter writeStartElement:@"WebLink"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"WebLink"];
                            }
                        }
                        
                        if(((pagesViewController*) pageCollection[i])->comment)
                        {
                            [xmlWriter writeStartElement:@"Comment"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"Comment"];
                        }
                        intString = [NSString  stringWithFormat:@"%d",i];
                        [xmlWriter writeStartElement:@"CP"];
                        [xmlWriter writeCharacters:intString];
                        [xmlWriter writeEndElement];
                        [xmlWriter writeEndElement];
                        break;
                    }
                        
                    case 9:
                    {
                        [xmlWriter writeStartElement:@"page"];
                        [xmlWriter writeStartElement:@"LU"];
                        [xmlWriter writeCharacters:@"9"];
                        [xmlWriter writeEndElement];
                        for(int j=0;j<9;j++)
                        {
                            
                            [xmlWriter writeStartElement:@"MainImages"];
                            
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                            if([xmlString hasPrefix:@"A"])
                            {
                                xmlString = [xmlString substringFromIndex:27];
                            }
                            xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"MainImages"];
                            
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->extraImage count])
                        {
                            for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                            {
                                [xmlWriter writeStartElement:@"ExtraImages"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"ExtraImages"];
                            }
                            
                        }
                        if([((pagesViewController*) pageCollection[i])->videoArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                            {
                                [xmlWriter writeStartElement:@"Videos"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                                
                                if([xmlString hasPrefix:@"A"])
                                {
                                    xmlString = [xmlString substringFromIndex:27];
                                }
                                xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Videos"];
                            }
                        }
                        if([((pagesViewController*) pageCollection[i])->musicArray count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                            {
                                [xmlWriter writeStartElement:@"Audios"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"Audios"];
                            }
                        }
                        if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                            {
                                
                                [xmlWriter writeStartElement:@"AudioTitle"];
                                xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"AudioTitle"];
                                
                            }
                            
                        }

                        if([((pagesViewController*) pageCollection[i])->webLink count])
                        {
                            for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                            {
                                [xmlWriter writeStartElement:@"WebLink"];
                                xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                                [xmlWriter writeCData:xmlString];
                                [xmlWriter writeEndElement:@"WebLink"];
                            }
                        }
                        if(((pagesViewController*) pageCollection[i])->comment)
                        {
                            [xmlWriter writeStartElement:@"Comment"];
                            xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                            [xmlWriter writeCData:xmlString];
                            [xmlWriter writeEndElement:@"Comment"];
                        }
                        
                        intString = [NSString  stringWithFormat:@"%d",i];
                        [xmlWriter writeStartElement:@"CP"];
                        [xmlWriter writeCharacters:intString];
                        [xmlWriter writeEndElement];
                        [xmlWriter writeEndElement];
                        break;
                    }
                    default:
                        break;
                }
            }
            [xmlWriter writeEndElement:@"Album"];
            // get the resulting XML string
            NSString *xml= [xmlWriter toString];
            NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
            [[NSFileManager defaultManager] createFileAtPath:finalPath contents:data attributes:nil];
            NSString *totalPagesCount = @"Page: ";
            [pageCountLabel setText:[totalPagesCount stringByAppendingString:@"1"]];
            pagescounter = 0;
            totalPages =0;
            clicked = TRUE;
            pages->imageURL = NULL;
            pages->extraImage = NULL;
            pages->videoArray = NULL;
            pages->musicArray = NULL;
            pages->finalMusicTitle = NULL;
            pages->webLink = NULL;
            pages->comment = NULL;
            extraitem = NULL;
            extraAudioItem = NULL;
            extraAudioTitle = NULL;
            extraVideoItem = NULL;
            extraWebItem = NULL;
            indicatorImageView = nil;
            saveAlert = nil;
            pages->layoutused = 0;
            longPressGesture = NULL;
            pages = NULL;
            editArray1 = NULL;
            pageCollection = [[NSMutableArray alloc] init];
            replaceImage = FALSE;
            [saveAlert dismissWithClickedButtonIndex:1 animated:YES];
            saveAlert = nil;
            for (UITableView *view in [view1 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view2 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view3 subviews])
            {
                [view removeFromSuperview];
            }
            for (UITableView *view in [view4 subviews])
            {
                [view removeFromSuperview];
            }
            for (UIView *view in [toprightView subviews])
            {
                [view removeFromSuperview];
            }
            view1 = nil;
            view2 = nil;
            view3 = nil;
            view4 = nil;
            secondimageArray = FALSE;
            thirdimageArray = FALSE;
            fourimageArray = FALSE;
            nineimageArray = FALSE;
            accordianOpen = FALSE;
            setAccordian = TRUE;
            additem = FALSE;
            videoWarning = FALSE;
            longPressGesture = nil;
            webStatus = nil;
            discardPage = nil;
            commentLine = nil;
            replaceImage = FALSE;
            autoDissmissalertView = nil;
            longPressWebLink = nil;
            mainMusic = FALSE;
            [accordion setHidden:TRUE];
            [self accordianButton];
            [self oneClicked];
        }
    }
    pageDiscard = FALSE;
    
}

//For EDIT ALBUM XML OVERWRITE
- (void)overWriteYesClicked
{
    pageDiscard = FALSE;
    NSError *error;
    [fileManager removeItemAtPath:finalPath error:&error];
    //after Create another
    finalPath = [yourDirPath stringByAppendingPathComponent:@"Pronto.xml"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:yourDirPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:yourDirPath contents:nil attributes:nil];
        
        [finalPath writeToFile:yourDirPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    
    // start writing XML elements
    [xmlWriter writeStartElement:@"Album"];
    [xmlWriter writeAttribute:@"name" value:dirName];
    NSString *string = [NSString stringWithFormat:@"%d",[pageCollection count]];
    [xmlWriter writeAttribute:@"TotalPages" value:string];
    [xmlWriter writeAttribute:@"theme" value:themeString];
    
    NSString *xmlString ;
    NSString *intString ;
    //main Xml Writing
    for(int i=0;i<[pageCollection count];i++)
    {
        switch( ((pagesViewController *) pageCollection[i])->layoutused)
        {
            case 12:
            {
                for(int j=0;j<1;j++)
                {
                    [xmlWriter writeStartElement:@"page"];
                    [xmlWriter writeStartElement:@"LU"];
                    [xmlWriter writeCharacters:@"12"];
                    [xmlWriter writeEndElement];
                    [xmlWriter writeStartElement:@"MainImages"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    if([xmlString hasPrefix:@"A"])
                    {
                        xmlString = [xmlString substringFromIndex:27];
                    }
                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"MainImages"];
                    
                }
                if([((pagesViewController*) pageCollection[i])->extraImage count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"ExtraImages"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->extraImage[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"ExtraImages"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->musicArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Audios"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Audios"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"AudioTitle"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"AudioTitle"];
                        
                    }
                    
                }
                
                if([((pagesViewController*) pageCollection[i])->webLink count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                    {
                        [xmlWriter writeStartElement:@"WebLink"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"WebLink"];
                    }
                }
                intString = [NSString  stringWithFormat:@"%d",i];
                [xmlWriter writeStartElement:@"CP"];
                [xmlWriter writeCharacters:intString];
                [xmlWriter writeEndElement];
                [xmlWriter writeEndElement];
            }
                break;
            case 1:
            {
                for(int j=0;j<1;j++)
                {
                    [xmlWriter writeStartElement:@"page"];
                    [xmlWriter writeStartElement:@"LU"];
                    [xmlWriter writeCharacters:@"1"];
                    [xmlWriter writeEndElement];
                    [xmlWriter writeStartElement:@"MainImages"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    if([xmlString hasPrefix:@"A"])
                    {
                        xmlString = [xmlString substringFromIndex:27];
                    }
                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"MainImages"];
                    
                }
                if([((pagesViewController*) pageCollection[i])->extraImage count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"ExtraImages"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->extraImage[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"ExtraImages"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->videoArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Videos"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Videos"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->musicArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Audios"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Audios"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"AudioTitle"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"AudioTitle"];
                        
                    }
                    
                }
                
                if([((pagesViewController*) pageCollection[i])->webLink count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                    {
                        [xmlWriter writeStartElement:@"WebLink"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"WebLink"];
                    }
                }
                if(((pagesViewController*) pageCollection[i])->comment)
                {
                    [xmlWriter writeStartElement:@"Comment"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"Comment"];
                }
                intString = [NSString  stringWithFormat:@"%d",i];
                [xmlWriter writeStartElement:@"CP"];
                [xmlWriter writeCharacters:intString];
                [xmlWriter writeEndElement];
                [xmlWriter writeEndElement];
            }
                break;
            case 2:
            {
                [xmlWriter writeStartElement:@"page"];
                [xmlWriter writeStartElement:@"LU"];
                [xmlWriter writeCharacters:@"2"];
                [xmlWriter writeEndElement];
                
                for(int j=0;j<2;j++)
                {
                    
                    [xmlWriter writeStartElement:@"MainImages"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    if([xmlString hasPrefix:@"A"])
                    {
                        xmlString = [xmlString substringFromIndex:27];
                    }
                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"MainImages"];
                    
                    
                }
                if([((pagesViewController*) pageCollection[i])->extraImage count])
                {
                    for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                    {
                        [xmlWriter writeStartElement:@"ExtraImages"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"ExtraImages"];
                    }
                }
                if([((pagesViewController*) pageCollection[i])->videoArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Videos"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Videos"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->musicArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Audios"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Audios"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"AudioTitle"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"AudioTitle"];
                        
                    }
                    
                }
                
                if([((pagesViewController*) pageCollection[i])->webLink count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                    {
                        [xmlWriter writeStartElement:@"WebLink"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"WebLink"];
                    }
                }
                
                if(((pagesViewController*) pageCollection[i])->comment)
                {
                    [xmlWriter writeStartElement:@"Comment"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"Comment"];
                }
                
                intString = [NSString stringWithFormat:@"%d", i];
                [xmlWriter writeStartElement:@"CP"];
                [xmlWriter writeCharacters:intString];
                [xmlWriter writeEndElement];
                [xmlWriter writeEndElement];
                break;
            }
                
            case 3:
            {
                [xmlWriter writeStartElement:@"page"];
                [xmlWriter writeStartElement:@"LU"];
                [xmlWriter writeCharacters:@"3"];
                [xmlWriter writeEndElement];
                
                for(int j=0;j<3;j++)
                {
                    
                    [xmlWriter writeStartElement:@"MainImages"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    if([xmlString hasPrefix:@"A"])
                    {
                        xmlString = [xmlString substringFromIndex:27];
                    }
                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"MainImages"];
                    
                }
                if([((pagesViewController*) pageCollection[i])->extraImage count])
                {
                    for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                    {
                        [xmlWriter writeStartElement:@"ExtraImages"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"ExtraImages"];
                    }
                }
                if([((pagesViewController*) pageCollection[i])->videoArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                    {
                        [xmlWriter writeStartElement:@"Videos"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Videos"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->musicArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Audios"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Audios"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"AudioTitle"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"AudioTitle"];
                        
                    }
                    
                }
                
                if([((pagesViewController*) pageCollection[i])->webLink count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                    {
                        [xmlWriter writeStartElement:@"WebLink"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"WebLink"];
                    }
                }
                if(((pagesViewController*) pageCollection[i])->comment)
                {
                    [xmlWriter writeStartElement:@"Comment"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"Comment"];
                }
                intString = [NSString stringWithFormat:@"%d", i];
                [xmlWriter writeStartElement:@"CP"];
                [xmlWriter writeCharacters:intString];
                [xmlWriter writeEndElement];
                [xmlWriter writeEndElement];
                break;
            }
                
                
            case 4:
            {
                [xmlWriter writeStartElement:@"page"];
                [xmlWriter writeStartElement:@"LU"];
                [xmlWriter writeCharacters:@"4"];
                [xmlWriter writeEndElement];
                for(int j=0;j<4;j++)
                {
                    [xmlWriter writeStartElement:@"MainImages"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    if([xmlString hasPrefix:@"A"])
                    {
                        xmlString = [xmlString substringFromIndex:27];
                    }
                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"MainImages"];
                }
                if([((pagesViewController*) pageCollection[i])->extraImage count])
                {
                    for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                    {
                        [xmlWriter writeStartElement:@"ExtraImages"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"ExtraImages"];
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->videoArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Videos"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Videos"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->musicArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Audios"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Audios"];
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"AudioTitle"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"AudioTitle"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->webLink count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                    {
                        [xmlWriter writeStartElement:@"WebLink"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"WebLink"];
                    }
                }
                if(((pagesViewController*) pageCollection[i])->comment)
                {
                    [xmlWriter writeStartElement:@"Comment"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"Comment"];
                }
                intString = [NSString stringWithFormat:@"%d", i];
                [xmlWriter writeStartElement:@"CP"];
                [xmlWriter writeCharacters:intString];
                [xmlWriter writeEndElement];
                [xmlWriter writeEndElement];
                break;
            }
                
            case 9:
            {
                [xmlWriter writeStartElement:@"page"];
                [xmlWriter writeStartElement:@"LU"];
                [xmlWriter writeCharacters:@"9"];
                [xmlWriter writeEndElement];
                for(int j=0;j<9;j++)
                {
                    
                    [xmlWriter writeStartElement:@"MainImages"];
                    
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->imageURL[j] description];
                    if([xmlString hasPrefix:@"A"])
                    {
                        xmlString = [xmlString substringFromIndex:27];
                    }
                    xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"MainImages"];
                    
                    
                }
                if([((pagesViewController*) pageCollection[i])->extraImage count])
                {
                    for(int k=0;k<[((pagesViewController*) pageCollection[i])->extraImage count];k++)
                    {
                        [xmlWriter writeStartElement:@"ExtraImages"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->extraImage[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"ExtraImages"];
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->videoArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->videoArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Videos"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->videoArray[k] description];
                        if([xmlString hasPrefix:@"A"])
                        {
                            xmlString = [xmlString substringFromIndex:27];
                        }
                        
                        xmlString= [xmlString stringByReplacingOccurrencesOfString:@"&" withString:@"'amp'"];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Videos"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->musicArray count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->musicArray count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"Audios"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->musicArray[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"Audios"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->finalMusicTitle count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->finalMusicTitle count];k++)
                    {
                        
                        [xmlWriter writeStartElement:@"AudioTitle"];
                        xmlString = (NSString*) [((pagesViewController*) pageCollection[i])->finalMusicTitle[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"AudioTitle"];
                        
                    }
                    
                }
                if([((pagesViewController*) pageCollection[i])->webLink count])
                {
                    for(int k=0;k <[((pagesViewController*) pageCollection[i])->webLink count];k++)
                    {
                        [xmlWriter writeStartElement:@"WebLink"];
                        xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->webLink[k] description];
                        [xmlWriter writeCData:xmlString];
                        [xmlWriter writeEndElement:@"WebLink"];
                    }
                }
                if(((pagesViewController*) pageCollection[i])->comment)
                {
                    [xmlWriter writeStartElement:@"Comment"];
                    xmlString = (NSString*) [ ((pagesViewController*) pageCollection[i])->comment description];
                    [xmlWriter writeCData:xmlString];
                    [xmlWriter writeEndElement:@"Comment"];
                }
                
                intString = [NSString stringWithFormat:@"%d",i];
                [xmlWriter writeStartElement:@"CP"];
                [xmlWriter writeCharacters:intString];
                [xmlWriter writeEndElement];
                [xmlWriter writeEndElement];
                break;
            }
            default:
                break;
        }
        
    }
    
    [xmlWriter writeEndElement:@"Album"];
    // get the resulting XML string
    NSString *xml= [xmlWriter toString];
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:finalPath contents:data attributes:nil];
    
    NSString *totalPagesCount = @"Page: ";
    [pageCountLabel setText:[totalPagesCount stringByAppendingString:@"1"]];
    pagescounter = 0;
    totalPages =0;
    editArray1 = NULL;
    pages->imageURL = NULL;
    pages->extraImage = NULL;
    pages->videoArray = NULL;
    pages->musicArray = NULL;
    pages->finalMusicTitle = NULL;
    pages->webLink = NULL;
    pages->comment = NULL;
    pages = NULL;
    cp = 0;
    pp = 0;
    isalbumFinished = FALSE;
    NewPageEditACase = FALSE;
    final = FALSE;
    editImage = FALSE;
    [saveAlert dismissWithClickedButtonIndex:2 animated:YES];
    saveAlert = nil;
    for (UITableView *view in [view1 subviews])
    {
        [view removeFromSuperview];
    }
    for (UITableView *view in [view2 subviews])
    {
        [view removeFromSuperview];
    }
    for (UITableView *view in [view3 subviews])
    {
        [view removeFromSuperview];
    }
    for (UIView *view in [toprightView subviews])
    {
        [view removeFromSuperview];
    }
    view1 = nil;
    view2 = nil;
    view3 = nil;
    view4 = nil;
    extraitem = NULL;
    extraAudioItem = NULL;
    extraAudioTitle = NULL;
    extraVideoItem = NULL;
    extraWebItem = NULL;
    indicatorImageView = nil;
    firstPageVideo = FALSE;
    editAccordianOpen = FALSE;
    longPressGesture = nil;
    saveAlert = nil;
    webStatus = nil;
    discardPage = nil;
    commentLine = nil;
    autoDissmissalertView = nil;
    replaceImage = FALSE;
    longPressWebLink = nil;
    [self accordianClicked];
    [self destroyImageView];
    [self oneClicked];
    pageDiscard = FALSE;
    omitPage = FALSE;
    mainMusic = FALSE;
}

-(void)saveAlbumAlertAutoDissmiss :(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

//For Selecting Theme at Building Time
- (void) themeClicked
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 50, 300, 160) style:UITableViewStyleGrouped];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.tag = 2;
            tableView.layer.cornerRadius = 7;
            tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor blackColor];
            tableView.rowHeight = 30.f;
            [self.view addSubview:tableView];
        }
        else
        {
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 50, 300, 160) style:UITableViewStyleGrouped];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.tag = 2;
            tableView.layer.cornerRadius = 7;
            tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor blackColor];
            tableView.rowHeight = 30.f;
            [self.view addSubview:tableView];
        }
    }
    else
    {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(260, 100, 500, 300) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = 2;
        tableView.layer.cornerRadius = 7;
        tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor blackColor];
        tableView.rowHeight = 50.f;
        [self.view addSubview:tableView];
    }
    

}

//-----------------------PUTTING EXTRA ITEM TABLE VIEW COMPLETE METHOD-----------------------//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)genTableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)genTableView numberOfRowsInSection:(NSInteger)section
{
    
      if(genTableView.tag == 3)
      {
              if(additem)
              {
                  if((one)&&(accordianOpen))
                      
                      return [pages->extraImage count];
                  
                  if((two)&&(accordianOpen))
                      
                      return [pages->extraImage count];
                  
                  if((three)&&(accordianOpen))
                      
                      return [pages->extraImage count];
                  
                  if((four)&&(accordianOpen))
                      
                      return [pages->extraImage count];
                  
                  if((nine)&&(accordianOpen))
                      
                      return [pages->extraImage count];
              }
              else
              {
                  if(builderNav)
                  {
                      return [((pagesViewController *) pageCollection[page])->extraImage count];
                  }
                  else
                  {
                    if(enterEditAlbum)
                    {
                        return [pages->extraImage count];
                    }
                    else
                    {
                        accordianCount =[extraitem count];
                        return [extraitem count];
                    }
                  }
            }
        
    }
   
    if(genTableView.tag == 4)
    {
        if(additem)
        {
            if((one)&&(accordianOpen))
                
                return [pages->musicArray count];
            
            if((two)&&(accordianOpen))
                
                return [pages->musicArray count];
            
            if((three)&&(accordianOpen))
                
                return [pages->musicArray count];
            
            if((four)&&(accordianOpen))
                
                return [pages->musicArray count];
            
            if((nine)&&(accordianOpen))
                
                return [pages->musicArray count];
            
        }
        else
        {
            if(builderNav)
            {
                return [((pagesViewController *) pageCollection[page])->musicArray count];
            }
            else
            {
                if(enterEditAlbum)
                {
                    return [pages->musicArray count];
                }
                else
                {
                    return [extraAudioItem count];
                }
            }
        }
    }
    if(genTableView.tag == 5)
    {
        if(additem)
        {
            if((one)&&(accordianOpen))
                
                return [pages->videoArray count];
            
            if((two)&&(accordianOpen))
                
                return [pages->videoArray count];
            
            if((three)&&(accordianOpen))
                
                return [pages->videoArray count];
            
            if((four)&&(accordianOpen))
                
                return [pages->videoArray count];
            
            if((nine)&&(accordianOpen))
                
                return [pages->videoArray count];
            
        }
        else
        {
            if(builderNav)
            {
                return [((pagesViewController *) pageCollection[page])->videoArray count];
            }
            else
            {
                if(enterEditAlbum)
                {
                    return [pages->videoArray count];
                }
                else
                {
                    return [extraVideoItem count];
                }
            }
        }
    }
    if(genTableView.tag == 6)
    {
        if(additem)
        {
            if((one)&&(accordianOpen))
                
                return [pages->webLink count];
            
            if((two)&&(accordianOpen))
                
                return [pages->webLink count];
            
            if((three)&&(accordianOpen))
                
                return [pages->webLink count];
            
            if((four)&&(accordianOpen))
                
                return [pages->webLink count];
            
            if((nine)&&(accordianOpen))
                
                return [pages->webLink count];
            
        }
        else
        {
            if(builderNav)
            {
                return [((pagesViewController *) pageCollection[page])->webLink count];
            }
            else
            {
                if(enterEditAlbum)
                {
                    return [pages->webLink count];
                }
                else
                {
                    return [extraWebItem count];
               }
            }
        }
    }
    else
        return 12;

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)genTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = [genTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        }
    
    if(genTableView.tag == 2)
    {
        themeList = [NSArray arrayWithObjects:@"Select Theme",@"iOS Theme",@"Colors", @"Party Theme", @"Glass", @"BirthDay", @"Win8 Blue", @"Win8 Pink", @"Indian Wedding", @"Generic Wedding",@"Desert",@"Black and White", nil];
        
        themeImageList = [NSArray arrayWithObjects:@" ",@"bg_iOS Theme_theme.png",@"bg_Colors_theme.png",@"bg_Party Theme_theme.png",@"bg_Glass_theme.png",@"bg_BirthDay_theme.png",@"bg_Win8 Blue_theme.png",@"bg_Win8 Pink_theme.png",@"bg_Indian Wedding_theme.png",@"bg_Generic Wedding_theme.png",@"bg_Desert_theme.png",@"bg_Black and White_theme.png", nil];
        
        cell.imageView.image = [UIImage imageNamed:[themeImageList objectAtIndex:indexPath.row]];
        if(indexPath.row == 0)
        {
            [cell.textLabel setText:[themeList objectAtIndex:indexPath.row]];
            cell.textLabel.font = [UIFont systemFontOfSize:18.0];
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            [cell.textLabel setText:[themeList objectAtIndex:indexPath.row]];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
    if(genTableView.tag == 3)
    {
      
        if(additem)
        {
            if((one)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->extraImage[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                [cell.imageView setImage:original];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];

            }
            if((two)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->extraImage[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20);
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((three)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->extraImage[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((four)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->extraImage[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20);
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((nine)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->extraImage[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
        }
        
        else
        {
            if(builderNav)
            {
                ALAssetRepresentation *representation = [((pagesViewController *) pageCollection[page])->extraImage[editImageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            else
            {
                if(enterEditAlbum)
                {
                    ALAssetRepresentation *representation = [pages->extraImage[editImageCounter++] defaultRepresentation];
                    CGImageRef originalImage = [representation fullScreenImage];
                    UIImage *original = [UIImage imageWithCGImage:originalImage];
                    cell.imageView.image = original;
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                    
                }
                else
                {
                    ALAssetRepresentation *representation = [extraitem[extraIMageCounter++] defaultRepresentation];
                    CGImageRef originalImage = [representation fullScreenImage];
                    UIImage *original = [UIImage imageWithCGImage:originalImage];
                    cell.imageView.image = original;
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                    
                }

            }
            
        }
       
    }
    if(genTableView.tag == 4)
    {
        if(additem)
        {
            if((one)&&(accordianOpen))
            {
                UIImage *original = [UIImage imageNamed:@"music.png"];
                cell.imageView.image = original;
                cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:extraIMageCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((two)&&(accordianOpen))
            {
                UIImage *original = [UIImage imageNamed:@"music.png"];
                cell.imageView.image = original;
                cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:extraIMageCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((three)&&(accordianOpen))
            {
                UIImage *original = [UIImage imageNamed:@"music.png"];
                cell.imageView.image = original;
                cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:extraIMageCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((four)&&(accordianOpen))
            {
                UIImage *original = [UIImage imageNamed:@"music.png"];
                cell.imageView.image = original;
                cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:extraIMageCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((nine)&&(accordianOpen))
            {
                UIImage *original = [UIImage imageNamed:@"music.png"];
                cell.imageView.image = original;
                cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:extraIMageCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
        }
        else
        {
            if(builderNav)
            {
                UIImage *original = [UIImage imageNamed:@"music.png"];
                cell.imageView.image = original;
                cell.textLabel.text = [((pagesViewController *) pageCollection[page])->finalMusicTitle objectAtIndex:editAudioCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            else
            {
                if(enterEditAlbum)
                {
                    UIImage *original = [UIImage imageNamed:@"music.png"];
                   cell.imageView.image = original;
                    cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:editAudioCounter++];
                    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                }
                else
                {
                    UIImage *original = [UIImage imageNamed:@"music.png"];
                    cell.imageView.image = original;
                    cell.textLabel.text = [pages->finalMusicTitle objectAtIndex:extraIMageCounter++];
                    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                }

            }
        }
        
    }

    if(genTableView.tag == 5)
    {
        
        if(additem)
        {
            if((one)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->videoArray[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((two)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->videoArray[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((three)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->videoArray[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((four)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->videoArray[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            if((nine)&&(accordianOpen))
            {
                ALAssetRepresentation *representation = [pages->videoArray[extraIMageCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
        }
        else
        {
            if(builderNav)
            {
                ALAssetRepresentation *representation = [((pagesViewController *) pageCollection[page])->videoArray[editVideoCounter++] defaultRepresentation];
                CGImageRef originalImage = [representation fullScreenImage];
                UIImage *original = [UIImage imageWithCGImage:originalImage];
                cell.imageView.image = original;
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
                
            }
            else
            {
                if(enterEditAlbum)
                {
                    ALAssetRepresentation *representation = [pages->videoArray[editVideoCounter++] defaultRepresentation];
                    CGImageRef originalImage = [representation fullScreenImage];
                    UIImage *original = [UIImage imageWithCGImage:originalImage];
                    cell.imageView.image = original;
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                }
                else
                {
                    ALAssetRepresentation *representation = [extraVideoItem[extraIMageCounter++] defaultRepresentation];
                    CGImageRef originalImage = [representation fullScreenImage];
                    UIImage *original = [UIImage imageWithCGImage:originalImage];
                    cell.imageView.image = original;
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                }

            }
        }
    }
    if(genTableView.tag == 6)
    {
        if(additem)
        {
            if((one)&&(accordianOpen))
            {
                cell.textLabel.text = [pages->webLink objectAtIndex:extraWebCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((two)&&(accordianOpen))
            {
                cell.textLabel.text = [pages->webLink objectAtIndex:extraWebCounter++];
                 cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((three)&&(accordianOpen))
            {
                cell.textLabel.text = [pages->webLink objectAtIndex:extraWebCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((four)&&(accordianOpen))
            {
                cell.textLabel.text = [pages->webLink objectAtIndex:extraWebCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            if((nine)&&(accordianOpen))
            {
                cell.textLabel.text = [pages->webLink objectAtIndex:extraWebCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
        }
        else
        {
            if(builderNav)
            {
                cell.textLabel.text = [((pagesViewController *) pageCollection[page])->webLink objectAtIndex:editWebCounter++];
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                UIImageView *deleteImageView = [[UIImageView alloc]init];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                    }
                }
                else
                {
                    deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                }
                UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                [deleteImageView setImage:deleteImage];
                [cell addSubview:deleteImageView];
            }
            else
            {
                if(enterEditAlbum)
                {
                    cell.textLabel.text = [pages->webLink objectAtIndex:editWebCounter++];
                    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                }
                else
                {
                    cell.textLabel.text = [extraWebItem objectAtIndex:extraWebCounter++];
                    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
                    UIImageView *deleteImageView = [[UIImageView alloc]init];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                        else
                        {
                            deleteImageView.frame = CGRectMake(90, 15, 15, 15 );
                        }
                    }
                    else
                    {
                        deleteImageView.frame = CGRectMake(240, 10, 20, 20 );
                    }
                    UIImage *deleteImage = [UIImage imageNamed:@"deleteRecyle.png"];
                    [deleteImageView setImage:deleteImage];
                    [cell addSubview:deleteImageView];
                }
                
            }
        }
        
    }

    return cell;
}
-(void)tableView:(UITableView *)genTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(genTableView.tag ==2)
    {
        if(indexPath.row == 0)
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setUserInteractionEnabled:NO];
        }
        else
        {
            
            themeString = [themeList objectAtIndex:indexPath.row];
            [tableView removeFromSuperview];
            tableView = nil;
            if(enterEditAlbum)
            {
                saveAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Yes", nil];
                
                saveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                editalbumName = [NSString stringWithString:((Album *) xmlParser->albumname[0])->AlbumName];
                [[saveAlert textFieldAtIndex:0] setText:[NSString stringWithString:((Album *) xmlParser->albumname[0])->AlbumName]];
                [saveAlert show];
            }
            else
            {
                saveAlert = [[UIAlertView alloc] initWithTitle:nil
                                                       message:@"Enter Album Name"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Yes", nil];
                saveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [saveAlert show];
            }

        
        }
    }
    else
    {
        [self tableView:genTableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }
    
}
- (void)tableView:(UITableView *)genTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(genTableView.tag == 3)
        {
            
            if(additem)
            {
                if((one)&&(accordianOpen))
                {
                    [pages->extraImage removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((two)&&(accordianOpen))
                {
                    [pages->extraImage removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((three)&&(accordianOpen))
                {
                    [pages->extraImage removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((four)&&(accordianOpen))
                {
                    [pages->extraImage removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((nine)&&(accordianOpen))
                {
                    [pages->extraImage removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
            }
            else
            {
                if(builderNav)
                {
                    [((pagesViewController *) pageCollection[page])->extraImage removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                else
                {
                    if(enterEditAlbum)
                    {
                  
                        [pages->extraImage removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                        ((pagesViewController *) pageCollection[pp])->extraImage = pages->extraImage;
                    
                    }
                    else
                    {
                        [extraitem removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                    }
                }
              
            }
            
        }
        if(genTableView.tag == 4)
        {
            
            if(additem)
            {
                if((one)&&(accordianOpen))
                {
                    [pages->musicArray removeObjectAtIndex:indexPath.row];
                    [pages->finalMusicTitle removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((two)&&(accordianOpen))
                {
                    [pages->musicArray removeObjectAtIndex:indexPath.row];
                    [pages->finalMusicTitle removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((three)&&(accordianOpen))
                {
                    [pages->musicArray removeObjectAtIndex:indexPath.row];
                    [pages->finalMusicTitle removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((four)&&(accordianOpen))
                {
                    [pages->musicArray removeObjectAtIndex:indexPath.row];
                    [pages->finalMusicTitle removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((nine)&&(accordianOpen))
                {
                    [pages->musicArray removeObjectAtIndex:indexPath.row];
                    [pages->finalMusicTitle removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
            }
            else
            {
                if(builderNav)
                {
                    [((pagesViewController *) pageCollection[page])->musicArray removeObjectAtIndex:indexPath.row];
                    [((pagesViewController *) pageCollection[page])->finalMusicTitle removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                else
                {
                    if(enterEditAlbum)
                    {
                        [pages->musicArray removeObjectAtIndex:indexPath.row];
                        [pages->finalMusicTitle removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                        ((pagesViewController *) pageCollection[pp])->musicArray = pages->musicArray;
                        ((pagesViewController *) pageCollection[pp])->finalMusicTitle = pages->finalMusicTitle;
                    }
                    else
                    {
                        [extraAudioItem removeObjectAtIndex:indexPath.row];
                        [extraAudioTitle removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                    }
                }
            }
            
        }
        if(genTableView.tag == 5)
        {
            
            if(additem)
            {
                if((one)&&(accordianOpen))
                {
                    [pages->videoArray removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((two)&&(accordianOpen))
                {
                    [pages->videoArray removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((three)&&(accordianOpen))
                {
                    [pages->videoArray removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((four)&&(accordianOpen))
                {
                    [pages->videoArray removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((nine)&&(accordianOpen))
                {
                    [pages->videoArray removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
            }
            else
            {
                if(builderNav)
                {
                    [((pagesViewController *) pageCollection[page])->videoArray removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                else
                {
                    if(enterEditAlbum)
                    {
                        [pages->videoArray removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                        ((pagesViewController *) pageCollection[pp])->videoArray = pages->videoArray;
                    }
                    else
                    {
                        [extraVideoItem removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                    }

                }
            }
            
        }
        if(genTableView.tag == 6)
        {
            
            if(additem)
            {
                if((one)&&(accordianOpen))
                {
                    [pages->webLink removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((two)&&(accordianOpen))
                {
                    [pages->webLink removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((three)&&(accordianOpen))
                {
                    [pages->webLink removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((four)&&(accordianOpen))
                {
                    [pages->webLink removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                if((nine)&&(accordianOpen))
                {
                    [pages->webLink removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
            }
            else
            {
                if(builderNav)
                {
                    [((pagesViewController *) pageCollection[page])->webLink removeObjectAtIndex:indexPath.row];
                    [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                }
                else
                {
                    if(enterEditAlbum)
                    {
                        [pages->webLink removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                        ((pagesViewController *) pageCollection[pp])->webLink = pages->webLink;
                    }
                    else
                    {
                        [extraWebItem removeObjectAtIndex:indexPath.row];
                        [genTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                    }
                    
                }
            }
            
        }
        
    }


}

//---------------------------------All Button Method Finish Above---------------------------------------//
//------------------------------------------------------------------------------------------------------//

//------------Down onwards is Image Display, Video Display, Audio Display From Photo Library-----------//


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    imageThumbnailArray = [[NSMutableArray alloc]init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 32.0, 240.0, 288.0)];
            myScrollView.delegate = self;
            myScrollView.contentSize = CGSizeMake(240.0, 240.0);
            myScrollView.backgroundColor = [UIColor grayColor];
            activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = myScrollView.center;
            [myScrollView addSubview:activityIndicator];
            [self.view addSubview:myScrollView];
            [activityIndicator startAnimating];
        }
        else
        {
            myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 32.0, 200.0, 288.0)];
            myScrollView.delegate = self;
            myScrollView.contentSize = CGSizeMake(200.0, 200.0);
            myScrollView.backgroundColor = [UIColor grayColor];
            activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = myScrollView.center;
            [myScrollView addSubview:activityIndicator];
            [self.view addSubview:myScrollView];
            [activityIndicator startAnimating];
        }
        
    }
    else
    {
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 44.0, 440.0, 724.0)];
        myScrollView.delegate = self;
        myScrollView.contentSize = CGSizeMake(440.0, 440.0);
        myScrollView.backgroundColor = [UIColor grayColor];
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = myScrollView.center;
        [myScrollView addSubview:activityIndicator];
        [self.view addSubview:myScrollView];
        [activityIndicator startAnimating];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!assetsLibrary)
    {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (!groups)
    {
        groups = [[NSMutableArray alloc] init];
    }
    else
    {
        [groups removeAllObjects];
    }
   
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            [self displayImages];
        }
    };

    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code])
        {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                        errorMessage = @"Reason unknown.";
                break;
        }
    };
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:failureBlock];
    
}

//---------------------------- FOR DISPLAY IMAGE-----------------------//
-(void)displayImages
{
    assets = [[NSMutableArray alloc] init];
    scaleSize = 0.2f;
    for (int i = 0 ; i< [groups count]; i++)
    {
        
        assetsGroup = [groups objectAtIndex:i];
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result)
            {
                [assets addObject:result];

            }
        };
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [assetsGroup setAssetsFilter:onlyPhotosFilter];
        [assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
        
    }
    //Seprate the thumbnail and original images
    for(int i=0;i<[assets count]; i++)
    {
        asset = [assets objectAtIndex:i];
        CGImageRef iref = [asset aspectRatioThumbnail];
        UIImage *temp1 = [UIImage imageWithCGImage:iref];
        [imageThumbnailArray addObject:temp1];
    }
    [self loadScrollView];
}

#pragma mark - LoadImages on UIScrollView
-(void)loadScrollView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            float horizontal = 7.0;
            float vertical = 7.0;
            for(int i=0; i<[imageThumbnailArray count]; i++)
            {
                if((i%3) == 0 && i!=0)
                {
                    horizontal = 7.0;
                    vertical = vertical + 70.0 + 7.0;
                }
                buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonImage.frame = CGRectMake(horizontal, vertical,70.0, 70.0);
                [buttonImage setTag:i];
                [buttonImage addTarget:self action:@selector(buttonImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                buttonImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [buttonImage setImage:[imageThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
                [myScrollView addSubview:buttonImage];
                horizontal = horizontal + 70.0 + 7.0;
            }
            [myScrollView setContentSize:CGSizeMake(240.0, vertical + 77.0)];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            imageThumbnailArray = NULL;
        }
        else
        {
            float horizontal = 5.0;
            float vertical = 5.0;
            for(int i=0; i<[imageThumbnailArray count]; i++)
            {
                if((i%3) == 0 && i!=0)
                {
                    horizontal = 5.0;
                    vertical = vertical + 60.0 + 5.0;
                }
                buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonImage.frame = CGRectMake(horizontal, vertical,60.0, 60.0);
                [buttonImage setTag:i];
                [buttonImage addTarget:self action:@selector(buttonImagePressed:) forControlEvents:UIControlEventTouchUpInside];
                buttonImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [buttonImage setImage:[imageThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
                [myScrollView addSubview:buttonImage];
                horizontal = horizontal + 60.0 + 5.0;
            }
            [myScrollView setContentSize:CGSizeMake(200.0, vertical + 65.0)];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            imageThumbnailArray = NULL;
        }
        
    }
    else
    {
        float horizontal = 13.0;
        float vertical = 13.0;
       
        for(int i=0; i<[imageThumbnailArray count]; i++)
        {
            if((i%3) == 0 && i!=0)
            {
                horizontal = 13.0;
                vertical = vertical + 130.0 + 13.0;
            }
            buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonImage setFrame:CGRectMake(horizontal, vertical, 130.0, 130.0)];
            [buttonImage setTag:i];
            [buttonImage setImage:[imageThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
            buttonImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [buttonImage addTarget:self action:@selector(buttonImagePressed:) forControlEvents:UIControlEventTouchUpInside];
            [myScrollView addSubview:buttonImage];
            horizontal = horizontal + 130.0 + 13.0;
               
        }
        [myScrollView setContentSize:CGSizeMake(440.0, vertical + 143.0)];
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        imageThumbnailArray = NULL;
    }
}

//--------------------------FOR  DISPLAY MUSIC--------------------------------//
-(IBAction)Audio:(id)sender
{
    [myScrollView removeFromSuperview];
    musicArray = [[NSMutableArray alloc] init];
    musictitle = [[NSMutableArray alloc] init];
    videoButtonIsActive = FALSE;
    [self loadAudios];
    if (!audioButtonIsActive)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                audioButton.title = @"Image";
                videoButton.title = @"Video";
                self->navigationBar.topItem.title = @"Audio";
                self.audioButtonIsActive = !self.audioButtonIsActive;
                audioScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0, 240.0, 288.0)];
                audioScrollView.delegate = self;
                audioScrollView.contentSize = CGSizeMake(240.0, 240.0);
                audioScrollView.backgroundColor = [UIColor grayColor];
                [leftView addSubview:audioScrollView];
                float horizontal = 7.0;
                float vertical = 7.0;
                
                for(int i=0; i<[musictitle count]; i++)
                {
                    if((i%3) == 0 && i!=0)
                    {
                        horizontal = 7.0;
                        vertical = vertical + 70.0 + 7.0;
                    }
                    buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    [buttonImage setFrame:CGRectMake(horizontal, vertical,70.0, 70.0)];
                    [buttonImage setTag:i];
                    UIImage *vidImageName = [UIImage imageNamed:@"music.png"];
                    UIImageView *vidImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
                    [vidImage setImage:vidImageName] ;
                    [buttonImage addSubview:vidImage];
                    [buttonImage addTarget:self action:@selector(audioPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [buttonImage setTitle:[musictitle objectAtIndex:i] forState:UIButtonTypeCustom];
                    buttonImage.titleLabel.font = [UIFont systemFontOfSize:14];
                    [audioScrollView addSubview:buttonImage];
                    horizontal = horizontal + 70.0 + 7.0;
                }
                [audioScrollView setContentSize:CGSizeMake(240.0, vertical + 77.0)];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            }
            else
            {
                audioButton.title = @"Image";
                videoButton.title = @"Video";
                self->navigationBar.topItem.title = @"Audio";
                self.audioButtonIsActive = !self.audioButtonIsActive;
                audioScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0, 200.0, 288.0)];
                audioScrollView.delegate = self;
                audioScrollView.contentSize = CGSizeMake(200.0, 200.0);
                audioScrollView.backgroundColor = [UIColor grayColor];
                [leftView addSubview:audioScrollView];
                float horizontal = 5.0;
                float vertical = 5.0;
                
                for(int i=0; i<[musictitle count]; i++)
                {
                    if((i%3) == 0 && i!=0)
                    {
                        horizontal = 5.0;
                        vertical = vertical + 60.0 + 5.0;
                    }
                    buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    [buttonImage setFrame:CGRectMake(horizontal, vertical,60.0, 60.0)];
                    [buttonImage setTag:i];
                    UIImage *vidImageName = [UIImage imageNamed:@"music.png"];
                    UIImageView *vidImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
                    [vidImage setImage:vidImageName] ;
                    [buttonImage addSubview:vidImage];
                    [buttonImage addTarget:self action:@selector(audioPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [buttonImage setTitle:[musictitle objectAtIndex:i] forState:UIButtonTypeCustom];
                    buttonImage.titleLabel.font = [UIFont systemFontOfSize:14];
                    [audioScrollView addSubview:buttonImage];
                    horizontal = horizontal + 60.0 + 5.0;
                }
                [audioScrollView setContentSize:CGSizeMake(200.0, vertical + 65.0)];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            }
        }
        else
        {
            audioButton.title = @"Image";
            videoButton.title = @"Video";
            self->navigationBar.topItem.title = @"Audio";
            self.audioButtonIsActive = !self.audioButtonIsActive;
            audioScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0, 440.0, 724.0)];
            audioScrollView.delegate = self;
            audioScrollView.contentSize = CGSizeMake(440.0, 440.0);
            audioScrollView.backgroundColor = [UIColor grayColor];
            [leftView addSubview:audioScrollView];
            float horizontal = 13.0;
            float vertical = 13.0;
            
            for(int i=0; i<[musictitle count]; i++)
            {
                if((i%3) == 0 && i!=0)
                {
                    horizontal = 13.0;
                    vertical = vertical + 130.0 + 13.0;
                }
                buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                [buttonImage setFrame:CGRectMake(horizontal, vertical,130.0, 130.0)];
                [buttonImage setTag:i];
                UIImage *vidImageName = [UIImage imageNamed:@"music.png"];
                UIImageView *vidImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 130, 130)];
                [vidImage setImage:vidImageName] ;
                [buttonImage addSubview:vidImage];
                [buttonImage addTarget:self action:@selector(audioPressed:) forControlEvents:UIControlEventTouchUpInside];
                [buttonImage setTitle:[musictitle objectAtIndex:i] forState:UIButtonTypeCustom];
                buttonImage.titleLabel.font = [UIFont systemFontOfSize:14];
                [audioScrollView addSubview:buttonImage];
                horizontal = horizontal + 130.0 + 13.0;
            }
            [audioScrollView setContentSize:CGSizeMake(440.0, vertical + 143.0)];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }
    }
    else
    {
        audioButton.title = @"Audio";
        self->navigationBar.topItem.title = @"Image";
        self.audioButtonIsActive = !self.audioButtonIsActive;
        [audioScrollView removeFromSuperview];
        [self viewWillAppear:TRUE];
        [self viewDidAppear:TRUE];
        musicArray = NULL;
        musictitle = NULL;
    }
}
- (void)loadAudios
{
	// Do any additional setup after loading the view, typically from a nib.
    query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:[MPMediaPropertyPredicate
                               predicateWithValue:[NSNumber numberWithInteger:(MPMediaTypeMusic)]
                               forProperty:MPMediaItemPropertyMediaType]];
    for (MPMediaItem* item in [query items])
    {
        NSString *songTitle = [item valueForProperty:MPMediaItemPropertyTitle];
        NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
        [musictitle addObject:songTitle];
        [musicArray addObject:url];
    }
    
}

//----------------------FOR DISPLAY VIDEOS--------------------------//
-(IBAction)Video:(id)sender
{
    [myScrollView removeFromSuperview];
    videoThumbnailArray = [[NSMutableArray alloc]init];
    audioButtonIsActive = FALSE;
    [self displayVideos];
    if (!videoButtonIsActive)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                videoButton.title = @"Image";
                audioButton.title = @"Audio";
                self->navigationBar.topItem.title = @"Video";
                self.videoButtonIsActive = !self.videoButtonIsActive;
                videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0, 240.0, 288.0)];
                videoScrollView.delegate = self;
                videoScrollView.contentSize = CGSizeMake(240.0, 240.0);
                videoScrollView.backgroundColor = [UIColor grayColor];
                [leftView addSubview:videoScrollView];
                float horizontal = 7.0;
                float vertical = 7.0;
                
                for(int i=0; i<[videoThumbnailArray count]; i++)
                {
                    if((i%3) == 0 && i!=0)
                    {
                        horizontal = 7.0;
                        vertical = vertical + 70.0 + 7.0;
                    }
                    
                    buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    [buttonImage setFrame:CGRectMake(horizontal, vertical,70.0, 70.0)];
                    [buttonImage setTag:i];
                    [buttonImage setImage:[videoThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
                    UIImage *vidImageName = [UIImage imageNamed:@"videoIcon.png"];
                    UIImageView *vidImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
                    [vidImage setImage:vidImageName] ;
                    [buttonImage addSubview:vidImage];
                    [buttonImage addTarget:self action:@selector(videoPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [videoScrollView addSubview:buttonImage];
                    horizontal = horizontal + 70.0 + 7.0;
                }
                
                [videoScrollView setContentSize:CGSizeMake(240.0, vertical + 77.0)];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                videoThumbnailArray = NULL;
            }
            else
            {
                videoButton.title = @"Image";
                audioButton.title = @"Audio";
                self->navigationBar.topItem.title = @"Video";
                self.videoButtonIsActive = !self.videoButtonIsActive;
                videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0, 200.0, 288.0)];
                videoScrollView.delegate = self;
                videoScrollView.contentSize = CGSizeMake(200.0, 200.0);
                videoScrollView.backgroundColor = [UIColor grayColor];
                [leftView addSubview:videoScrollView];
                float horizontal = 5.0;
                float vertical = 5.0;
                
                for(int i=0; i<[videoThumbnailArray count]; i++)
                {
                    if((i%3) == 0 && i!=0)
                    {
                        horizontal = 5.0;
                        vertical = vertical + 60.0 + 5.0;
                    }
                    
                    buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    [buttonImage setFrame:CGRectMake(horizontal, vertical,60.0, 60.0)];
                    [buttonImage setTag:i];
                    [buttonImage setImage:[videoThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
                    UIImage *vidImageName = [UIImage imageNamed:@"videoIcon.png"];
                    UIImageView *vidImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
                    [vidImage setImage:vidImageName] ;
                    [buttonImage addSubview:vidImage];
                    [buttonImage addTarget:self action:@selector(videoPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [videoScrollView addSubview:buttonImage];
                    horizontal = horizontal + 60.0 + 5.0;
                }
                
                [videoScrollView setContentSize:CGSizeMake(200.0, vertical + 65.0)];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                videoThumbnailArray = NULL;
            }
        }
        else
        {
            videoButton.title = @"Image";
            audioButton.title = @"Audio";
            self->navigationBar.topItem.title = @"Video";
            self.videoButtonIsActive = !self.videoButtonIsActive;
            videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0, 440.0, 724.0)];
            videoScrollView.delegate = self;
            videoScrollView.contentSize = CGSizeMake(440.0, 440.0);
            videoScrollView.backgroundColor = [UIColor grayColor];
            [leftView addSubview:videoScrollView];
            float horizontal = 13.0;
            float vertical = 13.0;
            
            for(int i=0; i<[videoThumbnailArray count]; i++)
            {
                if((i%3) == 0 && i!=0)
                {
                    horizontal =13.0;
                    vertical = vertical + 130.0 + 13.0;
                }
                
                buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
                [buttonImage setFrame:CGRectMake(horizontal, vertical,130.0, 130.0)];
                [buttonImage setTag:i];
                [buttonImage setImage:[videoThumbnailArray objectAtIndex:i] forState:UIControlStateNormal];
                UIImage *vidImageName = [UIImage imageNamed:@"videoIcon.png"];
                UIImageView *vidImage = [[UIImageView alloc]initWithFrame:CGRectMake(45, 45, 40, 40)];
                [vidImage setImage:vidImageName] ;
                [buttonImage addSubview:vidImage];
                [buttonImage addTarget:self action:@selector(videoPressed:) forControlEvents:UIControlEventTouchUpInside];
                [videoScrollView addSubview:buttonImage];
                horizontal = horizontal + 130.0 + 13.0;
            }
            
            [videoScrollView setContentSize:CGSizeMake(440.0, vertical + 143.0)];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            videoThumbnailArray = NULL;
        }
        
    }
    else
    {
        videoButton.title = @"Video";
        self->navigationBar.topItem.title = @"Image";
        videoThumbnailArray = NULL;
        self.videoButtonIsActive = !self.videoButtonIsActive;
        [videoScrollView removeFromSuperview];
        [self viewWillAppear:TRUE];
        [self viewDidAppear:TRUE];
    }
}

-(void)displayVideos
{
    assets = [[NSMutableArray alloc] init];
    scaleSize = 0.2f;
    for (int i = 0 ; i< [groups count]; i++)
    {
        assetsGroup = [groups objectAtIndex:i];
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result)
            {
                [assets addObject:result];
            }
        };
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allVideos];
        [assetsGroup setAssetsFilter:onlyPhotosFilter];
        [assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    }
    
    //Seprate  videos
    for(int i=0;i<[assets count]; i++)
    {
        asset = [assets objectAtIndex:i];
        //for video thumbnails
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        [videoThumbnailArray addObject:thumbnail];
        
    }
    //[self videoLibrary];
}
//For Getting Result Remember
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

//----------------------ALL METHOD FOR SELECTING IMAGE, VIDEOS & MUSIC BELOW----------------------//
#pragma mark - Button Pressed method

//------------------------------------------FOR SELECTING IMAGE----------------------------------//
-(void)buttonImagePressed:(id)sender
{
    pageDiscard = TRUE;
    p = [sender tag];
    Path = assets[p];
    if(!isalbumFinished)
        isalbumFinished = TRUE;
    ALAssetRepresentation *representation = [assets[p] defaultRepresentation];
    CGImageRef originalImage = [representation fullScreenImage];
    UIImage *original = [UIImage imageWithCGImage:originalImage];
    oneImageCounter =1;
    twoImageCounter = 2;
    threeImageCounter = 3;
    fourImageCounter = 4;
    nineImageCounter = 9;
    editClicked = TRUE;
    // COMING FROM  EDIT ALBUM
    if(enterEditAlbum)
    {
        imageChange = TRUE;
       if(accordianOpen)
        {
            if(isalbumFinished)
            {
                editImageCounter = 0;
                [pages->extraImage addObject:Path];
                [view1 reloadData];
            }
            else
            {
                editImageCounter = 0;
                editArray1 = [[NSMutableArray alloc]init];
                [pages->extraImage addObject:Path];
                
                int layOut = ((pagesViewController*)pageCollection[pp])->layoutused;
                for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
                {
                    editArray1[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
                }
                
                for(int i=0;i<[editArray1 count];i++)
                {
                    pages->imageURL[i] = editArray1[i];
                }
                pages->layoutused = layOut;
                
                //FOR EXTRA VIDEO
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
                {
                    editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
                }
                for(int i=0;i<[editArray1 count];i++)
                {
                    pages->videoArray[i] = editArray1[i];
                }
                //FOR EXTRA AUDIO
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                {
                    editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                }
                for(int i=0;i<[editArray1 count];i++)
                {
                    pages->musicArray[i] = editArray1[i];
                }
                //FOR EXTRA AUDIO TITLE
                editArray1 = [[NSMutableArray alloc]init];
                for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                {
                    editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                }
                for(int i=0;i<[editArray1 count];i++)
                {
                    pages->finalMusicTitle[i] = editArray1[i];
                }
                [pageCollection removeObjectAtIndex:pp];
                [pageCollection insertObject:pages atIndex:pp];
                [view1 reloadData];
            }
            
        }
        else
        {
            if(isalbumFinished && editImage)
            {
                editArray1 = [[NSMutableArray alloc]init];
                if ((one)&&(oneImageCounter ==1)&&(layOutClicked == 1))
                {
                    one->firstImageView.image = original;
                    finalcounter1 = [Path description];
                    finalcounter1 = [finalcounter1 substringFromIndex:27];
                    if(remove)
                    {
                        [pages->imageURL removeObjectAtIndex:0];
                        [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    }
                    else
                    {
                        [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    }
                    
                    pageFill = TRUE;
                    pages->layoutused = 1;
                    if(remove)
                    {
                        [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                        [pageCollection insertObject:pages atIndex:[pageCollection count]];
                    }
                    else
                    {
                        [pageCollection insertObject:pages atIndex:[pageCollection count]];
                        remove = TRUE;
                    }
                    
                }
                
                if((two)&&(twoImageCounter == 2)&&(layOutClicked == 2))
                {
                    
                    switch (counter3)
                    {
                        case 0:
                        {
                            
                            two->twofirstImageView.image = original;
                            counter3++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:0];
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                        }
                            break;
                        case 1:
                        {
                            
                            two->twosecondImageView.image = original;
                            counter3 = 0;
                            secondimageArray = TRUE;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:1];
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            
                        }
                            
                            break;
                        default:
                            break;
                    }
                    
                    if(secondimageArray)
                    {
                        pageFill = TRUE;
                        pages->layoutused = 2;
                        if(remove)
                        {
                            [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                            [pageCollection insertObject:pages atIndex:[pageCollection count]];
                        }
                        else
                        {
                            [pageCollection insertObject:pages atIndex:[pageCollection count]];
                            remove = TRUE;
                        }

                    }
                    
                }
                
                if((three)&&(threeImageCounter==3)&&(layOutClicked == 3))
                {
                    
                    switch (counter)
                    {
                        case 0:
                            
                            three->threefirstImageView.image = original;
                            counter++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:0];
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            break;
                        case 1:
                            three->threesecondImageView.image = original;
                            counter++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:1];
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            break;
                        case 2:
                            three->threethirdImageView.image = original;
                            counter =0;
                            thirdimageArray = TRUE;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:2];
                                [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            }
                            break;
                        default:
                            break;
                    }
                    if(thirdimageArray)
                    {
                         pageFill = TRUE;
                        pages->layoutused = 3;
                        if(remove)
                         {
                             [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                             [pageCollection insertObject:pages atIndex:[pageCollection count]];
                         }
                         else
                         {
                             [pageCollection insertObject:pages atIndex:[pageCollection count]];
                             remove = TRUE;
                         }
                    }
                }
                
                if((four)&&(fourImageCounter == 4)&&(layOutClicked == 4))
                {
                    
                    switch (counter1)
                    {
                        case 0:
                            four->fourfirstImageView.image = original;
                            counter1++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:0];
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            break;
                        case 1:
                            four->foursecondImageView.image = original;
                            counter1++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:1];
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            break;
                        case 2:
                            four->fourthirdImageView.image = original;
                            counter1++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:2];
                                [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            }
                            break;
                        case 3:
                            four->fourfourImageView.image = original;
                            counter1 = 0;
                            fourimageArray = TRUE;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:3];
                                [pages->imageURL insertObject:finalcounter1 atIndex:3];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:3];
                            }
                            break;
                        default:
                            break;
                    }
                    
                    if(fourimageArray)
                    {
                        pageFill = TRUE;
                        pages->layoutused = 4;
                        if(remove)
                        {
                            [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                            [pageCollection insertObject:pages atIndex:[pageCollection count]];
                        }
                        else
                        {
                            [pageCollection insertObject:pages atIndex:[pageCollection count]];
                            remove = TRUE;
                        }
                    }
                }
                
                if((nine)&&(nineImageCounter == 9)&&(layOutClicked == 9))
                {
                    
                    switch (counter2)
                    {
                            
                        case 0:
                            nine->ninefirstImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:0];
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            }
                            break;
                        case 1:
                            nine->ninesecondImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:1];
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            }
                            break;
                        case 2:
                            nine->ninethirdImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:2];
                                [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            }
                            break;
                        case 3:
                            nine->ninefourImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:3];
                                [pages->imageURL insertObject:finalcounter1 atIndex:3];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:3];
                            }
                            break;
                        case 4:
                            nine->ninefiveImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:4];
                                [pages->imageURL insertObject:finalcounter1 atIndex:4];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:4];
                            }
                            break;
                        case 5:
                            nine->ninesixImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:5];
                                [pages->imageURL insertObject:finalcounter1 atIndex:5];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:5];
                            }
                            break;
                        case 6:
                            nine->ninesevenImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:6];
                                [pages->imageURL insertObject:finalcounter1 atIndex:6];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:6];
                            }
                            break;
                        case 7:
                            nine->nineeightImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:7];
                                [pages->imageURL insertObject:finalcounter1 atIndex:7];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:7];
                            }
                            break;
                        case 8:
                            nine->ninenineImageView.image = original;
                            counter2 = 0;
                            nineimageArray = TRUE;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            if(remove)
                            {
                                [pages->imageURL removeObjectAtIndex:8];
                                [pages->imageURL insertObject:finalcounter1 atIndex:8];
                            }
                            else
                            {
                                [pages->imageURL insertObject:finalcounter1 atIndex:8];
                            }
                            break;
                            
                        default:
                            break;
                    }
                    if(nineimageArray)
                    {
                        pageFill = TRUE;
                        pages->layoutused = 9;
                        if(remove)
                        {
                            [pageCollection removeObjectAtIndex:[pageCollection count]-1];
                            [pageCollection insertObject:pages atIndex:[pageCollection count]];
                        }
                        else
                        {
                            [pageCollection insertObject:pages atIndex:[pageCollection count]];
                            remove = TRUE;
                        }
                    }
                }

            }
            //replace Edit Image
            else
            {
                editArray1 = [[NSMutableArray alloc]init];
                if ((one)&&(oneImageCounter ==1)&&(layOutClicked == 1))
                {
                    one->firstImageView.image = original;
                    finalcounter1 = [Path description];
                    finalcounter1 = [finalcounter1 substringFromIndex:27];
                    [pages->imageURL removeAllObjects];
                    [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    
                    //For EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //for EXTRA VIDEO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i] ;
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->videoArray[i] = editArray1[i];
                    }
                    
                    //for EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    pageFill = TRUE;
                    oneFilled =1;
                    
                    pages->layoutused = 1;
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    oneNextClicked = 1;
                    
                }
                
                if((two)&&(twoImageCounter == 2)&&(layOutClicked == 2))
                {
                    
                    switch (counter3)
                    {
                        case 0:
                        {
                            
                            two->twofirstImageView.image = original;
                            counter3++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
                            {
                                pages->imageURL[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
                            }
                            [pages->imageURL removeObjectAtIndex:0];
                            [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            
                        }
                            break;
                        case 1:
                        {
                            
                            two->twosecondImageView.image = original;
                            counter3 = 0;
                            secondimageArray = TRUE;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:1];
                            [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            
                        }
                            
                            break;
                        default:
                            break;
                    }
                    
                    pages->layoutused = 2;
                    
                    //FOR EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //for EXTRA VIDEO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->videoArray[i] = editArray1[i];
                    }
                    
                    //for EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    pageFill = TRUE;
                    twoFilled=2;
                    twoNextClicked = 2;
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    
                }
                
                if((three)&&(threeImageCounter==3)&&(layOutClicked == 3))
                {
                    
                    switch (counter)
                    {
                        case 0:
                            
                            three->threefirstImageView.image = original;
                            counter++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
                            {
                                pages->imageURL[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
                            }
                            [pages->imageURL removeObjectAtIndex:0];
                            [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            
                            break;
                        case 1:
                            three->threesecondImageView.image = original;
                            counter++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:1];
                            [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            break;
                        case 2:
                            three->threethirdImageView.image = original;
                            counter =0;
                            thirdimageArray = TRUE;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:2];
                            [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            break;
                        default:
                            break;
                    }
                    pages->layoutused = 3;
                    
                    //FOR EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //FOR EXTRA VIDEO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->videoArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    pageFill = TRUE;
                    threeFilled=3;
                    threeNextClicked = 3;
                }
                
                if((four)&&(fourImageCounter == 4)&&(layOutClicked == 4))
                {
                    
                    switch (counter1)
                    {
                        case 0:
                            four->fourfirstImageView.image = original;
                            counter1++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
                            {
                                pages->imageURL[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
                            }
                            [pages->imageURL removeObjectAtIndex:0];
                            [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            break;
                        case 1:
                            four->foursecondImageView.image = original;
                            counter1++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:1];
                            [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            break;
                        case 2:
                            four->fourthirdImageView.image = original;
                            counter1++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:2];
                            [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            break;
                        case 3:
                            four->fourfourImageView.image = original;
                            counter1 = 0;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:3];
                            [pages->imageURL insertObject:finalcounter1 atIndex:3];
                            break;
                        default:
                            break;
                    }
                    
                    pages->layoutused = 4;
                    
                    //FOR EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //FOR EXTRA VIDEO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->videoArray[i] = editArray1[i];
                    }
                    
                    //for EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    pageFill = TRUE;
                    fourFilled=4;
                    fourNextClicked = 4;
                }
                
                if((nine)&&(nineImageCounter == 9)&&(layOutClicked == 9))
                {
                    
                    switch (counter2)
                    {
                            
                        case 0:
                            nine->ninefirstImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
                            {
                                pages->imageURL[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
                            }
                            [pages->imageURL removeObjectAtIndex:0];
                            [pages->imageURL insertObject:finalcounter1 atIndex:0];
                            break;
                        case 1:
                            nine->ninesecondImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:1];
                            [pages->imageURL insertObject:finalcounter1 atIndex:1];
                            break;
                        case 2:
                            nine->ninethirdImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:2];
                            [pages->imageURL insertObject:finalcounter1 atIndex:2];
                            break;
                        case 3:
                            nine->ninefourImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:3];
                            [pages->imageURL insertObject:finalcounter1 atIndex:3];
                            break;
                        case 4:
                            nine->ninefiveImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:4];
                            [pages->imageURL insertObject:finalcounter1 atIndex:4];
                            break;
                        case 5:
                            nine->ninesixImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:5];
                            [pages->imageURL insertObject:finalcounter1 atIndex:5];
                            break;
                        case 6:
                            nine->ninesevenImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:6];
                            [pages->imageURL insertObject:finalcounter1 atIndex:6];
                            break;
                        case 7:
                            nine->nineeightImageView.image = original;
                            counter2++;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:7];
                            [pages->imageURL insertObject:finalcounter1 atIndex:7];
                            break;
                        case 8:
                            nine->ninenineImageView.image = original;
                            counter2 = 0;
                            finalcounter1 = [Path description];
                            finalcounter1 = [finalcounter1 substringFromIndex:27];
                            [pages->imageURL removeObjectAtIndex:8];
                            [pages->imageURL insertObject:finalcounter1 atIndex:8];
                            break;
                            
                        default:
                            break;
                    }
                    
                    pages->layoutused = 9;
                    
                    //FOR EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //FOR EXTRA VIDEO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->videoArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //for EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    pageFill = TRUE;
                    nineFilled=9;               
                    nineNextClicked = 9;

            }
        }
        }
        editClicked = FALSE;
    }
    //---------------------------directly from Builder creating Album-----------------------------//
    else
    {
        if(!accordianOpen)
        {
            if ((one)&&(oneImageCounter ==1)&&(layOutClicked == 1))
            {
                
                one->firstImageView.image = original;
                pages->layoutused = 1;
                [pages->imageURL insertObject:Path atIndex:0];
                additem = TRUE;
                pages->extraImage = [[NSMutableArray alloc]init];
                pageFill = TRUE;
                oneFilled =1;
                layOutIsFilled = TRUE;
                //for Extra Image
                if( oneImageCounter == 1 && finished)
                {
                    
                    for(int i=0;i<[extraitem count];i++)
                    {
                        [pages->extraImage addObject:extraitem[i]];
                    }
                    
                    pages->videoArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraVideoItem count];i++)
                    {
                        [pages->videoArray addObject:extraVideoItem[i]];
                    }
                    
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                        [pages->finalMusicTitle addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }
                    pages->webLink = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraWebItem count];i++)
                    {
                        [pages->webLink addObject:extraWebItem[i]];
                    }
                }
                if(builderNav)
                {
                    [pageCollection removeObjectAtIndex:page];
                    [pageCollection insertObject:pages atIndex:page];
                    oneFilled = 0;
                }
                oneNextClicked = 1;
                if(replaceImage)
                {
                   [pageCollection removeObjectAtIndex:pagescounter];
                }
                if((one)&&(oneImageCounter==1)&&(oneFilled==1)&&(oneNextClicked==1))
                {
                    [pageCollection insertObject:pages atIndex:pagescounter];
                    replaceImage = TRUE;
                }
  
            }
            
            if((two)&&(twoImageCounter == 2)&&(layOutClicked == 2))
            {
                
                switch (counter3)
                {
                    case 0:
                    {
                        two->twofirstImageView.image = original;
                        counter3++;
                        finalcounter1 = [Path description];
                    }
                        break;
                    case 1:
                    {
                        two->twosecondImageView.image = original;
                        counter3 = 0;
                        secondimageArray = TRUE;
                        finalcounter2 = [Path description];
                        layOutIsFilled = TRUE;
                    }
                        
                        break;
                    default:
                        break;
                }
                pages->layoutused = 2;
                
                [pages->imageURL addObject:Path];
                pageFill = TRUE;
                twoFilled=2;
                additem = TRUE;
                pages->extraImage = [[NSMutableArray alloc]init];
                //for Extra Image
                if( twoImageCounter == 2 && finished)
                {
                    
                    for(int i=0;i<[extraitem count];i++)
                    {
                        [pages->extraImage addObject:extraitem[i]];
                    }
                    pages->videoArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraVideoItem count];i++)
                    {
                        [pages->videoArray addObject:extraVideoItem[i]];
                    }
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }
                    pages->webLink = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraWebItem count];i++)
                    {
                        [pages->webLink addObject:extraWebItem[i]];
                    }
                }
                 twoNextClicked = 2;
                if(secondimageArray)
                {
                    [pages->imageURL removeAllObjects];
                    [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    [pages->imageURL insertObject:finalcounter2 atIndex:1];
                    if(builderNav)
                    {
                        [pageCollection removeObjectAtIndex:page];
                        [pageCollection insertObject:pages atIndex:page];
                        twoFilled = 0;
                    }
                    if(replaceImage)
                    {
                        [pageCollection removeObjectAtIndex:pagescounter];
                    }
                    if((two)&&(twoImageCounter==2)&&(twoFilled==2)&&(twoNextClicked==2))
                    {
                        [pageCollection insertObject:pages atIndex:pagescounter];
                        replaceImage = TRUE;
                    }
                }
               
            }
            
            if((three)&&(threeImageCounter==3)&&(layOutClicked == 3))
            {
                
                switch (counter)
                {
                    case 0:
                        
                        three->threefirstImageView.image = original;
                        counter++;
                        finalcounter1 = [Path description];
                        break;
                    case 1:
                        three->threesecondImageView.image = original;
                        counter++;
                        finalcounter2 = [Path description];
                        break;
                    case 2:
                        three->threethirdImageView.image = original;
                        counter =0;
                        thirdimageArray = TRUE;
                        layOutIsFilled = TRUE;
                        finalcounter3 = [Path description];
                        break;
                    default:
                        break;
                }
                pages->layoutused = 3;
                [pages->imageURL addObject:Path];
                pageFill = TRUE;
                threeFilled=3;
                additem = TRUE;
                pages->extraImage = [[NSMutableArray alloc]init];
                
                //for Extra Image
                if( (threeImageCounter == 3) && (finished))
                {
                    for(int i=0;i<[extraitem count];i++)
                    {
                        [pages->extraImage addObject:extraitem[i]];
                    }
                    pages->videoArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraVideoItem count];i++)
                    {
                        [pages->videoArray addObject:extraVideoItem[i]];
                    }
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }
                    pages->webLink = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraWebItem count];i++)
                    {
                        [pages->webLink addObject:extraWebItem[i]];
                    }
                    
                }
                threeNextClicked = 3;
                if(thirdimageArray)
                {
                    [pages->imageURL removeAllObjects];
                    [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    [pages->imageURL insertObject:finalcounter2 atIndex:1];
                    [pages->imageURL insertObject:finalcounter3 atIndex:2];
                    if(builderNav)
                    {
                        [pageCollection removeObjectAtIndex:page];
                        [pageCollection insertObject:pages atIndex:page];
                        threeFilled = 0;
                    }
                    if(replaceImage)
                    {
                        [pageCollection removeObjectAtIndex:pagescounter];
                    }
                    if((three)&&(threeImageCounter==3)&&(threeFilled==3)&&(threeNextClicked==3))
                    {
                        [pageCollection insertObject:pages atIndex:pagescounter];
                        replaceImage = TRUE;
                    }
                    
                }
                
            }
            
            if((four)&&(fourImageCounter == 4)&&(layOutClicked == 4))
            {
                
                switch (counter1)
                {
                    case 0:
                        four->fourfirstImageView.image = original;
                        counter1++;
                        finalcounter1 = [Path description];
                        break;
                    case 1:
                        four->foursecondImageView.image = original;
                        counter1++;
                        finalcounter2 = [Path description];
                        break;
                    case 2:
                        four->fourthirdImageView.image = original;
                        counter1++;
                        finalcounter3 = [Path description];
                        break;
                    case 3:
                        four->fourfourImageView.image = original;
                        counter1 = 0;
                        finalcounter4 = [Path description];
                        layOutIsFilled = TRUE;
                        fourimageArray = TRUE;
                        break;
                    default:
                        break;
                }
                
                pages->layoutused = 4;
                [pages->imageURL addObject:Path];
                pageFill = TRUE;
                fourFilled=4;
                additem = TRUE;
                pages->extraImage = [[NSMutableArray alloc]init];
                //for Extra Image
                if( (fourImageCounter == 4)&& (finished))
                {
                    
                    for(int i=0;i<[extraitem count];i++)
                    {
                        [pages->extraImage addObject:extraitem[i]];
                    }
                    pages->videoArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraVideoItem count];i++)
                    {
                        [pages->videoArray addObject:extraVideoItem[i]];
                    }
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }
                    pages->webLink = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraWebItem count];i++)
                    {
                        [pages->webLink addObject:extraWebItem[i]];
                    }
                    
                }
                 fourNextClicked = 4;
                if(fourimageArray)
                {
                    [pages->imageURL removeAllObjects];
                    [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    [pages->imageURL insertObject:finalcounter2 atIndex:1];
                    [pages->imageURL insertObject:finalcounter3 atIndex:2];
                    [pages->imageURL insertObject:finalcounter4 atIndex:3];
                    if(builderNav)
                    {
                        [pageCollection removeObjectAtIndex:page];
                        [pageCollection insertObject:pages atIndex:page];
                        fourFilled = 0;
                    }
                    if(replaceImage)
                    {
                        [pageCollection removeObjectAtIndex:pagescounter];
                    }
                    if((four)&&(fourImageCounter==4)&&(fourFilled==4)&&(fourNextClicked==4))
                    {
                        [pageCollection insertObject:pages atIndex:pagescounter];
                        replaceImage = TRUE;
                    }
                }

            }
            
            if((nine)&&(nineImageCounter == 9)&&(layOutClicked == 9))
            {
                
                switch (counter2)
                {
                        
                    case 0:
                        nine->ninefirstImageView.image = original;
                        counter2++;
                        finalcounter1 = [Path description];
                        break;
                    case 1:
                        nine->ninesecondImageView.image = original;
                        counter2++;
                        finalcounter2 = [Path description];
                        break;
                    case 2:
                        nine->ninethirdImageView.image = original;
                        counter2++;
                        finalcounter3 = [Path description];
                        break;
                    case 3:
                        nine->ninefourImageView.image = original;
                        counter2++;
                        finalcounter4 = [Path description];
                        break;
                    case 4:
                        nine->ninefiveImageView.image = original;
                        counter2++;
                        finalcounter5 = [Path description];
                        break;
                    case 5:
                        nine->ninesixImageView.image = original;
                        counter2++;
                        finalcounter6 = [Path description];
                        break;
                    case 6:
                        nine->ninesevenImageView.image = original;
                        counter2++;
                        finalcounter7 = [Path description];
                        break;
                    case 7:
                        nine->nineeightImageView.image = original;
                        counter2++;
                        finalcounter8 = [Path description];
                        break;
                    case 8:
                        nine->ninenineImageView.image = original;
                        counter2 = 0;
                        nineimageArray = TRUE;
                        layOutIsFilled = TRUE;
                        finalcounter9 = [Path description];
                        break;
                        
                    default:
                        break;
                }
                
                pages->layoutused = 9;
                [pages->imageURL addObject:Path];
                pageFill = TRUE;
                nineFilled=9;
                additem = TRUE;
                pages->extraImage = [[NSMutableArray alloc]init];
                
                //for Extra Image
                if( (nineImageCounter == 9) && (finished) )
                {
                    
                    for(int i=0;i<[extraitem count];i++)
                    {
                        [pages->extraImage addObject:extraitem[i]];
                    }
                    pages->videoArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraVideoItem count];i++)
                    {
                        [pages->videoArray addObject:extraVideoItem[i]];
                    }
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }
                    pages->webLink = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraWebItem count];i++)
                    {
                        [pages->webLink addObject:extraWebItem[i]];
                    }
                }
                    nineNextClicked = 9;
                if(nineimageArray)
                {
                    [pages->imageURL removeAllObjects];
                    [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    [pages->imageURL insertObject:finalcounter2 atIndex:1];
                    [pages->imageURL insertObject:finalcounter3 atIndex:2];
                    [pages->imageURL insertObject:finalcounter4 atIndex:3];
                    [pages->imageURL insertObject:finalcounter5 atIndex:4];
                    [pages->imageURL insertObject:finalcounter6 atIndex:5];
                    [pages->imageURL insertObject:finalcounter7 atIndex:6];
                    [pages->imageURL insertObject:finalcounter8 atIndex:7];
                    [pages->imageURL insertObject:finalcounter9 atIndex:8];
                    if(builderNav)
                    {
                        [pageCollection removeObjectAtIndex:page];
                        [pageCollection insertObject:pages atIndex:page];
                        nineFilled = 0;
                    }
                    if(replaceImage)
                    {
                        [pageCollection removeObjectAtIndex:pagescounter];
                    }
                    if((nine)&&(nineImageCounter==9)&&(nineFilled==9)&&(nineNextClicked==9))
                    {
                        [pageCollection insertObject:pages atIndex:pagescounter];
                        replaceImage = TRUE;
                    }
                }
            }
        }
        
        
        else
        {
            if(Allow )
            {
                if(additem)
                {
                    if((one)&&(accordianOpen)&&finished)
                    {
                        
                        extraIMageCounter = 0;
                        [pages->extraImage addObject:Path];
                        [view1 reloadData];
                    }
                    
                    if((two)&&(accordianOpen)&&finished)
                    {
                        extraIMageCounter = 0;
                        [pages->extraImage addObject:Path];
                        [view1 reloadData];

                    }
                    
                    if((three)&&(accordianOpen)&&finished)
                    {
                        extraIMageCounter = 0;
                        [pages->extraImage addObject:Path];
                        [view1 reloadData];
 
                    }
                    
                    if((four)&&(accordianOpen)&&finished)
                    {
                        extraIMageCounter = 0;
                        [pages->extraImage addObject:Path];
                        [view1 reloadData];

                    }
                    
                    if((nine)&&(accordianOpen)&&finished)
                    {
                        extraIMageCounter = 0;
                        [pages->extraImage addObject:Path];
                        [view1 reloadData];

                    }
                }
                
                else
                {
                    if(builderNav)
                    {
                        editImageCounter = 0;
                        [((pagesViewController *) pageCollection[page])->extraImage addObject:Path];
                        [view1 reloadData];
                    }
                    else
                    {
                        extraIMageCounter = 0;
                        [extraitem addObject:Path];
                        pages->extraImage = [[NSMutableArray alloc]init];
                        for(int i=0;i<[extraitem count];i++)
                        {
                            [pages->extraImage addObject:extraitem[i]];
                        }
                        [view1 reloadData];
                    }
                   
                }
                
            }
        }
 
    }
    Path = nil;
}
//----------------------------FOR SELECTING VIDEOS----------------------------//
-(void)videoPressed:(id)sender
{
    v = [sender tag];
    videoURL = assets[v];
    ALAssetRepresentation *representation = [assets[v] defaultRepresentation];
    CGImageRef originalImage = [representation fullScreenImage];
    UIImage *original = [UIImage imageWithCGImage:originalImage];
    //----------------------------------Edit Album Case--------------------------------------//
    if(enterEditAlbum)
    {
        imageChange = TRUE;
        if(accordianOpen)
        {
            if(isalbumFinished)
            {
                if(firstPageVideo)
                {
                    autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Warning!!"
                                                                       message:@"You Can't Add ExtraVideo in VideoAlbum Page"
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                             otherButtonTitles:nil];
                    [autoDissmissalertView show];
                }
                else
                {
                    editVideoCounter = 0;
                    [pages->videoArray addObject:videoURL];
                    [view3 reloadData];
                }
            }
            else
            {
                if(firstPageVideo)
                {
                    autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Warning!!"
                                                                       message:@"You Can't Add ExtraVideo in VideoAlbum Page"
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                             otherButtonTitles:nil];
                    [autoDissmissalertView show];
                }
                else
                {
                    editVideoCounter = 0;
                    editArray1 = [[NSMutableArray alloc]init];
                    [pages->videoArray addObject:videoURL];
                    int layOut = ((pagesViewController*)pageCollection[pp])->layoutused;
                    
                    //FOR MAIN IMAGE
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->imageURL[i] = editArray1[i];
                    }
                    
                    //FOR EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //FOR EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //FOR EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    
                    pages->layoutused = layOut;
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    [view3 reloadData];
                }
            }

        }
        //------------------------FOR SELECTING MAINVIDEO ---------------------------//
        else
        {
            if(isalbumFinished)
            {
                editArray1 = [[NSMutableArray alloc]init];
                if (one)
                {
                    one->firstImageView.image = original;
                    finalcounter1 = videoURL;
                    if(remove)
                    {
                        [pages->imageURL removeObjectAtIndex:0];
                        [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    }
                    else
                    {
                        [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    }
                    
                    pageFill = TRUE;
                    pages->layoutused = 12;
                    if(remove)
                    {
                        [pageCollection removeObjectAtIndex:[pageCollection count]];
                        [pageCollection insertObject:pages atIndex:[pageCollection count]];
                    }
                    else
                    {
                        [pageCollection insertObject:pages atIndex:[pageCollection count]];
                        remove = TRUE;
                    }
                }
                else
                {
                    autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Warning!!"
                                                                       message:@"You Can't Add Videos Apart From One Layout in VideoAlbum Page"
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                             otherButtonTitles:nil];
                    [autoDissmissalertView show];
                }
            
            }
            else
            {
                editArray1 = [[NSMutableArray alloc]init];
                if (one)//&&(oneImageCounter ==1)&&(layOutClicked == 1))
                {
                    one->firstImageView.image = original;
                    finalcounter1 = videoURL;
                    [pages->imageURL removeAllObjects];
                    [pages->imageURL insertObject:finalcounter1 atIndex:0];
                    
                    //For EXTRA IMAGE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->extraImage[i] = editArray1[i];
                    }
                    
                    //for EXTRA AUDIO
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->musicArray count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->musicArray[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->musicArray[i] = editArray1[i];
                    }
                    //FOR EXTRA AUDIO TITLE
                    editArray1 = [[NSMutableArray alloc]init];
                    for(int i=0;i<[((pagesViewController*)pageCollection[pp])->finalMusicTitle count];i++)
                    {
                        editArray1[i] = ((pagesViewController*)pageCollection[pp])->finalMusicTitle[i];
                    }
                    for(int i=0;i<[editArray1 count];i++)
                    {
                        pages->finalMusicTitle[i] = editArray1[i];
                    }
                    pageFill = TRUE;
                    oneFilled =1;
                    
                    pages->layoutused = 12;
                    [pageCollection removeObjectAtIndex:pp];
                    [pageCollection insertObject:pages atIndex:pp];
                    oneNextClicked = 1;
                    
                }
                else
                {
                    autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Warning!!"
                                                                       message:@"You Can't Add Videos Apart From One Layout in VideoAlbum Page"
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                             otherButtonTitles:nil];
                    [autoDissmissalertView show];
                }
            }
        }
    }
    //---------------------FOR BUILDING ALBUM-----------------------------------//
    else
    {
        if(!accordianOpen)
        {
            if(one)
            {
                one->firstImageView.image = original;
                pages->layoutused = 12;
                oneFilled =1;
                [pages->imageURL insertObject:videoURL atIndex:0];
                pageFill = TRUE;
                layOutIsFilled = TRUE;
                videoWarning = TRUE;
                oneImageCounter = 1;
                if( oneImageCounter == 1 && finished)
                {
                    pages->extraImage = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraitem count];i++)
                    {
                        [pages->extraImage addObject:extraitem[i]];
                    }
                    
                    pages->videoArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraVideoItem count];i++)
                    {
                        [pages->videoArray addObject:extraVideoItem[i]];
                    }
                    
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }

                    pages->webLink = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraWebItem count];i++)
                    {
                        [pages->webLink addObject:extraWebItem[i]];
                    }
                }
                if(builderNav)
                {
                    [pageCollection removeObjectAtIndex:page];
                    [pageCollection insertObject:pages atIndex:page];
                }
                oneNextClicked = 1;
                if(replaceImage)
                {
                    [pageCollection removeObjectAtIndex:pagescounter];
                }
                if((one)&&(oneImageCounter==1)&&(oneFilled==1)&&(oneNextClicked==1))
                {
                    [pageCollection insertObject:pages atIndex:pagescounter];
                    replaceImage = TRUE;
                }
            }
            else
            {
                autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Warning!!"
                                                    message:@"You Can't Add Videos Apart From One Layout in VideoAlbum Page"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:nil];
                [autoDissmissalertView show];
            }
        }
        else
        {
            if(Allow )
            {
                if(additem)
                {
                    if((one)&&(accordianOpen))
                    {
                        extraIMageCounter = 0;
                        [pages->videoArray addObject:videoURL];
                        [view3 reloadData];
                    }
                    
                    if((two)&&(accordianOpen))
                    {
                        extraIMageCounter = 0;
                        [pages->videoArray addObject:videoURL];
                        [view3 reloadData];
                    }
                    
                    if((three)&&(accordianOpen))
                    {
                        extraIMageCounter = 0;
                        [pages->videoArray addObject:videoURL];
                        [view3 reloadData];
                    }
                    
                    if((four)&&(accordianOpen))
                    {
                        extraIMageCounter = 0;
                        [pages->videoArray addObject:videoURL];
                        [view3 reloadData];
                    }
                    
                    if((nine)&&(accordianOpen))
                    {
                        extraIMageCounter = 0;
                        [pages->videoArray addObject:videoURL];
                        [view3 reloadData];
                    }
                }
                
                else
                {
                    if(builderNav)
                    {
                        editVideoCounter= 0;
                        [((pagesViewController *) pageCollection[page])->videoArray addObject:videoURL];
                        [view3 reloadData];
                    }
                    else
                    {
                        if(videoWarning)
                        {
                            autoDissmissalertView = [[UIAlertView alloc] initWithTitle:@"Warning!!"
                                                            message:@"You Can't Add ExtraVideo in VideoAlbum Page"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"Cancel"
                                                                     otherButtonTitles:nil];
                            [autoDissmissalertView show];

                        }
                        else
                        {
                            extraIMageCounter = 0;
                            [extraVideoItem addObject:videoURL];
                            pages->videoArray = [[NSMutableArray alloc]init];
                            for(int i=0;i<[extraVideoItem count];i++)
                            {
                                [pages->videoArray addObject:extraVideoItem[i]];
                            }
                            [view3 reloadData];
                        }
                    }
                    
                }
            }

        }
    }

}
//------------------------------FOR SELECTING MUSIC OR AUDIO----------------------------//
-(void)audioPressed:(id)sender
{
    m = [sender tag];
    audioURL = musicArray[m];
    if(mainMusic)
        isalbumFinished = FALSE;
    if(enterEditAlbum)
    {
        if(isalbumFinished)
        {
            editAudioCounter = 0;
            [pages->musicArray addObject:audioURL];
            [pages->finalMusicTitle addObject:musictitle[m]];
            [view2 reloadData];
            
        }
        else
        {
            if(mainMusic)
            {
                autoDissmissalertView = [[UIAlertView alloc] initWithTitle:nil
                                                                   message:@"Click on Tag Additional Media to tag Extra Content"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
                [autoDissmissalertView show];
            }
            else
            {
            editAudioCounter = 0;
            editArray1 = [[NSMutableArray alloc]init];
            [pages->musicArray addObject:audioURL];
            [pages->finalMusicTitle addObject:musictitle[m]];
            int layOut = ((pagesViewController*)pageCollection[pp])->layoutused;
            
            //FOR MAIN IMAGE
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->imageURL count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->imageURL[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->imageURL[i] = editArray1[i];
            }
            //FOR EXTRA IMAGE
            editArray1 = [[NSMutableArray alloc]init];
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->extraImage count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->extraImage[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->extraImage[i] = editArray1[i];
            }
            //FOR EXTRA VIDEO
            editArray1 = [[NSMutableArray alloc]init];
            for(int i=0;i<[((pagesViewController*)pageCollection[pp])->videoArray count];i++)
            {
                editArray1[i] = ((pagesViewController*)pageCollection[pp])->videoArray[i];
            }
            for(int i=0;i<[editArray1 count];i++)
            {
                pages->videoArray[i] = editArray1[i];
            }
            
            pages->layoutused = layOut;
            [pageCollection removeObjectAtIndex:pp];
            [pageCollection insertObject:pages atIndex:pp];
            [view2 reloadData];
            }
        }
    }

    else
    {
        if(Allow )
        {
            if(additem)
            {
                if((one)&&(accordianOpen))
                {
                    extraIMageCounter = 0;
                    [pages->musicArray addObject:audioURL];
                    [pages->finalMusicTitle addObject:musictitle[m]];
                    [view2 reloadData];
                }
                
                if((two)&&(accordianOpen))
                {
                    extraIMageCounter = 0;
                    [pages->musicArray  addObject:audioURL];
                    [pages->finalMusicTitle addObject:musictitle[m]];
                    [view2 reloadData];
                }
                
                if((three)&&(accordianOpen))
                {
                    extraIMageCounter = 0;
                    [pages->musicArray  addObject:audioURL];
                    [pages->finalMusicTitle addObject:musictitle[m]];
                    [view2 reloadData];
                }
                
                if((four)&&(accordianOpen))
                {
                    extraIMageCounter = 0;
                    [pages->musicArray  addObject:audioURL];
                    [pages->finalMusicTitle addObject:musictitle[m]];
                    [view2 reloadData];
                }
                
                if((nine)&&(accordianOpen))
                {
                    extraIMageCounter = 0;
                    [pages->musicArray  addObject:audioURL];
                    [pages->finalMusicTitle addObject:musictitle[m]];
                    [view2 reloadData];
                }
            }
            
            else
            {
                if(builderNav)
                {
                    editAudioCounter= 0;
                    [((pagesViewController *) pageCollection[page])->musicArray addObject:audioURL];
                    [((pagesViewController *) pageCollection[page])->finalMusicTitle addObject:musictitle[m]];
                    [view2 reloadData];
                }
                else
                {
                    extraIMageCounter = 0;
                    [extraAudioItem addObject:audioURL];
                    [extraAudioTitle addObject:musictitle[m]];
                    pages->musicArray = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioItem count];i++)
                    {
                        [pages->musicArray addObject:extraAudioItem[i]];
                    }
                    pages->finalMusicTitle = [[NSMutableArray alloc]init];
                    for(int i=0;i<[extraAudioTitle count];i++)
                    {
                        [pages->finalMusicTitle addObject:extraAudioTitle[i]];
                    }
                    [view2 reloadData];
                }
                
            }
        }
        else
        {
            autoDissmissalertView = [[UIAlertView alloc] initWithTitle:nil
                                                               message:@"Click on Tag Additional Media to tag Extra Content"
                                                              delegate:self
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
            [autoDissmissalertView show];
        }
    }
    audioURL = nil;
}
//-------------------ALL SELECTING METHOD END HERE------------------------//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    Path = NULL;
    indicatorImageView = nil;
    
    // Dispose of any resources that can be recreated.
}

@end

