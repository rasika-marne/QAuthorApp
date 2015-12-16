//
//  ViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "ViewController.h"
#import "RearViewController.h"
#define kOFFSET_FOR_KEYBOARD 200.0
@interface ViewController ()

@end

@implementation ViewController
@synthesize userNameTextField,pswrdTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMethod];
    [self.view setBackgroundColor: RGB];
   
        //self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [PFUser logOut];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    UIImage *myImage = [UIImage imageNamed:@"back"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    
    
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)backButtonClicked :(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//-(void)viewWillAppear:(BOOL)animated{
    // register for keyboard notifications
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}*/

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    // if ([sender isEqual:mailTf])
    // {
    //move the main view, so that the keyboard does not hide it.
    
    //textViewBegin = NO;
    sender.text = @"";
    [self animateTextField: sender up: YES];
   // if  (self.view.frame.origin.y >= 0)
   // {
      //  [self setViewMovedUp:YES];
   // }
    // }
}
- (void)animateTextField:(UITextField*)textField up:(BOOL)up {
    
    if (textField.tag == 1) {
        if (IPAD) {
            movementDistance = 150;
        }
        else
            movementDistance = 80;
        
        
    }
    else if (textField.tag == 2) {
        if (IPAD) {
            movementDistance = 170;
        }
        else
            movementDistance = 100;
        //movementDistance = 170;
    }
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[self animateTextField: textField up: NO];
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    [self animateTextField: textField up: NO];
    
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
                [defaults setValue:APP_DELEGATE.loggedInUser.objectId forKey:USER_ID];
                 [defaults setValue:@"Yes" forKey:@"LoginUserSucessFlag"];
                
                [defaults synchronize];
                                NSLog(@"user:%@",APP_DELEGATE.loggedInUser);
                [APP_DELEGATE saveLoggedInUserId:APP_DELEGATE.loggedInUser.objectId andPwd:[self.pswrdTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET] andUserName:[self.userNameTextField.text stringByTrimmingCharactersInSet:TRIM_CHARACTER_SET]];
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
            
            if ([[alertView textFieldAtIndex:0].text length]==0){
                
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Email id sohouldn't be null" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
            }else if ([self NSStringIsValidEmail:[alertView textFieldAtIndex:0].text]==NO){
                
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid email id" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
                
            }else {
                [PFUser requestPasswordResetForEmailInBackground: [alertView textFieldAtIndex:0].text];
            }
            
        }
    }
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)onClickSignUp:(id)sender{
    UIStoryboard *storyboard;
    if (IPAD) {
        storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
    }
    else
        storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    //UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.registartionVC = (RegistrationViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    
    [self.navigationController pushViewController:self.registartionVC animated:YES];
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        
        
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
        
        
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.title=@"Login";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
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
