//
//  viewerLayOutNine.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "viewerLayOutNine.h"
#import <QuartzCore/QuartzCore.h>

@interface viewerLayOutNine ()

@end

@implementation viewerLayOutNine
viewerLayOutNine *nineView;
@synthesize nineimageViewOne, nineimageViewTwo, nineimageViewThree, nineimageViewFour, nineimageViewFive, nineimageViewSix, nineimageViewSeven, nineimageViewEight,nineimageViewNine, touchImageURL;
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
    [nineimageViewOne addGestureRecognizer:tapRecognizer];
    
    //for secondimageview
    tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped1:)];
    [tapRecognizer1 setNumberOfTapsRequired:1];
    [tapRecognizer1 setDelegate:self];
    [nineimageViewTwo addGestureRecognizer:tapRecognizer1];
    
    //for thirdimageview
    tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped2:)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    [nineimageViewThree addGestureRecognizer:tapRecognizer2];
    
    //for fourimageview
    tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped3:)];
    [tapRecognizer3 setNumberOfTapsRequired:1];
    [tapRecognizer3 setDelegate:self];
    [nineimageViewFour addGestureRecognizer:tapRecognizer3];
    
    //for fiveimageview
    tapRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped4:)];
    [tapRecognizer4 setNumberOfTapsRequired:1];
    [tapRecognizer4 setDelegate:self];
    [nineimageViewFive addGestureRecognizer:tapRecognizer4];
    
    //for siximageview
    tapRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped5:)];
    [tapRecognizer5 setNumberOfTapsRequired:1];
    [tapRecognizer5 setDelegate:self];
    [nineimageViewSix addGestureRecognizer:tapRecognizer5];
    
    //for sevenimageview
    tapRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped6:)];
    [tapRecognizer6 setNumberOfTapsRequired:1];
    [tapRecognizer6 setDelegate:self];
    [nineimageViewSeven addGestureRecognizer:tapRecognizer6];
    
    //for eightimageview
    tapRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped7:)];
    [tapRecognizer7 setNumberOfTapsRequired:1];
    [tapRecognizer7 setDelegate:self];
    [nineimageViewEight addGestureRecognizer:tapRecognizer7];
    
    //for nineimageview
    tapRecognizer8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped8:)];
    [tapRecognizer8 setNumberOfTapsRequired:1];
    [tapRecognizer8 setDelegate:self];
    [nineimageViewNine addGestureRecognizer:tapRecognizer8];
    
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
    [nineimageViewOne addGestureRecognizer:longPressGesture];
    
    UILongPressGestureRecognizer *longPressGesture1 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress1:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewTwo addGestureRecognizer:longPressGesture1];
    
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress2:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewThree addGestureRecognizer:longPressGesture2];
    
    UILongPressGestureRecognizer *longPressGesture3 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress3:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewFour addGestureRecognizer:longPressGesture3];
    
    UILongPressGestureRecognizer *longPressGesture4 = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(imageViewlongPress4:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewFive addGestureRecognizer:longPressGesture4];
    
    UILongPressGestureRecognizer *longPressGesture5 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress5:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewSix addGestureRecognizer:longPressGesture5];
    
    UILongPressGestureRecognizer *longPressGesture6 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress6:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewSeven addGestureRecognizer:longPressGesture6];
    
    UILongPressGestureRecognizer *longPressGesture7 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress7:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewEight addGestureRecognizer:longPressGesture7];
    
    UILongPressGestureRecognizer *longPressGesture8 = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(imageViewlongPress8:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [nineimageViewNine addGestureRecognizer:longPressGesture8];
    Press = TRUE;

}

//Long Press Method on imageView
//For Nine first IMageView

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
//For NIne Second ImageView
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
//For Nine Third ImageView
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
//for Nine Four ImageView
-(void)imageViewlongPress3:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        fourExif = TRUE;
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
//For Nine Five ImageView
-(void)imageViewlongPress4:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        fiveExif = TRUE;
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
//For Nine Six IMageView
-(void)imageViewlongPress5:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        sixExif = TRUE;
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
//For Nine Seven ImageView
-(void)imageViewlongPress6:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        sevenExif = TRUE;
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
//For Nine Eight ImaeView
-(void)imageViewlongPress7:(UIGestureRecognizer*) sender
{
    showExifData = TRUE;
    if(Press)
    {
        eightExif = TRUE;
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
//For NIne Nine ImageView
-(void)imageViewlongPress8:(UIGestureRecognizer*) sender
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

//-------------------------------ImageView Tapped Method Beigin-----------------------------//

-(void)tapped:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for firstImageView
    if([tapRecognizer view] ==nineimageViewOne)
    {
        nineFirstSelect = TRUE;
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
    if([tapRecognizer1 view] ==nineimageViewTwo)
    {
        nineSecondSelect = TRUE;
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
    if([tapRecognizer2 view] ==nineimageViewThree)
    {
        nineThirdSelect = TRUE;
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
    if([tapRecognizer3 view] ==nineimageViewFour)
    {
        nineFourSelect = TRUE;
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

-(void)tapped4:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for fiveImageView
    if([tapRecognizer4 view] ==nineimageViewFive)
    {
        nineFiveSelect = TRUE;
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
-(void)tapped5:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for secondImageView
    if([tapRecognizer5 view] ==nineimageViewSix)
    {
        nineSixSelect = TRUE;
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
-(void)tapped6:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for threeImageView
    if([tapRecognizer6 view] ==nineimageViewSeven)
    {
        nineSevenSelect = TRUE;
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

-(void)tapped7:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for fourImageView
    if([tapRecognizer7 view] ==nineimageViewEight)
    {
        nineEightSelect = TRUE;
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

-(void)tapped8:(UIGestureRecognizer*) sender
{
    showPopUp = TRUE;
    //for fourImageView
    if([tapRecognizer8 view] ==nineimageViewNine)
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
