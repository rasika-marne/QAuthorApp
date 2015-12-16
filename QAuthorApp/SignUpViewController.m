//
//  SignUpViewController.m
//  QAuthorApp
//
//  Created by Pooja on 10/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "SignUpViewController.h"
#import "RearViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    emailIdArr = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *obj in objects) {
                NSString *emailId = [obj objectForKey:USERNAME];
                NSLog(@"email:%@",emailId);
                [emailIdArr addObject:emailId];
            }
             NSLog(@"email:%@",emailIdArr);
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self navigationMethod ];

}
-(void)navigationMethod{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.title=@"Sign Up";
    
    //UIImage *image = [UIImage imageNamed:@"nav-bar"];
    // self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:17.00 green:65.00 blue:95.00 alpha:1.0];
    [self.view setBackgroundColor: RGB]; //will give a UIColor

    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;

    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
#pragma mark
#pragma mark ======================= LoginWithFacebookBtn =============================

- (IBAction)onclickFacebookConnect:(id)sender {
    [self facebookSignIn];
    
    /*
     if(![APP_DELEGATE hasConnectivity]) {
     
     UIAlertView *customAlertView = [[UIAlertView alloc]initWithTitle:@"alert" message:@"Network connection not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
     [customAlertView show];
     return;
     }
     else {
     
     [[FacebookClass getObject] facebookLogout];
     NSArray *_permissions = [NSArray arrayWithObjects:nil];
     Facebook *_facebook = [[Facebook alloc] init];
     [[FacebookClass getObject] set_facebook:_facebook];
     // Method to ask user permissions and login.
     [[[FacebookClass getObject] _facebook] authorize:FbClientID permissions:_permissions delegate:self];
     if (_permissions!=nil) { }
     }*/
}
-(void)facebookSignIn
{
     NSArray *permissionsArray = @[ @"public_profile", @"email"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            flag = 1;
             NSLog(@"user:%@",user.email);
            [self getFbData];
            NSLog(@"User signed up and logged in through Facebook!");
            
        } else {
            NSLog(@"User logged in through Facebook!:%@",user);
            flag = 2;
            NSLog(@"user:%@",user.email);
            [self getFbData];
            /*if (![PFFacebookUtils isLinkedWithUser:user]) {
                [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Woohoo, user is linked with Facebook!");
                    }
                }];
            }*/

            //[self login:(User *)user];
            
        }
    }];

}
-(void)getFbData{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name, last_name, picture, email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            NSLog(@"result:%@",result);
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
          //  NSString *facebookID = userData[@"id"];
           
           // NSString *email = userData[@"email"];
           //  NSString *name = userData[@"name"];
            
           /* if (flag == 1) {
                UIStoryboard *storyboard;
                if (IPAD) {
                    storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
                }
                else
                    storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                self.registrationView = (RegistrationViewController *)
                [storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
                self.registrationView.isFacebookLogin = YES;
                self.registrationView.fbData = userData;
                [self.navigationController pushViewController:self.registrationView animated:YES];
            }*/
                       // Now add the data to the UI elements
            // ...
        }
    }];
}
/*-(void)facebookSignIn
{
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
 
        [APP_DELEGATE openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
    }
    else{
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
        HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    
    //    [FBSession.activeSession closeAndClearTokenInformation];
    //
    //    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
    //                                       allowLoginUI:YES
    //                                      completionHandler:
    //         ^(FBSession *session, FBSessionState state, NSError *error) {
    //             [self sessionStateChanged:session state:state error:error];
    //         }];
}*/

