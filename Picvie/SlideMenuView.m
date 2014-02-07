//
//  SlideMenuView.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 12/04/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import "SlideMenuView.h"

@implementation SlideMenuView
@synthesize menuScrollView;
@synthesize menuButtons;
@synthesize soundFileObject, soundFileURLRef;

-(id) initWithFrameColorAndButtons:(CGRect)frame backgroundColor:(UIColor*)bgColor  buttons:(NSMutableArray*)buttonArray
{
	if (self = [super initWithFrame:frame])
    {
		// Initialize the scroll view with the same size as this view.
		menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
		// Set behaviour for the scrollview
		menuScrollView.backgroundColor = bgColor;
		menuScrollView.showsHorizontalScrollIndicator = FALSE;
		menuScrollView.showsVerticalScrollIndicator = FALSE;
		menuScrollView.scrollEnabled = YES;
		menuScrollView.bounces = FALSE;
		
		// Add ourselves as delegate receiver so we can detect when the user is scrolling.
		menuScrollView.delegate = self;
		// Add the buttons to the scrollview
		menuButtons = buttonArray;
		
		totalButtonWidth = 15.0f;
		
		for(int i = 0; i < [menuButtons count]; i++)
		{
			UIButton *btn = [menuButtons objectAtIndex:i];
			
			// Move the buttons position in the x-demension (horizontal).
			CGRect btnRect = btn.frame;
			btnRect.origin.x = totalButtonWidth;
			[btn setFrame:btnRect];
			
			// Add the button to the scrollview
			[menuScrollView addSubview:btn];
			
			// Add the width of the button to the total width.
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                //for iPhone5
                if([[UIScreen mainScreen]bounds].size.height == 568)
                {
                    totalButtonWidth += btn.frame.size.width+20;
                }
                else
                {
                    totalButtonWidth += btn.frame.size.width+20;
                }
            }
            else
            {
                totalButtonWidth += btn.frame.size.width+30;
            }
		}
		// Update the scrollview content rect, which is the combined width of the buttons
		[menuScrollView setContentSize:CGSizeMake(totalButtonWidth, self.frame.size.height)];
		[self addSubview:menuScrollView];
	}
    return self;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            lastScrollPosition = scrollView.contentOffset.x / 120;
        }
        else
        {
            lastScrollPosition = scrollView.contentOffset.x / 120;
        }
    }
    else
    {
        lastScrollPosition = scrollView.contentOffset.x / 200;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //for iPhone5
        if([[UIScreen mainScreen]bounds].size.height == 568)
        {
            if ((int)(scrollView.contentOffset.x / 120) != (int)lastScrollPosition)
            {
                lastScrollPosition = scrollView.contentOffset.x / 120;
                menuScrollView.scrollEnabled =  YES;
                NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"scrollerClick"
                                                            withExtension: @"wav"];
                // Store the URL as a CFURLRef instance
                self.soundFileURLRef = (__bridge CFURLRef)tapSound;
                
                // Create a system sound object representing the sound file.
                AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
                AudioServicesPlaySystemSound (soundFileObject);
            }

        }
        else
        {
            if ((int)(scrollView.contentOffset.x / 120) != (int)lastScrollPosition)
            {
                lastScrollPosition = scrollView.contentOffset.x / 120;
                menuScrollView.scrollEnabled =  YES;
                //    new in iOS 4.0.
                NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"scrollerClick"
                                                            withExtension: @"wav"];
                // Store the URL as a CFURLRef instance
                self.soundFileURLRef = (__bridge CFURLRef)tapSound;
                
                // Create a system sound object representing the sound file.
               AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
                AudioServicesPlaySystemSound (soundFileObject);
            }

        }
    }
    else
    {
        if ((int)(scrollView.contentOffset.x / 200) != (int)lastScrollPosition)
        {
            lastScrollPosition = scrollView.contentOffset.x / 200;
            menuScrollView.scrollEnabled =  YES;
            //    new in iOS 4.0.
            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"scrollerClick"
                                                        withExtension: @"wav"];
            // Store the URL as a CFURLRef instance
            self.soundFileURLRef = (__bridge CFURLRef)tapSound;
            
            // Create a system sound object representing the sound file.
            AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
            AudioServicesPlaySystemSound (soundFileObject);
        }

    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
@end
