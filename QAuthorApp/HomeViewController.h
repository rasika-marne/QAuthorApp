//
//  HomeViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateBookViewController.h"
#import "BookTitleViewController.h"
#import "Book.h"
#import "BookListTableViewCell.h"
#import "BookDetailsViewController.h"
#import "AppDelegate.h"
#import "AgeRange.h"
#import "BookLikes.h"
#import "Constant.h"
#import "ExcCommentViewController.h"
#import "ChooseTemplateViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@class AgeRange;
@class CreateBookViewController;
@class BookTitleViewController;
@class Book;
@class BookListTableViewCell;
@class BookDetailsViewController;
@class BookLikes;
@class ChooseTemplateViewController;
@interface HomeViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchDisplayDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    NSMutableArray *booksArray,*authorNamesArr,*searchResults,*filterdArray,*bObjectIdArr,*followingsArr;
    Book *bookObj;
    NSInteger likeCount,commentCount;
    NSString *authorName;
    AgeRange *ageRange;
    BOOL myBooksClicked,professionalClicked;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bookSegments;
@property (nonatomic, retain) UIPickerView *ageRangeSelect;
@property (nonatomic, retain)  NSMutableArray *pickerData;
@property (weak, nonatomic) IBOutlet UITextField *ageRangeTextField;
@property (weak, nonatomic) IBOutlet UITableView *bookListTableView;

//@property (nonatomic, strong) CreateBookViewController *createBookVC;
@property (nonatomic, strong) BookTitleViewController *bookTitleVC;
@property (nonatomic, strong) ChooseTemplateViewController *chooseTemplateVC;
@property (nonatomic, strong) BookDetailsViewController *bookDetailVC;
@property (strong,nonatomic) BookListTableViewCell *bookListCell;
-(void)btnLikeClicked:(id)sender;
-(void)btnCommentClicked:(id)sender;
-(void)btnShareClicked:(UIButton *)sender;
-(void)fetchAllBooks;
-(void)fetchMyBooks;
-(void)fetchMyFeeds;
-(void)fetchMyFavorites;
-(void)fetchProfessionalBooks;
-(void)shareOnFacebook;
-(void)shareOnTwitter;
-(void)shareByMail;
- (IBAction)segmentSwitch:(UISegmentedControl *)sender;



@end
