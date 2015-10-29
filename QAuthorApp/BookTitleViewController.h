//
//  BookTitleViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/1/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateBookViewController.h"
#import "Book.h"
#import "User.h"
#import "AgeRange.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "CLImageEditor.h"

#import "ChooseTemplateViewController.h"
@class CreateBookViewController;
@class Book;
@class User;
@class AgeRange;
@class ChooseTemplateViewController;
@interface BookTitleViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,UINavigationControllerDelegate>
{
    Book *book;
    User *user;
    AgeRange *ageRange;
    BOOL ownPhotoTap;
   // NSMutableArray *genreArr;
}
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *templateButton;
@property (weak, nonatomic) IBOutlet UIButton *ownPhoto;
- (IBAction)onClickChooseTemplate:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *BackImage;
@property (nonatomic, retain) UIPickerView *genreSelect;
@property (nonatomic, retain)  NSMutableArray *pickerData;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLbl;
@property (strong, nonatomic) UIImage *backImg1;
@property (weak, nonatomic) IBOutlet UIImageView *authorImg;
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImg;
@property (weak, nonatomic) IBOutlet UITextField *bookTitleTextField;
@property (nonatomic, strong) CreateBookViewController *createBookVC;
@property (nonatomic, strong) ChooseTemplateViewController *chooseTemplateVC;
@property (weak, nonatomic) IBOutlet UITextField *shortDescTextField;
@property (weak, nonatomic) IBOutlet UITextField *genreTextField;
@property (weak, nonatomic) IBOutlet UITextView *shortDescTextView;

- (IBAction)onNextButtonClick:(id)sender;
- (IBAction)onPhotoTap:(id)sender;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
