//
//  NSUserDefaults+StoryData.h
//  StoryCreator
//
//  Created by Yogini Unde on 5/13/13.
//  Copyright (c) 2013 rapidera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (StoryData)
#define AUTOPLAY_AUDIO_STATUS   @"Autoplay_Audio_status"
#define AUDIO_FILE_PATH         @"Audio_File_Path"
#define kUserDefaults [NSUserDefaults standardUserDefaults]
-(void)shouldAutoplayAudio:(BOOL)shouldAutoplay;
-(BOOL)getAutoplayAudioStatus;

-(void)saveAudioFilePath:(NSString*)title;
-(NSString*)getAudioFilePathName;

@end
