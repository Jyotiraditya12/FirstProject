//
//  pagesViewController.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 23/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "testClasViewController.h"
#import "XMLWriter.h"

@interface pagesViewController : UIViewController
{
@public
    int pagecounter;
    int layoutused;
    
    //for Image
    NSMutableArray *imageURL;
 
    //for extraimage
    NSMutableArray *extraImage;

    //for video
    NSMutableArray *videoArray;

    //for Audio
    NSMutableArray *musicArray;
    NSMutableArray *finalMusicTitle;
   
    //for weblink
    NSMutableArray *webLink;
    
    //for comment
    NSString *comment;
   

    
}
@property (nonatomic,readonly) int pagecounter;
@property (nonatomic,readonly) int layoutused;
@property (nonatomic, retain) NSMutableArray *imageURL;
@property (nonatomic, retain) NSMutableArray *extraImage;
@property (nonatomic, retain) NSMutableArray *videoArray;
@property (nonatomic, retain) NSMutableArray *musicArray;
@property (nonatomic, retain) NSMutableArray *finalMusicTitle;
@property (nonatomic, retain) NSMutableArray *webLink;

@end
