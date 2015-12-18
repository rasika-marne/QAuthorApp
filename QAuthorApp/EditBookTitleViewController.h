//
//  EditBookTitleViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Book.h"
#import "BookDetails.h"
#import "ChooseTemplateViewController.h"
#import "EditBookViewController.h"
#import "AddBorderViewController.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "CLImageEditor.h"
@class AddBorderViewController;
@class ChooseTemplateViewController;
@class EditBookViewController;
@interface EditBookTitleViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,UIAlertViewDelegate>{
    BOOL textViewBegin,isTitleEdited,isGenreEdited,isDescEdited,isCoverPicEdited;
}
- (IBAction)onCoverPicTapped:(id)sender;
@property (strong,nonatomic)Book *bookObj;
@property (weak, nonatomic) IBOutlet UIImageView *coverPic;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *genreTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (nonatomic, retain) UIPickerView *genreSelect;
@property (nonatomic, retain)  NSMutableArray *pickerData;
@property (nonatomic, strong) ChooseTemplateViewController *chooseTemplateVC;
@property (nonatomic, strong) AddBorderViewController *addBorderVC;
@property (nonatomic, strong) EditBookViewController *editBookVC;
- (IBAction)onSaveButtonClicked:(id)sender;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
- (IBAction)onClickCancel:(id)sender;
@end
