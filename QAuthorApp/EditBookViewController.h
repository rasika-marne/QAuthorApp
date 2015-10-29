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
#import <QuartzCore/QuartzCore.h>
#import "CLImageEditor.h"
@interface EditBookViewController : UIViewController<CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    int count;
    NSMutableArray *bookDetailsArr;
}
@property (weak, nonatomic) IBOutlet UIView *viewForPdf;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
- (IBAction)onPhotoTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (strong,nonatomic)NSString *bookId;
- (IBAction)onNextPageClicked:(id)sender;
- (IBAction)onSaveButtonClicked:(id)sender;

@end
