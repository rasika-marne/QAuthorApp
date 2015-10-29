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
@interface EditBookTitleViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)onCoverPicTapped:(id)sender;
@property (strong,nonatomic)Book *bookObj;
@property (weak, nonatomic) IBOutlet UIImageView *coverPic;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *genreTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (nonatomic, retain) UIPickerView *genreSelect;
@property (nonatomic, retain)  NSMutableArray *pickerData;
- (IBAction)onSaveButtonClicked:(id)sender;

@end
