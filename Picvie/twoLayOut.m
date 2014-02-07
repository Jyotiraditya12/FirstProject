//
//  twoLayOut.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 31/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "twoLayOut.h"
#import <QuartzCore/QuartzCore.h>
@interface twoLayOut ()

@end

@implementation twoLayOut

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
    // Do any additional setup after loading the view from its nib.
    /*[twofirstImageView.layer setBorderColor: [[UIColor redColor] CGColor]];
    [twofirstImageView.layer setBorderWidth: 1.0];
    
    [twosecondImageView.layer setBorderColor: [[UIColor redColor] CGColor]];
    [twosecondImageView.layer setBorderWidth: 1.0];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
