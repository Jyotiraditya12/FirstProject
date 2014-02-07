//
//  Album.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 30/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewerViewController.h"
@interface Album : NSObject
{
    @public
    NSMutableArray *mainImage;
    NSMutableArray *extraImage;
    NSMutableArray *videos;
    NSMutableArray *audios;
    NSMutableArray *audioTitle;
    NSMutableArray *webLink;
    NSString *AlbumName;
    NSString *themeName;
    NSString *comment;
    int layOut;
    int currentpage ;
    int totalPages;
}
@property (strong, readonly)NSMutableArray *mainImage;
@property (strong, readonly)NSMutableArray *extraImage;
@property (strong, readonly)NSMutableArray *videos;
@property (strong, readonly)NSMutableArray *audios;
@property (strong, readonly)NSMutableArray *audioTitle;
@property (strong, readonly)NSMutableArray *webLink;
@property (strong, nonatomic)NSString *AlbumName;
@property (strong, nonatomic)NSString *themeName;
@property (strong, nonatomic)NSString *comment;
@property (readwrite, nonatomic)int layOut;
@property (readwrite, nonatomic)int currentpage;
@property (readwrite, nonatomic)int totalPages;

@end
