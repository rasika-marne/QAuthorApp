//
//  EditProfileViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 9/30/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "editProfileCustomeCell.h"
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "User.h"
@class User;
@interface EditProfileViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    User *user;
    int movementDistance;
     NSMutableArray *userIdArr,*authorNameArr;
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *editProfileTableView;
@property (nonatomic, retain) UIPickerView *countrySelect;
@property (nonatomic, retain) UIPickerView *authorSelect;
@property (nonatomic, retain)  NSArray *pickerData;

@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *editProfilePic;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *langTextField;
@property (weak, nonatomic) IBOutlet UITextField *favAuth1TextField;
@property (weak, nonatomic) IBOutlet UITextField *favAuth2TextField;
@property (weak, nonatomic) IBOutlet UITextField *favAuth3TextField;
@property (weak, nonatomic) IBOutlet UITextField *nwAuth1TextField;
@property (weak, nonatomic) IBOutlet UITextField *nwAuth2TextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassTextField;
@property (strong,nonatomic)NSString *txtEmailId,*txtPassword,*txtAge,*txtCity,*txtCountry,*txtLang,*txtfavAuth1,*txtFavAuth2,*txtFavAuth3,*txtNewAuth1,*txtNewAuth2,*txtConfirmPass,*txtFirstName,*txtLastName;
@property (strong,nonatomic) editProfileCustomeCell *cell;
- (IBAction)onProfilePhotoTap:(id)sender;
- (IBAction)onSaveButtonClick:(id)sender;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
