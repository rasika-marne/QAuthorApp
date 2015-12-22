//
//  CreateBookViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryAudioPlayer.h"
#import "NSUserDefaults+StoryData.h"
#import "SaveFile.h"
#import <MessageUI/MessageUI.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AddBorderViewController.h"
#import "ChooseTemplateViewController.h"
#import "HomeViewController.h"
//#import "ViewBookViewController.h"
#import "Constant.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "CLImageEditor.h"
#import "Book.h"
#import "BookDetails.h"
@class Book;
@class BookDetails;
@class AddBorderViewController;
@class HomeViewController;
@interface CreateBookViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>{
    int count;
    UITextView* activeTextView;
    BOOL m_bPhotoWasChanged,isImageEdited,isImageSelected,isTextSelected;

}
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIButton *m_oImage;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (nonatomic, strong) Book* bookObj;
@property (nonatomic, strong) BookDetails* bookDetailsObj;
@property (strong, nonatomic) UIImage *backImg1;
- (IBAction)onClickExportBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (nonatomic, strong) StoryAudioPlayer *audioPlayerObject;
@property (nonatomic, strong) AddBorderViewController *addBorderVC;
@property (nonatomic, strong) ChooseTemplateViewController *chooseTemplateVC;
@property (nonatomic, strong) HomeViewController *homeVC;
@property (weak, nonatomic) IBOutlet UILabel *chooseOwnLbl;

@property (nonatomic, strong) NSString* storySoundFilePath;
@property (weak, nonatomic) IBOutlet UIView *ViewToPDF;
@property (weak, nonatomic) IBOutlet UIButton *recordAudioButton;
@property (strong, nonatomic) IBOutlet UIButton *listenRecorAudioButton;
@property (nonatomic, strong) NSString* storyId;
@property (nonatomic, strong) NSString* textContent;
//@property (nonatomic, strong) NSString* audioContent;
//-(void)drawPDF:(NSString*)fileName;
- (IBAction)onClickAddPagesBtn:(id)sender;
- (IBAction)onFinishBookBtn:(id)sender;
- (IBAction)recordAudio:(id)sender;

- (IBAction)viewBookBtnClick:(id)sender;
- (IBAction)onPhotoTap:(id)sender;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
