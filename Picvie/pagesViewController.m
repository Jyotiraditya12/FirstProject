//
//  pagesViewController.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 23/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "pagesViewController.h"

@interface pagesViewController ()

@end

@implementation pagesViewController

@synthesize imageURL,extraImage,videoArray,musicArray,finalMusicTitle, pagecounter,layoutused, webLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
