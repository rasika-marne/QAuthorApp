//
//  SaveFile.m
//  StoryCreator
//
//  Created by Yogini Unde on 5/17/13.
//  Copyright (c) 2013 rapidera. All rights reserved.
//

#import "SaveFile.h"

#import "NSUserDefaults+StoryData.h"

@implementation SaveFile

#pragma mark - Save Image In Directory

#pragma mark - Save Audio File

-(NSURL*) saveSoundFile:(NSString*)idString
{
    NSLog(@"id str:%@",idString);
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [NSString stringWithFormat:@"%@/%@", [dirPaths objectAtIndex:0],ROOTFILENAME];
    
    // Check if the directory already exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:docsDir]) {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:docsDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[self dateAudioString:idString]];
    [kUserDefaults saveAudioFilePath:soundFilePath];
    NSURL* soundFileURL = [NSURL URLWithString:soundFilePath];
    //(__bridge NSURL *)(CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)soundFilePath, NULL));
    //[self saveAudioFilePathInDataBase:soundFilePath];
    return soundFileURL;
}

- (NSString *) dateAudioString:(NSString*)pageNo;
{
    // return a formatted string for a file name
   // NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"ddMMMYY";
    
    NSString* audioFilePath = [NSString stringWithFormat:@"audio%@",pageNo];
    return [audioFilePath stringByAppendingString:@".caf"];
   // return [audioFilePath stringByAppendingString:@".wav"];
}


@end
