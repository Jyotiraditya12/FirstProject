//
//  XMLReader.m
//  picVie
//
//  Created by Jyotiraditya Dhalmahapatra on 28/01/13.
//  Copyright (c) 2013 Pronto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

@implementation XMLParser

@synthesize albumname;

NSString	*currentAlbumContent;
NSXMLParser		*parser;
Album			*currentAlbum;
bool            isStatus;
NSString *AlbumName;
NSString *themeName;
NSString *totalPage;

-(id)loadXML:(NSString *)path
{
    NSError *err = nil;
    NSData* xmlData = [NSData dataWithContentsOfFile:path options:nil error:&err];
    if(err)
        NSLog(@"error: %@", err);
    parser	= [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate: self];
	[parser parse];
	return self;
}
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentAlbumContent = (NSString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"Album"])
    {
        
        albumname = [[NSMutableArray alloc] init];
        AlbumName = [[NSString alloc] initWithString:[attributeDict valueForKey:@"name"]];
        themeName = [[NSString alloc] initWithString:[attributeDict valueForKey:@"theme"]];
        totalPage = [[NSString alloc]initWithString:[attributeDict valueForKey:@"TotalPages"]];
    }
    
    if ([elementName isEqualToString:@"page"])
	{
		currentAlbum = [[Album alloc] init];
        currentAlbum->AlbumName = AlbumName;
        currentAlbum->themeName = themeName;
        currentAlbum->totalPages = [totalPage intValue];
        currentAlbum->mainImage = [[NSMutableArray alloc] init];
        currentAlbum->extraImage = [[NSMutableArray alloc] init];
        currentAlbum->videos = [[NSMutableArray alloc] init];
        currentAlbum->audios = [[NSMutableArray alloc] init];
        currentAlbum->audioTitle = [[NSMutableArray alloc] init];
        currentAlbum->webLink = [[NSMutableArray alloc] init];
        isStatus = YES;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isStatus)
    {
        
        if ([elementName isEqualToString:@"LU"])
        {
            layout = [currentAlbumContent  intValue];
            currentAlbum.layOut = layout;
        }

        if ([elementName isEqualToString:@"MainImages"])
        {
            [currentAlbum.mainImage addObject:currentAlbumContent];
        }
        
        if ([elementName isEqualToString:@"ExtraImages"])
        {
            [currentAlbum.extraImage addObject:currentAlbumContent];
        }
        if ([elementName isEqualToString:@"Videos"])
        {
            
            [currentAlbum.videos addObject:currentAlbumContent];
            
        }
        if ([elementName isEqualToString:@"Audios"])
        {
            
            [currentAlbum.audios addObject:currentAlbumContent];
        }
        if ([elementName isEqualToString:@"AudioTitle"])
        {
            
            [currentAlbum.audioTitle addObject:currentAlbumContent];
        }
        if ([elementName isEqualToString:@"WebLink"])
        {
           [currentAlbum.webLink addObject:currentAlbumContent];
      
        }
        if ([elementName isEqualToString:@"Comment"])
        {
            currentAlbum.comment  = [NSString stringWithString:currentAlbumContent];
            
        }

        if ([elementName isEqualToString:@"CP"])
        {
            CP = [currentAlbumContent  intValue];
            currentAlbum.currentpage = CP;
        }
    }
    
    if ([elementName isEqualToString:@"page"])
	{
		[albumname addObject:currentAlbum];
		currentAlbum = nil;
		currentAlbumContent = nil;
	}
}

@end
