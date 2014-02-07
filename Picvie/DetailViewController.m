
//
//  DetailViewController.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 08/07/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "DetailViewController.h"
viewerLayOutOne *oneView;
viewerLayOutTwo *twoView;
viewerLayOutThree *threeView;
viewerLayOutFour *fourView;
viewerLayOutNine *nineView;
ViewerViewController *view;
testClasViewController *test;
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(oneView)
    {
        if(oneView->showExifData)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                
                NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];

                    }
                    oneView->showExifData = FALSE;
                    oneView->Press = TRUE;
                    exifTableView = NULL;
            };
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
            
            NSURL *asseturl = [NSURL URLWithString:oneView->touchImageURL];
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
        //-----------------------For Extra Image----------------------------//
        if(oneView->showExtraImage)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
                popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                  CGRectGetMidY( scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                scrollView.pagingEnabled = NO;
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                [self.view addSubview:scrollView];
                oneView->showExtraImage = FALSE;
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
                NSURL *asseturl = [NSURL URLWithString:oneView->extraString];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
        }
        //------------------------for Pop up Image------------------------//
        if(oneView->showPopUp)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
                popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX(scrollView.bounds),
                                                  CGRectGetMidY(scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                [self.view addSubview:scrollView];
                oneView->showPopUp = FALSE;
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
                NSURL *asseturl = [NSURL URLWithString:oneView->touchImageURL];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
 
        }
        //-----------------------for WebLink Display--------------------------------//
        if(oneView->webLink)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                }
                else
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                }
            }
            else
            {
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
            }
            webView.scrollView.scrollEnabled =YES;
            webView.scalesPageToFit=YES;
            webView.contentMode = UIViewContentModeScaleAspectFit;
            webView.clearsContextBeforeDrawing = TRUE;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oneView->webString]]];
            [self.view addSubview:webView];
            oneView->webLink = FALSE;
        }
    }
    else if (videoExtraImage)
    {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
                popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                  CGRectGetMidY( scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                scrollView.pagingEnabled = NO;
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                [self.view addSubview:scrollView];
                videoExtraImage = FALSE;
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
            NSURL *asseturl = [NSURL URLWithString:videoAlbumExtraImageString];
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
    }
    else if (videoExtraWebLink)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                 webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
            }
            else
            {
                 webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
            }
        }
        else
        {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
        }
        webView.scrollView.scrollEnabled =YES;
        webView.scalesPageToFit=YES;
        webView.contentMode = UIViewContentModeScaleAspectFit;
        webView.clearsContextBeforeDrawing = TRUE;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:videoAlbumExtraImageString]]];
        [self.view addSubview:webView];
        videoExtraWebLink = FALSE;
    }
    //------------------------For Second ImageView LayOut PopUP--------------------------------//
    else if (twoView)
    {
        if(twoView->showExifData)
        {
            if(twoView->firstExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    twoView->showExifData = FALSE;
                    twoView->Press = TRUE;
                    twoView->firstExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:twoView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            
            }
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    twoView->showExifData = FALSE;
                    twoView->Press = TRUE;
                    exifTableView = NULL;
                    
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:twoView->touchImageURL[1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
        
        }
        //------------------------------for Extra Image--------------------------------//
        if(twoView->showExtraImage)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
                popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                  CGRectGetMidY( scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                scrollView.scrollEnabled = YES;
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                scrollView.pagingEnabled = NO;
                [self.view addSubview: scrollView];
                twoView->showExtraImage = FALSE;
                
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
                NSURL *asseturl = [NSURL URLWithString:twoView->extraString];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
        //-------------------------------For Pop Up Image--------------------------------//
       if(twoView->showPopUp)
        {
            if(twoView->firstSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    scrollView.scrollEnabled = YES;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    twoView->firstSelect = FALSE;
                    twoView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                NSURL *asseturl = [NSURL URLWithString:twoView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            //----------------------For Second ImageView PopUp----------------------------//
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                     twoView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:twoView->touchImageURL [1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
        }
        if(twoView->webLink)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                }
                else
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                }
            }
            else
            {
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
            }
            webView.scrollView.scrollEnabled =YES;
            webView.scalesPageToFit=YES;
            webView.contentMode = UIViewContentModeScaleAspectFit;
            webView.clearsContextBeforeDrawing = TRUE;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:twoView->webString]]];
            [self.view addSubview:webView];
            twoView->webLink = FALSE;
        }

    }
    
    //-------------------For Third ImageView LayOut and ExtraImage PopUP------------------------//
    else if (threeView)
    {
        if(threeView->showExifData)
        {
            if(threeView->firstExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    threeView->showExifData = FALSE;
                    threeView->Press = TRUE;
                    threeView->firstExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:threeView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(threeView->secondExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    threeView->showExifData = FALSE;
                    threeView->Press = TRUE;
                    threeView->secondExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:threeView->touchImageURL[1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    threeView->showExifData = FALSE;
                    threeView->Press = TRUE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:threeView->touchImageURL[2]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            
        }
        //---------------For Extra Image------------------------//
        if(threeView->showExtraImage)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
               popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                  CGRectGetMidY( scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                scrollView.scrollEnabled = YES;
                [scrollView setDelaysContentTouches:YES];
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                [self.view addSubview: scrollView];
                threeView->showExtraImage = FALSE;
                
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
            
                NSURL *asseturl = [NSURL URLWithString:threeView->extraString];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
        }
        //----------------For Three Lay Out Pop Up Image------------------// 
         if(threeView->showPopUp)
        {
            if(threeView->threeFirstSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    threeView->threeFirstSelect = FALSE;
                    threeView->showPopUp = FALSE;
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                    NSURL *asseturl = [NSURL URLWithString:threeView->touchImageURL[0]];
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:asseturl
                                   resultBlock:resultblock
                                  failureBlock:failureblock];
            }
            //----------------------For Second ImageView PopUp----------------------------//
            else if (threeView->threeSecondSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    threeView->threeSecondSelect = FALSE;
                     threeView->showPopUp = FALSE;
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                    NSURL *asseturl = [NSURL URLWithString:threeView->touchImageURL[1]];
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:asseturl
                                   resultBlock:resultblock
                            failureBlock:failureblock];
                
            }
            
            //---------------------------For ThirdImageView PopUp-----------------------------//
           else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                     threeView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                    NSURL *asseturl = [NSURL URLWithString:threeView->touchImageURL[2]];
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:asseturl
                                   resultBlock:resultblock
                                  failureBlock:failureblock];
            }
        
        }
        if(threeView->webLink)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                }
                else
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                }
            }
            else
            {
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
            }
            webView.scrollView.scrollEnabled =YES;
            webView.scalesPageToFit=YES;
            webView.contentMode = UIViewContentModeScaleAspectFit;
            webView.clearsContextBeforeDrawing = TRUE;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:threeView->webString]]];
            [self.view addSubview:webView];
            threeView->webLink = FALSE;
        }
        
    }

    //--------------------------FOR FOUR LAYOUT IMAGEVIEW----------------------------//
    else if (fourView)
    {
        if(fourView->showExifData)
        {
            if(fourView->firstExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    fourView->showExifData = FALSE;
                    fourView->Press = TRUE;
                    fourView->firstExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(fourView->secondExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    fourView->showExifData = FALSE;
                    fourView->Press = TRUE;
                    fourView->secondExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(fourView->thirdExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    fourView->showExifData = FALSE;
                    fourView->Press = TRUE;
                    fourView->thirdExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[2]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    fourView->showExifData = FALSE;
                    fourView->Press = TRUE;
                    exifTableView = NULL;
                    
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[3]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            
        }

        //-----------------------For Extra Image-------------------------------//
        if(fourView->showExtraImage)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
                popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                  CGRectGetMidY( scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                scrollView.scrollEnabled = YES;
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                [self.view addSubview: scrollView];
                fourView->showExtraImage = FALSE;
                
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };

                NSURL *asseturl = [NSURL URLWithString:fourView->extraString];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
        }
        //---------------------For Pop up Image of Four layout----------------------//
        if(fourView->showPopUp)
        {
            if(fourView->fourFirstSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    fourView->fourFirstSelect= FALSE;
                    fourView->showPopUp = FALSE;
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (fourView->fourSecondSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    fourView->fourSecondSelect = FALSE;
                    fourView->showPopUp = FALSE;
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (fourView->fourThirdSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    fourView->fourThirdSelect = FALSE;
                    fourView->showPopUp = FALSE;
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[2]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    fourView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:fourView->touchImageURL[3]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
        }
        if(fourView->webLink)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                }
                else
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                }
            }
            else
            {
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
            }
            webView.scrollView.scrollEnabled =YES;
            webView.scalesPageToFit=YES;
            webView.contentMode = UIViewContentModeScaleAspectFit;
            webView.clearsContextBeforeDrawing = TRUE;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fourView->webString]]];
            [self.view addSubview:webView];
            fourView->webLink = FALSE;
        }
        
    }
    //-------------------------FOR NINE LAYOUT IMAGEVIEW--------------------------//
    else if(nineView)
    {
        if(nineView->showExifData)
        {
            if(nineView->firstExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->firstExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->secondExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->secondExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->thirdExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->thirdExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[2]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->fourExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->fourExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[3]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->fiveExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->fiveExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[4]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->sixExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->sixExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[5]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->sevenExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->sevenExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[6]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            if(nineView->eightExif)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    nineView->eightExif = FALSE;
                    exifTableView = NULL;
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[7]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
                
            }
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    
                    NSString *exifString;
                    exifArray = [[NSMutableArray alloc]init];
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    NSDate *date = [myasset valueForProperty:ALAssetPropertyDate];
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
                    NSString *convertDate = [format stringFromDate:date];
                    NSString *dateTime = @"Date and Time of Photo:";
                    dateTime = [dateTime stringByAppendingString:convertDate];
                    [exifArray addObject: dateTime];
                    NSDictionary *metadata = myasset.defaultRepresentation.metadata;
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Make"].location == NSNotFound)
                    {
                        NSString *make = @"Camera Make: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Make ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Model =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Camera Make:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    exifString = [metadata description];
                    substrings = [exifString componentsSeparatedByString:@"{TIFF}"];
                    exifString = [substrings objectAtIndex:1];
                    if([exifString rangeOfString:@"Model"].location == NSNotFound)
                    {
                        NSString *model = @"Camera Model: NULL";
                        [exifArray addObject:model];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Model ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"Orientation =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *model = @"Camera Model:";
                        model = [model stringByAppendingString:exifString];
                        [exifArray addObject: model];
                    }
                    exifString = [metadata description];
                    if([exifString rangeOfString:@"Orientation"].location == NSNotFound)
                    {
                        NSString *make = @"Orientation: NULL";
                        [exifArray addObject:make];
                    }
                    else
                    {
                        substrings = [exifString componentsSeparatedByString:@"Orientation ="];
                        exifString = [substrings objectAtIndex:1];
                        substrings =[exifString componentsSeparatedByString:@"ResolutionUnit ="];
                        exifString = [substrings objectAtIndex:0];
                        exifString = [exifString stringByReplacingOccurrencesOfString:@"ResolutionUnit =" withString:@""];
                        substrings = [exifString componentsSeparatedByString:@";"];
                        exifString = [substrings objectAtIndex:0];
                        NSString *make = @"Orientation:";
                        make = [make stringByAppendingString:exifString];
                        [exifArray addObject: make];
                    }
                    NSString *height = @"Image Height:";
                    int ht = (int) (temp.size.height);
                    height = [height stringByAppendingString:[NSString stringWithFormat:@"%d",ht]];
                    [exifArray addObject:height];
                    NSString *width = @"Image Width:";
                    int wt = (int) (temp.size.width);
                    width = [width stringByAppendingString:[NSString stringWithFormat:@"%d",wt]];
                    [exifArray addObject:width];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 470, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                        else
                        {
                            exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 390, 270) style:UITableViewStyleGrouped];
                            exifTableView.dataSource = self;
                            exifTableView.delegate = self;
                            exifTableView.tag = 1;
                            [self.view addSubview: exifTableView];
                        }
                    }
                    else
                    {
                        exifTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 880, 640) style:UITableViewStyleGrouped];
                        exifTableView.dataSource = self;
                        exifTableView.delegate = self;
                        exifTableView.tag = 1;
                        [self.view addSubview: exifTableView];
                        
                    }
                    nineView->showExifData = FALSE;
                    nineView->Press = TRUE;
                    exifTableView = NULL;
                    
                };
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[8]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            
        }

        //-----------------------For Extra Image-------------------------------//
        if(nineView->showExtraImage)
        {
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                temp = [UIImage imageWithCGImage:iref];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    //for iPhone5
                    if([[UIScreen mainScreen]bounds].size.height == 568)
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                        [scrollView setContentSize:CGSizeMake(470, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                        [scrollView setContentSize:CGSizeMake(390, 270)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                    }
                }
                else
                {
                    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                    [scrollView setContentSize:CGSizeMake(880, 640)];
                    popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                }
                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                [popupView setImage:temp];
                popupView.contentMode = UIViewContentModeScaleAspectFit;
                CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                  CGRectGetMidY( scrollView.bounds));
                [popupView setCenter:centerPoint];
                scrollView.contentSize = temp.size;
                [scrollView addSubview: popupView];
                scrollView.delegate = self;
                scrollView.scrollEnabled = YES;
                [scrollView setMinimumZoomScale:0.5f];
                [scrollView setMaximumZoomScale:4.0f];
                [scrollView setBounces:NO];
                [self.view addSubview: scrollView];
                nineView->showExtraImage = FALSE;
                
            };
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
            };
                NSURL *asseturl = [NSURL URLWithString:nineView->extraString];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
        }
        //----------------For Nine Image LayOUt PopUp Image----------------------//
         if(nineView->showPopUp)
        {
            if(nineView->nineFirstSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineFirstSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[0]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineSecondSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineSecondSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[1]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineThirdSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineThirdSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[2]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineFourSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineFourSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[3]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineFiveSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineFiveSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[4]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineSixSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineSixSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[5]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineSevenSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineSevenSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[6]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else if (nineView->nineEightSelect)
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }
                    temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->nineEightSelect = FALSE;
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[7]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }
            else
            {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    temp = [UIImage imageWithCGImage:iref];
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        //for iPhone5
                        if([[UIScreen mainScreen]bounds].size.height == 568)
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                            [scrollView setContentSize:CGSizeMake(470, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 470, 270)];
                        }
                        else
                        {
                            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                            [scrollView setContentSize:CGSizeMake(390, 270)];
                            popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 390, 270)];
                        }
                    }
                    else
                    {
                        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
                        [scrollView setContentSize:CGSizeMake(880, 640)];
                        popupView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 880, 640)];
                    }                temp = [DetailViewController imageWithImage:temp scaledToWidth:popupView.frame.size.width];
                    [popupView setImage:temp];
                    popupView.contentMode = UIViewContentModeScaleAspectFit;
                    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                                      CGRectGetMidY( scrollView.bounds));
                    [popupView setCenter:centerPoint];
                    scrollView.contentSize = temp.size;
                    [scrollView addSubview: popupView];
                    scrollView.delegate = self;
                    [scrollView setMinimumZoomScale:0.5f];
                    [scrollView setMaximumZoomScale:4.0f];
                    [scrollView setBounces:NO];
                    [self.view addSubview: scrollView];
                    nineView->showPopUp = FALSE;
                    
                };
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                };
                
                NSURL *asseturl = [NSURL URLWithString:nineView->touchImageURL[8]];
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:asseturl
                               resultBlock:resultblock
                              failureBlock:failureblock];

            }
        }
        if(nineView->webLink)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 470, 270)];
                }
                else
                {
                    webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 390, 270)];
                }
            }
            else
            {
                webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, 880, 640)];
            }
            webView.scrollView.scrollEnabled =YES;
            webView.scalesPageToFit=YES;
            webView.contentMode = UIViewContentModeScaleAspectFit;
            webView.clearsContextBeforeDrawing = TRUE;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:nineView->webString]]];
            [self.view addSubview:webView];
            nineView->webLink = FALSE;
        }
    }
    else
    {
        browserAddressbar.text = @"http://";
        [webBrowserView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
        webBrowserView.scalesPageToFit = YES;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkLoad) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkNotLoad) userInfo:nil repeats:YES];
        [self.view addSubview:webBrowserView];
        [done setEnabled:NO];
    }
    
}
-(void)checkLoad
{
    if (webBrowserView.loading)
    {
        [activityIndicator startAnimating];
    }
}

