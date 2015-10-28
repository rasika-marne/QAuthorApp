//
//  NSUserDefaults+StoryData.m
//  StoryCreator
//
//  Created by Yogini Unde on 5/13/13.
//  Copyright (c) 2013 rapidera. All rights reserved.
//

#import "NSUserDefaults+StoryData.h"

@implementation NSUserDefaults (StoryData)



-(void)shouldAutoplayAudio:(BOOL)shouldAutoplay
{
    [kUserDefaults setBool:shouldAutoplay forKey:AUTOPLAY_AUDIO_STATUS];
    [kUserDefaults synchronize];
}


-(BOOL)getAutoplayAudioStatus
{
    return [kUserDefaults boolForKey:AUTOPLAY_AUDIO_STATUS];
}



-(void)saveAudioFilePath:(NSString*)title
{
    [kUserDefaults setValue:title forKey:AUDIO_FILE_PATH];
}

-(NSString*)getAudioFilePathName
{
    return  [kUserDefaults valueForKey:AUDIO_FILE_PATH];
}


@end
