//
//  SlideMenuView.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 12/04/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface SlideMenuView : UIView <UIScrollViewDelegate>
{
    @public
	UIScrollView *menuScrollView;
	NSMutableArray *menuButtons;
    float totalButtonWidth ;
    NSString *soundPath;
    CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
    CGFloat lastScrollPosition;
}
-(id) initWithFrameColorAndButtons:(CGRect)frame backgroundColor:(UIColor*)bgColor  buttons:(NSMutableArray*)buttonArray;
@property (nonatomic, retain) UIScrollView* menuScrollView;
@property (nonatomic, retain) NSMutableArray* menuButtons;
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@end
