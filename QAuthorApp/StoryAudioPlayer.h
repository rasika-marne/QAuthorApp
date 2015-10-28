//
//  StoryAudioPlayer.h
//  StoryCreator
//
//  Created by Yogini Unde on 5/10/13.
//  Copyright (c) 2013 rapidera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVAudioSession.h>

@interface StoryAudioPlayer : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
#define  ROOTFILENAME           @"Audio" 
@property (nonatomic, strong) NSMutableDictionary *recordSetting;
@property (nonatomic, strong) NSMutableDictionary *editedObject;
@property (nonatomic, strong) NSString *recorderFilePath,*docsDir,*soundFilePath;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer* avaudioPlayer;
@property (nonatomic, strong) NSArray *dirPaths;
@property (nonatomic, strong) NSURL *soundFileURL;
-(void)recordAudio:(NSURL*)URL;
//- (void)playAudio;
- (void)stopRecording;
- (void)playAudio:(NSData*)data;
@end
