//
//  BookDetailsViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/8/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Book.h"
#import <MessageUI/MessageUI.h>
#import "ReadBookViewController.h"
@class Book;
@class ReadBookViewController;
@interface BookDetailsViewController : UIViewController<MFMailComposeViewControllerDelegate,GADInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *bookGenreLbl;
@property (weak, nonatomic) IBOutlet UILabel *bookDescLbl;
@property (nonatomic, strong) ReadBookViewController *readBookVC;
@property (nonatomic, strong) Book* bookObj1;
@property (nonatomic, strong) NSString* authorName;
- (IBAction)onReadBookButtonClick:(id)sender;
- (IBAction)onDownloadBookButtonClick:(id)sender;
- (void)showEmail:(NSString*)file;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLbl;

@end
