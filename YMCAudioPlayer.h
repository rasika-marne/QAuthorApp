//
//  YMCAudioPlayer.h
//  AudioPlayerTemplate
//
//  Created by ymc-thzi on 13.08.13.
//  Copyright (c) 2013 ymc-thzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Constant.h"
@interface YMCAudioPlayer : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
// Public methods
- (void)initPlayer:(NSData*) audioFile fileExtension:(NSString*)fileExtension;
- (void)playAudio;
- (void)pauseAudio;
- (BOOL)isPlaying;
- (void)setCurrentAudioTime:(float)value;
- (float)getAudioDuration;
- (NSString*)timeFormat:(float)value;
- (NSTimeInterval)getCurrentAudioTime;

@end