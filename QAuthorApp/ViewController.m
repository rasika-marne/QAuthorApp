//
//  ViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "ViewController.h"
#import "RearViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize userNameTextField,pswrdTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];

    //self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [PFUser logOut];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onClickSignIn:(id)sender
{
    [PFUser logOut];
    if ([self.userNameTextField.text isEqualToString:@""] && [self.pswrdTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please enter username and password."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else{
    User *user=[User createEmptyUser];
    user.email=[self.userNameTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET];
    user.password=[self.pswrdTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET];
    user.username=[self.userNameTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET];
      
   /* [PFUser logInWithUsernameInBackground:userNameTextField.text password:pswrdTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (!error) {
                                            APP_DELEGATE.loggedInUser = (User*)user;
                                          
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setValue:@"YES" forKey:@"LoginSuccessFlag"];

                                            [defaults synchronize];
                                            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            self.homeVC = (HomeViewController *)
                                            [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                                            [APP_DELEGATE tabBarSetup];
                                            //[self.navigationController pushViewController:self.homeVC animated:YES];
                                            [APP_DELEGATE.window setRootViewController:APP_DELEGATE.tabBarController];

                                            // Do stuff after successful login.
                                        } else {
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setValue:@"NO" forKey:@"LoginSuccessFlag"];
                                            [defaults synchronize];
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                            message:@"Incorrect username/password."
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil];
                                            [alert show];
 
                                            // The login failed. Check error to see why.
                                        }
                                    }];*/
         [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
        [user loginblock:^(id object, NSError *error) {
           
            if (object) {
                DLog(@"Login Success");
                APP_DELEGATE.loggedInUser = (User*)object;

                [APP_DELEGATE stopActivityIndicator];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:APP_DELEGATE.loggedInUser.objectId forKey:@"userId"];
                 [defaults setValue:@"Yes" forKey:@"LoginUserSucessFlag"];
                
                [defaults synchronize];
                                NSLog(@"user:%@",APP_DELEGATE.loggedInUser);
                [APP_DELEGATE saveLoggedInUserId:APP_DELEGATE.loggedInUser.objectId andPwd:[self.pswrdTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET] andUserName:[self.userNameTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET]];
                NSString *userName = [NSString stringWithFormat:@"%@ %@",[object valueForKey:@"firstName"],[object valueForKey:@"lastName"]];
                [[NSUserDefaults standardUserDefaults]setValue:userName forKey:@"UserName"];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:APP_DELEGATE.loggedInUser.objectId forKey:@"userId"];
                [currentInstallation saveInBackground];
                
                UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                self.homeVC = (HomeViewController *)
                [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
                RearViewController *rearViewController = [[RearViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nav frontViewController:frontNavigationController];
                revealController.delegate = self;
                [self presentViewController:revealController animated:NO completion:nil];
                

               // [APP_DELEGATE tabBarSetup];
              //  [self.navigationController pushViewController:self.homeVC animated:YES];
               // [APP_DELEGATE.window setRootViewController:APP_DELEGATE.tabBarController];
            }else{
                [self showAlerForParseError:error];
                
                //[self showAlertViewWithTitle:@"Failed" message:[error.userInfo objectForKey:@"error"]   delegate:nil positiveButtonTitle:@"YES" cancelButtonTitle:nil];
            }
        }];

    }
}
- (IBAction)onClickForgotPassword:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Please Enter email id below."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = 11;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex == 0) {
            [PFUser requestPasswordResetForEmailInBackground: [alertView textFieldAtIndex:0].text];
            
        }
    }
    
}
- (IBAction)onClickSignUp:(id)sender{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.registartionVC = (RegistrationViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    
    [self.navigationController pushViewController:self.registartionVC animated:YES];
}

#pragma mark
#pragma mark ======================= LoginWithFacebookBtn =============================

- (IBAction)onClickFacebookLogin:(id)sender{
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
}

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    
    
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen) {
            
            
            [FBRequestConnection startWithGraphPath:@"me?fields=id,name,email,gender,birthday,location"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error)
                                      {
                                          NSLog(@"result : %@",result);
                                          HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                                          
                                          [self.navigationController pushViewController:vc animated:NO];
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
}
#pragma mark - Parse Error Alert

-(void)showAlerForParseError:(NSError*)error{
    [APP_DELEGATE stopActivityIndicator];
    if (error.code==kPFErrorInternalServer) {
        
        DLog(@"Internal Server Error");
        [self showAlertViewWithTitle:@"" message:@"Internal Server Error"   delegate:nil positiveButtonTitle:@"OK" cancelButtonTitle:nil];
    }else if(error.code==kPFErrorConnectionFailed){
        [self showAlertViewWithTitle:@"" message:@"Please check your internet connection"   delegate:nil positiveButtonTitle:@"OK" cancelButtonTitle:nil];
        
    }else if(error.code==kPFErrorTimeout){
        [self showAlertViewWithTitle:@"" message:@"Request timed out on the server"   delegate:nil positiveButtonTitle:@"OK" cancelButtonTitle:nil];
        
    }else if(error.code==kPFErrorInvalidQuery){
        DLog(@"Query is Invalid");
    }else if(error.code==kPFErrorInvalidClassName){
        DLog(@"Class Name is Invalid");
    }else if(error.code==kPFErrorObjectNotFound){
        [self showAlertViewWithTitle:@"Alert" message:@"Please enter valid login credentials."   delegate:nil positiveButtonTitle:@"OK" cancelButtonTitle:nil];
        
    }else if(error.code==kPFErrorInvalidEmailAddress)
    {
        [self showAlertViewWithTitle:@"Alert" message:@"Notes that you purchase will be sent to your email address. Please enter appropriate email format."  delegate:nil positiveButtonTitle:@"OK" cancelButtonTitle:nil];
    }else{
        [self showAlertViewWithTitle:@"Failed" message:[error.userInfo objectForKey:@"error"]   delegate:nil positiveButtonTitle:@"OK" cancelButtonTitle:nil];
    }
}

#pragma mark - Show Alert View

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate positiveButtonTitle:(NSString *)positiveButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:positiveButtonTitle, nil];
    [alertView show];
}

@end