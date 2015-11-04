//
//  SignUpViewController.h
//  QAuthorApp
//
//  Created by Pooja on 10/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RegistrationViewController.h"
@class ViewController;
@interface SignUpViewController : UIViewController<FBLoginViewDelegate>

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) RegistrationViewController *registrationView;
- (IBAction)onclickFacebookConnect:(id)sender;
- (IBAction)onClickSignupwithEmail:(id)sender;
- (IBAction)onClickLoginBtn:(id)sender;

@end
