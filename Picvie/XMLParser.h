//
//  XMLReader.h
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
#import "ViewerViewController.h"
#import "pagesViewController.h"
@interface XMLParser : NSObject <NSXMLParserDelegate>
{
  @public
    NSMutableArray *albumname;
    int layout;
    int CP;
}
@property (strong, readonly) NSMutableArray *albumname;

-(id) loadXML:(NSString *)path;

@end 