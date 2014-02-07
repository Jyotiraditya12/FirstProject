//
//  viewerLayOutFour.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "viewerLayOutFour.h"
#import <QuartzCore/QuartzCore.h>

@interface viewerLayOutFour ()

@end

@implementation viewerLayOutFour
viewerLayOutFour *fourView;
DetailViewController *detailViewController;

@synthesize fourimageViewOne, fourimageViewTwo, fourimageViewThree, fourimageViewFour, touchImageURL;
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
    //for firstimageview
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [fourimageViewOne addGestureRecognizer:tapRecognizer];
    
    //for secondimageview
    tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped1:)];
    [tapRecognizer1 setNumberOfTapsRequired:1];
    [tapRecognizer1 setDelegate:self];
    [fourimageViewTwo addGestureRecognizer:tapRecognizer1];
    
    //for thirdimageview
    tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped2:)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    [fourimageViewThree addGestureRecognizer:tapRecognizer2];
    
    //for thirdimageview
    tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped3:)];
    [tapRecognizer3 setNumberOfTapsRequired:1];
    [tapRecognizer3 setDelegate:self];
    [fourimageViewFour addGestureRecognizer:tapRecognizer3];

    touchImageURL = [[NSMutableArray alloc]init];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    //Adding LongPress Method to the UIImageVIew
    //lomg Press method
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(imageViewlongPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [fourimageViewOne addGestureRecognizer:longPressGesture];
    UILongPressGestureRecognizer *longPressGesture1 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress1:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [fourimageViewTwo addGestureRecognizer:longPressGesture1];
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress2:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [fourimageViewThree addGestureRecognizer:longPressGesture2];
    UILongPressGestureRecognizer *longPressGesture3 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress3:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [fourimageViewFour addGestureRecognizer:longPressGesture3];
    Press = TRUE;

}

//Long Press Method on imageView
-(void)imageViewlongPress:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        firstExif = TRUE;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //for iPhone5
            if([[UIScreen mainScreen]bounds].size.height == 568)
            {
                detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone5" bundle:nil];
                Press = FALSE;
                [self presentPopupViewController:detailViewController animationType:nil];
            }
            else
            {
                detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
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
    showExifData = TRUE;
    if(Press)
    {
        secondExif = TRUE;
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

-(void)imageViewlongPress2:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        thirdExif = TRUE;
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

-(void)imageViewlongPress3:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
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

-(void)tapped:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for firstImageView
    if([tapRecognizer view] ==fourimageViewOne)
    {
        fourFirstSelect = TRUE;
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
    if([tapRecognizer1 view] ==fourimageViewTwo)
    {
        fourSecondSelect = TRUE;
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
-(void)tapped2:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for threeImageView
    if([tapRecognizer2 view] ==fourimageViewThree)
    {
        fourThirdSelect = TRUE;
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

-(void)tapped3:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for fourImageView
    if([tapRecognizer3 view] ==fourimageViewFour)
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