/*-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    
    
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen) {
            
            
            [FBRequestConnection startWithGraphPath:@"me?fields=id,name,hometown,birthday,picture{url},email"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error)
                                      {
                                          NSString *fbEmail;
                                          NSLog(@"result : %@",result);
                                          fbId = [result objectForKey:@"id"];
                                           fbEmail = [result objectForKey:@"email"];
                                          for (int i=0; i<[emailIdArr count]; i++) {
                                            
                                              NSLog(@"fbemail:%@",fbEmail);
                                              if ([fbEmail isEqualToString:[emailIdArr objectAtIndex:i]]) {
                                                  flag = 1;
                                                  break;
                                              }
                                              
                                          }
                                          if (flag == 1) {
                                              PFQuery *query = [PFUser query];
                                              [query whereKey:USERNAME equalTo:fbEmail];
                                              [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                                  if (!error) {
                                                      User *userObj = [User createEmptyUser];
                                                      userObj = [User convertPFObjectToUser:object forNote:YES];
                                                      NSLog(@"email:%@",userObj.username);
                                                      NSLog(@"passwrd:%@",userObj.password);
                                                     // APP_DELEGATE.loggedInUser = userObj;
                                                      //NSString *fbid =[result objectForKey:@"id"];
                                                      //[userObj setObject:fbid forKey:FACEBOOK_ID];
                                                      //[userObj updateUserblock:^(id object, NSError *error) {
                                                         // if (!error) {
                                                              [self login:userObj];
                                                         // }
                                                     // }];
                                                      
                                                      
                                                      
                                                  }
                                              }];
                                          }
                                          else
                                          {
                                              UIStoryboard *storyboard;
                                              if (IPAD) {
                                                  storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
                                              }
                                              else
                                                  storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                              self.registrationView = (RegistrationViewController *)
                                              [storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
                                              self.registrationView.isFacebookLogin = YES;
                                              self.registrationView.fbData = (NSDictionary *)result;
                                              [self.navigationController pushViewController:self.registrationView animated:YES];
                                          }
                                         
                                      }
                                      else{
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
            
            
            
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
            
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}*/

-(void)login :(User *)user
{
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    [user loginblock:^(id object, NSError *error) {
        
        if (object) {
            DLog(@"Login Success");
            APP_DELEGATE.loggedInUser = (User*)object;
            [object setObject:fbId forKey:FACEBOOK_ID];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [APP_DELEGATE stopActivityIndicator];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:APP_DELEGATE.loggedInUser.objectId forKey:USER_ID];
                    [defaults setValue:@"Yes" forKey:@"LoginUserSucessFlag"];
                    
                    [defaults synchronize];
                    NSLog(@"user:%@",APP_DELEGATE.loggedInUser);
                    //  [APP_DELEGATE saveLoggedInUserId:APP_DELEGATE.loggedInUser.objectId andPwd:[self.pswrdTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET] andUserName:[self.userNameTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET]];
                    NSString *userName = [NSString stringWithFormat:@"%@ %@",[object valueForKey:@"firstName"],[object valueForKey:@"lastName"]];
                    [[NSUserDefaults standardUserDefaults]setValue:userName forKey:@"UserName"];
                    
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation setObject:APP_DELEGATE.loggedInUser.objectId forKey:@"userId"];
                    [currentInstallation saveInBackground];
                    UIStoryboard *storyboard;
                    if (IPAD) {
                        storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
                    }
                    else
                        storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    // UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    HomeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                    RearViewController *rearViewController = [[RearViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nav frontViewController:frontNavigationController];
                    revealController.delegate = self;
                    [self presentViewController:revealController animated:NO completion:nil];
                    
                    

                }
            }];
                        // [APP_DELEGATE tabBarSetup];
            //  [self.navigationController pushViewController:self.homeVC animated:YES];
            // [APP_DELEGATE.window setRootViewController:APP_DELEGATE.tabBarController];
        }
    }];

}
- (IBAction)onClickSignupwithEmail:(id)sender {
    UIStoryboard *storyboard;
    if (IPAD) {
        storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
    }
    else
        storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

   // UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.registrationView = (RegistrationViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self.navigationController pushViewController:self.registrationView animated:YES];
}

- (IBAction)onClickLoginBtn:(id)sender {
    UIStoryboard *storyboard;
    if (IPAD) {
        storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
    }
    else
        storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    //UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = (ViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:self.viewController animated:YES];
}
@end
