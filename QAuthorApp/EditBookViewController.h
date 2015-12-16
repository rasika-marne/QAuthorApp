//
//  EditBookViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "BookDetails.h"
#import <CoreText/CoreText.h>
#import "StoryAudioPlayer.h"
#import <QuartzCore/QuartzCore.h>
#import "CLImageEditor.h"
#import "NSUserDefaults+StoryData.h"
#import "SaveFile.h"
#import "Book.h"
#import "AddBorderViewController.h"
#import "ChooseTemplateViewController.h"
@class AddBorderViewController;
@class ChooseTemplateViewController;
@class Book;
@interface EditBookViewController : UIViewController<CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    int count,pageNumber;
    NSMutableArray *bookDetailsArr,*pagePDFArr;
    UITextView* activeTextView;
    BOOL isImageEdited;
   

}
@property (weak, nonatomic) IBOutlet UIButton *imageClickbutton;
@property (weak, nonatomic) IBOutlet UIImageView *borderImage;
@property (weak, nonatomic) IBOutlet UIView *viewForPdf;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIButton *recordAudioButton;
@property (nonatomic, strong) AddBorderViewController *addBorderVC;
@property (nonatomic, strong) ChooseTemplateViewController *chooseTemplateVC;

@property (strong,nonatomic)Book *bookObj1;
- (IBAction)onPhotoTap:(id)sender;
@property (nonatomic, strong) StoryAudioPlayer *audioPlayerObject;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (strong,nonatomic)NSString *bookId;
@property (nonatomic, strong) NSString* storySoundFilePath;
@property (nonatomic, strong) NSString* storyId;
- (IBAction)onNextPageClicked:(id)sender;
- (IBAction)onSaveButtonClicked:(id)sender;
- (IBAction)recordAudio:(id)sender;
@end