-(void)checkNotLoad
{
    if (!(webBrowserView.loading))
    {
        [activityIndicator stopAnimating];
        NSURL* url = [webBrowserView.request URL];
        browserAddressbar.text = [url absoluteString];
        browserLink = browserAddressbar.text;
        [done setEnabled:YES];
    }
}

-(IBAction)Done:(id)sender
{
    [self dismissPopupViewControllerWithanimation:nil];
    test->Allow = TRUE;
    test->web = TRUE;
    [test controlAccrodian];
    [test copyLink];
    [close setEnabled:YES];
    
}
-(IBAction)close:(id)sender
{
    [self.view removeFromSuperview];
    webBrowserView = nil;
    addWebLink = nil;
    activityIndicator = nil;
    self.view = nil;
}

//-----------------------TAble View Method For Display Exif Info----------------------//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)genTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)genTableView numberOfRowsInSection:(NSInteger)section
{
    
    if(genTableView.tag == 1)
        
        return [exifArray count];
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)genTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [genTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if(genTableView.tag == 1)
    {
        if ([exifArray count] > 0)
        {
            [cell.textLabel setText:[exifArray objectAtIndex:indexPath.row]];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
        }
    }
    return  cell;
}
//-------------------Table View Method Finish here-----------------------------//

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return   popupView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGPoint centerPoint = CGPointMake(CGRectGetMidX( scrollView.bounds),
                                      CGRectGetMidY( scrollView.bounds));
    [popupView setCenter:centerPoint];
}
- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = scrollView.contentOffset;
    
    CGFloat x = centerPoint.x - vf.size.width / 2.0;
    CGFloat y = centerPoint.y - vf.size.height / 2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    scrollView.contentOffset = co;
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
       
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
        
    }
    zoomView.frame = zvf;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

