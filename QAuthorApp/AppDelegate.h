//
//  AppDelegate.h
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Constant.h"
#import "HomeViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
//#import "MenuViewController.h"
#import "EditProfileViewController.h"
#import <netinet/in.h>
#import <sys/socket.h>

#import <SystemConfiguration/SystemConfiguration.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <PFFacebookUtils.h>
//#import <FacebookSDK/FacebookSDK.h>
@class ViewController;
@class HomeViewController;
@class User;
@class EditProfileViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) EditProfileViewController *editVC;
@property (strong, nonatomic) UINavigationController *uniNavController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UINavigationController *homeNavigationController;

@property (strong, nonatomic) UINavigationController *profileNavigationController;
@property (strong, nonatomic) UINavigationController *menuNavigationController;

@property (strong,nonatomic)User *loggedInUser;
@property(nonatomic,strong) NSDictionary *dictUserInfo;
-(void)saveLoggedInUserId:(NSString*)userId andPwd:(NSString*)pwd andUserName:(NSString*)name;

-(void)clearLoggedInUserDetail;
-(void)logout;
//-(UIView *)viewForActivityIndicator;

@property(nonatomic,strong) MBProgressHUD* activitityIndicator;
@property (strong, nonatomic) UIActivityIndicatorView *indictaor;
- (void)startActivityIndicator:(UIView *)view;
- (void)stopActivityIndicator;
-(BOOL)hasConnectivity;


-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;
@end
