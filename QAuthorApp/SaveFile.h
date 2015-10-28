//
//  SaveFile.h
//  StoryCreator
//
//  Created by Yogini Unde on 5/17/13.
//  Copyright (c) 2013 rapidera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveFile : NSObject
#define  ROOTFILENAME           @"Audio" 
//-(void)saveImageInDirectory:(UIImage*)image;
//-(NSString*) saveImageFile:(NSString*)rootName;
//- (NSString *) dateImageString;
;
//-(NSURL*) saveSoundFile;
-(NSURL*) saveSoundFile:(NSString*)idString;
- (NSString *) dateAudioString:(NSString*)pageNo;

@end
