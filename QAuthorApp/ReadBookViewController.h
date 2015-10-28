//
//  ReadBookViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/15/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"
#import "Book.h"
#import "BookDetails.h"
#import "DataViewController.h"
@class YMCAudioPlayer;
@interface ReadBookViewController : UIViewController<UIPageViewControllerDelegate>{
    BookDetails *bookDet;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) YMCAudioPlayer *audioPlayer;

@property (nonatomic, strong) Book* bookObj2;
@property (nonatomic, strong) NSMutableArray *bookDetailsArray;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *audioSlider;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeElapsedLbl;



@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;
@end
