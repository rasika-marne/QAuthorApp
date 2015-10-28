//
//  StoryAudioPlayer.m
//  StoryCreator
//
//  Created by Yogini Unde on 5/10/13.
//  Copyright (c) 2013 rapidera. All rights reserved.
//

#import "StoryAudioPlayer.h"

@implementation StoryAudioPlayer 


-(void)recordAudio:(NSURL*)URL
{

    if (!_audioRecorder.recording)
    {
        // create the audio file
        /*NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                        AVFormatIDKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:16000.0],
                                        AVSampleRateKey,
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        nil];*/
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                            error:nil];
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]
                         initWithURL:URL
                         settings:recordSettings
                         error:&error];
        _audioRecorder.delegate = self;


        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
            
        } else {
            [_audioRecorder prepareToRecord];
        }
        [_audioRecorder record];
       }
}

#pragma mark - Play Audio

- (void)playAudio:(NSData*)data
{
    
    //URL = [self getAudioUrl];
    
    if (!_audioRecorder.recording)
    {
       /* NSArray *dirPaths;
        NSString *docsDir;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *soundFilePath = [docsDir
                                   stringByAppendingPathComponent:@"sound.caf"];
        
        NSURL* soundFileURL = (__bridge NSURL *)(CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)soundFilePath, NULL));*/
        NSError *error;
       // NSLog(@"Audio Player URL %@", URL);
        
        //NSData *data = [NSData dataWithContentsOfURL:URL];
       // _avaudioPlayer = [[AVAudioPlayer alloc]
                             // initWithContentsOfURL:URL
                         // error:&error];
        
        _avaudioPlayer = [[AVAudioPlayer alloc]
                           initWithData:data error:&error
                           ];


        
        
        if (error)
     NSLog(@"Error: %@",
                [error localizedDescription]);
        else
        {
            _avaudioPlayer.delegate = self;
            [_avaudioPlayer prepareToPlay];
            [_avaudioPlayer play];
        }
        
        
        
        if (_avaudioPlayer.url) {
            [_avaudioPlayer play];
        }
        
    }
}

-(NSURL*)getAudioUrl

{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourDirectory = [documentsDirectory stringByAppendingPathComponent:ROOTFILENAME];
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:yourDirectory error:nil];
    NSURL* soundFileURL;
    
    for(int i = 0; i < [fileList count]; i++)
    {
        NSString *fileName = [fileList objectAtIndex:i];
        NSLog(@"yourFileName:%@",fileName);
        if([fileName isEqualToString:@".aac"])
        {
            NSString *dotDS_StorePath = [NSString stringWithFormat:@"%@/.aac",yourDirectory];
            [[NSFileManager defaultManager] removeItemAtPath:dotDS_StorePath error:nil];
        }
        
        NSString* fileUrlString = [yourDirectory stringByAppendingFormat:@"/%@",fileName];
      // soundFileURL  = (__bridge NSURL *)(CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)fileUrlString, NULL));
        soundFileURL = [NSURL fileURLWithPath:fileUrlString];
    }

   
    return soundFileURL;
    
}

#pragma mark - Stop Recording / Playing

- (void)stopRecording
{
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
    } else if (_avaudioPlayer.playing) {
        [_avaudioPlayer stop];
    }
}

#pragma mark - AVAudioPlayer Delegate Methods

// Called when a sound has finished playing
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    NSLog(@"audioRecorderDidFinishRecording");
    
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end
