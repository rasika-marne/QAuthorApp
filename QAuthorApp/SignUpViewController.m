//
//  SignUpViewController.m
//  QAuthorApp
//
//  Created by Pooja on 10/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


- (IBAction)onClickSignupwithEmail:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.registrationView = (RegistrationViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self.navigationController pushViewController:self.registrationView animated:YES];
}

- (IBAction)onClickLoginBtn:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = (ViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:self.viewController animated:YES];
}
@end
