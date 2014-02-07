//
//  viewerLayOutTwo.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 04/02/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "viewerLayOutTwo.h"
#import <QuartzCore/QuartzCore.h>

@interface viewerLayOutTwo ()

@end

@implementation viewerLayOutTwo
viewerLayOutTwo *twoView;
ViewerViewController *view;
@synthesize twoimageViewOne, twoimageViewTwo, touchImageURL;

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
    // Do any additional setup after loading the view from its nib.
    imageView = [[UIImageView alloc]init];
    touchImageURL = [[NSMutableArray alloc] init];
    //for first one
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [twoimageViewOne addGestureRecognizer:tapRecognizer];
 
    
    //for second one
    tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped1:)];
    [tapRecognizer1 setNumberOfTapsRequired:1];
    [tapRecognizer1 setDelegate:self];
    [twoimageViewTwo addGestureRecognizer:tapRecognizer1];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    //Adding LongPress Method to the UIImageVIew
    //lomg Press method
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(imageViewlongPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [twoimageViewOne addGestureRecognizer:longPressGesture];
    UILongPressGestureRecognizer *longPressGesture1 = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(imageViewlongPress1:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [twoimageViewTwo addGestureRecognizer:longPressGesture1];
    Press = TRUE;
}
//Long Press Method on imageView
-(void)imageViewlongPress:(UIGestureRecognizer*) sender
{
    if(Press)
    {
        showExifData = TRUE;
        firstExif = TRUE;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone5" bundle:nil];
                Press = FALSE;
                [self presentPopupViewController:detailViewController animationType:nil];
            }
            else
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                Press = FALSE;
                [self presentPopupViewController:detailViewController animationType:nil];
            }
        }
        else
        {
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
            Press = FALSE;
            [self presentPopupViewController:detailViewController animationType:nil];
        }
        
    }
}

-(void)imageViewlongPress1:(UIGestureRecognizer*) sender
{
    if(Press)
    {
        showExifData = TRUE;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone5" bundle:nil];
                Press = FALSE;
                [self presentPopupViewController:detailViewController animationType:nil];
            }
            else
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                Press = FALSE;
                [self presentPopupViewController:detailViewController animationType:nil];
            }
        }
        else
        {
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
            Press = FALSE;
            [self presentPopupViewController:detailViewController animationType:nil];
        }
        
    }
}


//-----------------------------Tapping for POPUP Image View---------------------------------//
-(void)tapped:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for firstImageView
    if([tapRecognizer view] ==twoimageViewOne)
    {
        firstSelect = TRUE;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone5" bundle:nil];
                [self presentPopupViewController:detailViewController animationType:nil];
            }
            else
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                [self presentPopupViewController:detailViewController animationType:nil];
            }
        }
        else
        {
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
            [self presentPopupViewController:detailViewController animationType:nil];
        }
    }
}
-(void)tapped1:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
     //for secondImageView
    if([tapRecognizer1 view] ==twoimageViewTwo)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone5" bundle:nil];
                [self presentPopupViewController:detailViewController animationType:nil];
            }
            else
            {
                DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                [self presentPopupViewController:detailViewController animationType:nil];
            }
        }
        else
        {
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
            [self presentPopupViewController:detailViewController animationType:nil];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGPoint centerPoint = CGPointMake(CGRectGetMidX( imageView.bounds),
                                      CGRectGetMidY( imageView.bounds));
    [imageView setCenter:centerPoint];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
