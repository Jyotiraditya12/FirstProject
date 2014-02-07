//
//  viewerLayOutOne.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//
#import "viewerLayOutOne.h"
#import "testClasAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface viewerLayOutOne (UserInteractionFeatures)

@end

@implementation viewerLayOutOne
@synthesize imageViewOne;
viewerLayOutOne *oneView;
ViewerViewController *view;


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
    
    imageView = [[UIImageView alloc]init];
    
    //adding Tap Gesture on UIImageView
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [imageViewOne addGestureRecognizer:tapRecognizer];
    //lomg Press method
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(imageViewlongPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [imageViewOne addGestureRecognizer:longPressGesture];
    Press = TRUE;
}

//Long Press Method on imageView
-(void)imageViewlongPress:(UIGestureRecognizer*) sender
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


//Tapped Method on ImageView
-(void)tapped:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    if([tapRecognizer view] ==imageViewOne)
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
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
