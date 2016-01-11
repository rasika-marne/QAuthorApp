/*
     File: DataViewController.m
 Abstract: The app's view controller which presents viewable content.
  Version: 3.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "DataViewController.h"
#import "PDFView.h"
#import "PDFScrollView.h"
#import "TiledPDFView.h"
#import <UIKit/UIKit.h>
@interface DataViewController ()

@end

@implementation DataViewController
@synthesize audioFile,bookId,bookCreatedBy;
-(void) dealloc {
    if( self.page != NULL ) CGPDFPageRelease( self.page );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationMethod];
    if ([bookCreatedBy isEqualToString:@"WEBAPP"]) {
        self.currentTimeSlider.hidden = YES;
        self.playButton.hidden = YES;
        self.duration.hidden = YES;
        self.timeElapsed.hidden = YES;
    }
    else{
        self.currentTimeSlider.hidden = NO;
        self.playButton.hidden = NO;
        self.duration.hidden = NO;
        self.timeElapsed.hidden = NO;
    }

self.title=[NSString stringWithFormat:@"Page %d",self.pageNumber];
    // [self.view setBackgroundColor: RGB];
    if ([self.audioPlayer isPlaying] == YES) {
        [self.audioPlayer pauseAudio];
    }
   // NSLog(@"book id:%@",bookId);
    NSLog(@"page number:%d",self.pageNumber);
   // bookDetailsArray = [[NSMutableArray alloc]init];
    self.audioPlayer = [[YMCAudioPlayer alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:BOOK_DETAILS];
    [query whereKey:BOOK_ID equalTo:SELECTEDBOOKID];
    [query whereKey:PAGE_NUMBER equalTo:[NSNumber numberWithInt:self.pageNumber]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            BookDetails *bDet = [BookDetails createEmptyObject];
            bDet = [BookDetails convertPFObjectToBookDetails:object];
            NSLog(@"book det audio:%@",bDet.audioContent);
            audioFile = bDet.audioContent;
            [self setupAudioPlayer:audioFile];
        }
    }];
    

	// Do any additional setup after loading the view, typically from a nib.

    self.page = CGPDFDocumentGetPage( self.pdf, self.pageNumber );
    NSLog(@"self.page==NULL? %@",self.page==NULL?@"yes":@"no");

    if( self.page != NULL ) CGPDFPageRetain( self.page );
    [self.scrollView setPDFPage:self.page];
}
-(void)navigationMethod{
   // [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.title=[NSString stringWithFormat:@"Page %d",self.pageNumber];
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
 * Setup the AudioPlayer with
 * Filename and FileExtension like mp3
 * Loading audioFile and sets the time Labels
 */
- (void)setupAudioPlayer:(PFFile*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"caf";
    [fileName getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self.audioPlayer initPlayer:data fileExtension:fileExtension];
        self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
        
        //init the current timedisplay and the labels. if a current time was stored
        //for this player then take it and update the time display
        self.timeElapsed.text = @"0:00";
        
        self.duration.text = [NSString stringWithFormat:@"-%@",
                              [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    }];
    //init the Player to get file properties to set the time labels
   
    
}

/*
 * PlayButton is pressed
 * plays or pauses the audio and sets
 * the play/pause Text of the Button
 */
- (IBAction)playRecordedAudioFile:(id)sender {
    
    [self listenAudio];
}
#pragma mark - Listen Audio

-(void)listenAudio
{
    if (!self.audioPlayerObject) {
        self.audioPlayerObject = [[StoryAudioPlayer alloc]init];
    }
    
    //UInt32 audioEffect;
   // NSString* audioUrlString = [kUserDefaults getAudioFilePathName];
    NSString* audioUrlString = audioFile.url;
    [audioFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        NSURL* soundURL;
        
        if (self.storySoundFilePath.length>0) {
            soundURL  = [NSURL fileURLWithPath:self.storySoundFilePath];
        }
        else if(audioUrlString.length>0)
        {
            soundURL  = [NSURL fileURLWithPath:audioUrlString];
        }
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        AudioServicesDisposeSystemSoundID(audioEffect);
        [self.audioPlayerObject playAudio:data];
    }];
   
    //self.isForRecordAudio = NO;
}

#pragma mark - Stop Audio Recording / Playing

-(void)stop
{
    
    //[self.recordAudioButton setBackgroundImage:[UIImage imageNamed:RECORD_AUDIO_BUTTON] forState:UIControlStateNormal];
   // self.playButton.hidden = NO;
    if (!self.audioPlayerObject) {
        self.audioPlayerObject = [[StoryAudioPlayer alloc]init];
    }
    [self.audioPlayerObject stopRecording];
    //self.isForRecordAudio = YES;
}

- (IBAction)playAudioPressed:(id)playButton
{
   
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"ic_pause_circle_outline"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        self.isPaused = TRUE;
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Updates the time label display and
 * the current value of the slider
 * while audio is playing
 */
- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    self.timeElapsed.text = [NSString stringWithFormat:@"%@",
                             [self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]]];
    
    self.duration.text = [NSString stringWithFormat:@"-%@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration] - [self.audioPlayer getCurrentAudioTime]]];
    
    //When resetted/ended reset the playButton
    if (![self.audioPlayer isPlaying]) {
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = FALSE;
    }
}

/*
 * Sets the current value of the slider/scrubber
 * to the audio file when slider/scrubber is used
 */
- (IBAction)setCurrentTime:(id)scrubber {
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
    self.scrubbing = FALSE;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}




-(void)viewWillAppear:(BOOL)animated {
    // Disable zooming if our pages are currently shown in landscape
   // [self.scrollView setUserInteractionEnabled:YES];
    if( [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ) {
        [self.scrollView setUserInteractionEnabled:YES];
    } else {
        [self.scrollView setUserInteractionEnabled:NO];
    }
    NSLog(@"%s scrollView.zoomScale=%f",__PRETTY_FUNCTION__,self.scrollView.zoomScale);
}

-(void)viewDidLayoutSubviews {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self restoreScale];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if( fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
        [self.scrollView setUserInteractionEnabled:NO];
    } else {
        [self.scrollView setUserInteractionEnabled:YES];
    }
}

-(void)restoreScale {
    // Called on orientation change.
    // We need to zoom out and basically reset the scrollview to look right in two-page spline view.
    CGRect pageRect = CGPDFPageGetBoxRect( self.page, kCGPDFMediaBox );
    CGFloat yScale = self.view.frame.size.height/pageRect.size.height;
    CGFloat xScale = self.view.frame.size.width/pageRect.size.width;
    self.myScale = MIN( xScale, yScale );
    NSLog(@"%s self.myScale=%f",__PRETTY_FUNCTION__, self.myScale);
    self.scrollView.bounds = self.view.bounds;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.PDFScale = self.myScale;
    self.scrollView.tiledPDFView.bounds = self.view.bounds;
    self.scrollView.tiledPDFView.myScale = self.myScale;
    [self.scrollView.tiledPDFView.layer setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
