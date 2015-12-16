//
//  ViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "HomeViewController.h"
#import "RegistrationViewController.h"

#import "SWRevealViewController.h"



#import <UIKit/UIKit.h>

#import "AppDelegate.h"
//#import <FacebookSDK/FacebookSDK.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
@class HomeViewController;
@class RegistrationViewController;
@interface ViewController : UIViewController<UIAlertViewDelegate,SWRevealViewControllerDelegate>{
      NSString *USER_FB_ID_STR, *USER_FB_EMAIL_STR;
    int movementDistance;
}


//@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswrdTextField;
@property (nonatomic, strong) HomeViewController *homeVC;
@property (nonatomic, strong) RegistrationViewController *registartionVC;

- (IBAction)onClickSignIn:(id)sender;
- (IBAction)onClickForgotPassword:(id)sender;

-(void)showAlerForParseError:(NSError*)error;
@end

