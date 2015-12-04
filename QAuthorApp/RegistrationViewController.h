//
//  RegistrationViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 9/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "User.h"
#import "ViewController.h"
#import "editProfileCustomeCell.h"
@class ViewController;
@interface RegistrationViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>{
    int movementDistance;
    BOOL countrySelected,authorSelected;
    NSMutableArray *userIdArr,*authorNameArr;
    NSInteger selectedIndex;
    NSString *fbName,*fbEmail,*fbPicUrl,*fbId,*fbFName,*fbLName;
    UIImage *fbImage;
    
}
@property (weak, nonatomic) IBOutlet UITableView *registrationTableView;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) UIPickerView *authorSelect;
@property (nonatomic, retain) UIPickerView *countrySelect;
@property (nonatomic, readwrite)  BOOL isFacebookLogin;
@property (nonatomic, retain)  NSArray *pickerData;
@property (nonatomic, retain)  NSDictionary *fbData;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImg;
@property (weak, nonatomic) IBOutlet UIButton *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *languageTextField;
@property (weak, nonatomic) IBOutlet UITextField *favAuth1TextField;
@property (weak, nonatomic) IBOutlet UITextField *favAuth2TextField;
@property (weak, nonatomic) IBOutlet UITextField *favAuth3TextField;
@property (weak, nonatomic) IBOutlet UITextField *nwAuth1TextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassTextField;
@property (strong,nonatomic) editProfileCustomeCell *cell;
@property (weak, nonatomic) IBOutlet UITextField *nwAuth2TextField;
@property (strong,nonatomic)NSString *txtEmailId,*txtPassword,*txtAge,*txtCity,*txtCountry,*txtLang,*txtfavAuth1,*txtFavAuth2,*txtFavAuth3,*txtNewAuth1,*txtNewAuth2,*txtConfirmPass,*txtFirstName,*txtLastName;

- (IBAction)onProfilePhotoTap:(id)sender;
- (IBAction)onRegistrationButtonClick:(id)sender;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
