//
//  RegistrationViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 9/28/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize pickerData,countrySelect,authorSelect,isFacebookLogin,fbData,userId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMethod];
     [self.view setBackgroundColor: RGB];
    if (isFacebookLogin == YES) {
       // fbName = [fbData objectForKey:@"name"];
       // NSArray *arr = [fbName componentsSeparatedByString:@" "];
        fbFName = [fbData objectForKey:@"first_name"];
        fbLName = [fbData objectForKey:@"last_name"];

        fbEmail = [fbData objectForKey:@"email"];
        fbId = [fbData objectForKey:@"id"];
        NSDictionary *data = [fbData objectForKey:@"picture"];
        NSDictionary *data1 = [data objectForKey:@"data"];
        fbPicUrl = [data1 objectForKey:@"url"];
        NSURL *url = [NSURL URLWithString:fbPicUrl];
        fbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        self.profilePicImg.image = fbImage;
    }
    authorNameArr = [[NSMutableArray alloc]init];
    [authorNameArr addObject:@"Other"];
    NSMutableArray * countriesArray = [[NSMutableArray alloc] init];
    //[countriesArray addObject:@"Other"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    for (NSString *countryCode in countryArray)
    {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        [countriesArray addObject:displayNameString];
        
    }
    pickerData = countriesArray;
    
    countrySelect = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    countrySelect.showsSelectionIndicator = YES;
    countrySelect.tag = 11;
    // languageSelect.hidden = NO;
    countrySelect.delegate = self;
    
    
    authorSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    authorSelect.showsSelectionIndicator = YES;
    authorSelect.tag = 12;
    // languageSelect.hidden = NO;
    authorSelect.delegate = self;
    // Do any additional setup after loading the view.
}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Registration";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    UIImage *myImage = [UIImage imageNamed:@"back"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    
    
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
   
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (void)backButtonClicked :(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    PFQuery *query1 = [PFQuery queryWithClassName:@"FavoriteAuthor"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                [authorNameArr addObject:[obj objectForKey:@"authorName"]];
            }
            NSLog(@"authornames:%@",authorNameArr);
        }
    }];
}

#pragma mark -
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 14;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"editProfileCustomeCell";
   // NSString *CellIdentifier = [NSString stringWithFormat:@"%d,%d",indexPath.section,indexPath.row];

   editProfileCustomeCell *cell = (editProfileCustomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"editProfileCustomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor clearColor];
    [tableView setBackgroundView:bview];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if(indexPath.row ==0)
    {
        cell.editTxtFld.tag=indexPath.row;
        
        if (isFacebookLogin == YES) {
           // self.cell.userInteractionEnabled = NO;
            cell.editTxtFld.text = fbFName;
        }
        else
        {
            cell.editTxtFld.placeholder=@"First name*";
            
        }
        cell.iconImage.image=[UIImage imageNamed:@"user-icon"];
        
        
    } else if (indexPath.row ==1) {
        
        cell.editTxtFld.tag=indexPath.row;
        if (isFacebookLogin == YES) {
          //  self.cell.userInteractionEnabled = NO;
            cell.editTxtFld.text = fbLName;
        }
        else
            cell.editTxtFld.placeholder=@"Last Name*";
        
         cell.iconImage.image=[UIImage imageNamed:@"user-icon"];
        
    } else if (indexPath.row == 2) {
        
        cell.editTxtFld.tag=indexPath.row;
        if (isFacebookLogin == YES) {
           // self.cell.userInteractionEnabled = NO;
            cell.editTxtFld.text = fbEmail;
        }
        else
            cell.editTxtFld.placeholder=@"Email (Username)*";
        

        
        cell.iconImage.image=[UIImage imageNamed:@"email"];
        
    }
    else if (indexPath.row == 3) {
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Password*";

        if (isFacebookLogin == YES) {
            // self.cell.userInteractionEnabled = NO;
            cell.editTxtFld.text=@"Password*";
            cell.editTxtFld.textColor = [UIColor grayColor];
        }
        else{
            cell.editTxtFld.secureTextEntry = YES;
        }
        
        
       // cell.editTxtFld.secureTextEntry = YES;
        cell.iconImage.image=[UIImage imageNamed:@"locl"];
    }else if (indexPath.row == 4) {
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Confirm Password*";
        if (isFacebookLogin == YES) {
            // self.cell.userInteractionEnabled = NO;
            cell.editTxtFld.text=@"Confirm Password*";
            cell.editTxtFld.textColor = [UIColor grayColor];
        }
        else{
            cell.editTxtFld.secureTextEntry = YES;
        }
        
              // cell.editTxtFld.secureTextEntry = YES;
        cell.iconImage.image=[UIImage imageNamed:@"locl"];
        
    }
    else if (indexPath.row== 5) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Child Age*";
        if (isFacebookLogin == YES) {
            // self.cell.userInteractionEnabled = NO;
            cell.editTxtFld.text=@"Child Age*";
            
            cell.editTxtFld.textColor = [UIColor grayColor];

        }
        
                cell.iconImage.image=[UIImage imageNamed:@"user-icon"];
        
        //self.createStaffCell.nameTxtFld.text=self.txtUserRole;
    } else if (indexPath.row == 6) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Country*";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"Country*";
            cell.editTxtFld.textColor = [UIColor grayColor];
        }
        
        cell.editTxtFld.inputView = countrySelect;
        cell.iconImage.image=[UIImage imageNamed:@"location"];
        
    } else if (indexPath.row == 7) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"City*";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"City*";
            cell.editTxtFld.textColor = [UIColor grayColor];
        }
        
        cell.iconImage.image=[UIImage imageNamed:@"city"];
        
    }else if (indexPath.row == 8) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Language";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"Language";
            cell.editTxtFld.textColor = [UIColor grayColor];
        }
        

        cell.iconImage.image=[UIImage imageNamed:@"language"];
        
    }else if (indexPath.row == 9) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Favorite Author 1";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"Favorite Author 1";
            cell.editTxtFld.textColor = [UIColor grayColor];

        }
        cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
        
        
    }else if (indexPath.row == 10) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Favorite Author 2";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"Favorite Author 2";
            cell.editTxtFld.textColor = [UIColor grayColor];
            
        }
        cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
        
    }else if (indexPath.row == 11) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Favorite Author 3";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"Favorite Author 3";
            cell.editTxtFld.textColor = [UIColor grayColor];
            
        }
        
        cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
    }else if (indexPath.row == 12) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"New Author 1";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"New Author 1";
            cell.editTxtFld.textColor = [UIColor grayColor];
            
        }
       
        //  self.cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
        
        
    }else if (indexPath.row == 13) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"New Author 2";
        if (isFacebookLogin == YES) {
            cell.editTxtFld.text=@"New Author 2";
            cell.editTxtFld.textColor = [UIColor grayColor];
        }

        
        //self.cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
        
    }
    
    
    return cell;
    // 8796218363
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    if (pickerView.tag == 12) {
        return [authorNameArr count];
    }
    else
        return [pickerData count];
    
    
}
////-----------UIPickerViewDelegate
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 12) {
        return [authorNameArr objectAtIndex:row];
    }
    else
        return [pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
    if (pickerView.tag == 11) {
        self.txtCountry=@"";
        self.txtCountry= [pickerData objectAtIndex:row];
        self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        self.cell.editTxtFld.text=[pickerData objectAtIndex:row];
    }
    else if (pickerView.tag == 12){
        NSString *selectedOption = [authorNameArr objectAtIndex:row];
       
        if (selectedIndex == 9 ) {
            self.txtfavAuth1=@"";

              self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
            if ([selectedOption isEqualToString:@"Other"]) {
                self.cell.editTxtFld.inputView = nil;
            }
            else{
                self.txtfavAuth1= [authorNameArr objectAtIndex:row];
                
                self.cell.editTxtFld.text=self.txtfavAuth1;

            }
            
            
            
            
        }
        else if (selectedIndex == 10 ) {
             self.txtFavAuth2=@"";
            self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
            if ([selectedOption isEqualToString:@"Other"]) {
                self.cell.editTxtFld.inputView = nil;
            }
            else{
                self.txtFavAuth2= [authorNameArr objectAtIndex:row];
                //  self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
                self.cell.editTxtFld.text=self.txtFavAuth2;
            }
            
            
        }
        else if (selectedIndex == 11 ) {
            self.txtFavAuth3=@"";
            self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
            if ([selectedOption isEqualToString:@"Other"]) {
                self.cell.editTxtFld.inputView = nil;
            }
            else{
                self.txtFavAuth3= [authorNameArr objectAtIndex:row];
                //  self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
                self.cell.editTxtFld.text=self.txtFavAuth3;
            }

          //  self.txtFavAuth3= [authorNameArr objectAtIndex:row];
           // self.cell = (editProfileCustomeCell*)[self.registrationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
          //  self.cell.editTxtFld.text=self.txtFavAuth3;
            
        }
        
    }
    
    //    [languageSelect removeFromSuperview];
    
    //Write the required logic here that should happen after you select a row in Picker View.
    // self.countryTextField.text = [pickerData objectAtIndex:row];
    [[self view]endEditing:YES];
    
    //    [languageSelect removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onProfilePhotoTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [sheet showInView:self.view.window];
    
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type]){
        if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            type = UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * pImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation orient = pImage.imageOrientation;
    if (orient != UIImageOrientationUp) {
        UIGraphicsBeginImageContextWithOptions(pImage.size, NO, pImage.scale);
        [pImage drawInRect:(CGRect){0, 0, pImage.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pImage = normalizedImage;
    }
    [self.profilePicImg setImage:pImage];
    self.profilePicImg.contentMode = UIViewContentModeScaleAspectFit;

    [picker dismissViewControllerAnimated:YES completion:nil];
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
}


- (IBAction)onRegistrationButtonClick:(id)sender
{
    
    if (isFacebookLogin == YES) {
        // PFUser *user1 = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
        [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
            if (!error) {
                [APP_DELEGATE stopActivityIndicator];
                NSLog(@"obj:%@",object);
                NSLog(@"age:%@ \ncity:%@ \n country:%@",self.txtAge,self.txtCity,self.txtCountry);
                //   UIImage *image = [self scaleAndRotateImage:self.profilePicImg.image];
                // NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                //  PFFile *file = [PFFile fileWithName:@"ProfilePic.jpg" data:imageData];
                // [object setObject:file forKey:PROFILE_PIC];
                // [picker dismissViewControllerAnimated:YES completion:nil];
                //  [object setObject:self.txtEmailId forKey:EMAIL_ID];
                //  [object setObject:self.txtEmailId forKey:USERNAME];
                
                [object setObject:[NSNumber numberWithInt:[self.txtAge intValue]] forKey:AGE];
                
                [object setObject:self.txtCity forKey:CITY];
                [object setObject:self.txtCountry forKey:COUNTRY];
                [object setObject:self.txtLang forKey:LANGUAGE];
                if (self.txtfavAuth1 == nil){
                    self.txtfavAuth1 = @"";
                    //[object setObject:self.txtfavAuth1 forKey:FAVORITE_AUTHOR1];
                }
                if (self.txtFavAuth2 == nil) {
                    self.txtFavAuth2 = @"";
                    
                }
                if (self.txtFavAuth3 == nil) {
                    self.txtFavAuth3 = @"";
                }
                
                [object setObject:self.txtfavAuth1 forKey:FAVORITE_AUTHOR1];
                [object setObject:self.txtFavAuth2 forKey:FAVORITE_AUTHOR2];
                [object setObject:self.txtFavAuth3 forKey:FAVORITE_AUTHOR3];
                if (self.txtNewAuth1 == nil) {
                    self.txtNewAuth1 = @"";
                }
                
                if (self.txtNewAuth2 == nil) {
                    self.txtNewAuth2 = @"";
                }
                
                
                [object setObject:self.txtNewAuth1 forKey:NEW_AUTHOR1];
                //[object setObject:self.txtFirstName forKey:FIRST_NAME];
                
                [object setObject:self.txtNewAuth2 forKey:NEW_AUTHOR2];
                
                //  [object setObject:self.txtLastName forKey:LAST_NAME];
                
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [APP_DELEGATE stopActivityIndicator];
                    if (!error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"Profile created!!!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
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
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"ERROR!!!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }];
            }
        }];
        
        
    }
    else{
        [self getStaffCellValue];
    if ([self.txtEmailId isEqualToString:@""]&&[self.txtAge isEqualToString:@""]&&[self.txtCountry isEqualToString:@""]&&[self.txtCity isEqualToString:@""]&& [self.txtPassword isEqualToString:@""]&&[self.txtConfirmPass isEqualToString:@""]&&[self.txtFirstName isEqualToString:@""]&&[self.txtLastName isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Fields with * sign are compulsory fields."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];

    }
    
    
    
    else if(![self.txtPassword isEqualToString:self.txtConfirmPass]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Passwords are not matching."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
       
        
        [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
        
        User *user=[User createEmptyUser];
        user.email = self.txtEmailId;
        user.username=self.txtEmailId;
        user.password=self.txtPassword;
        user.age=[NSNumber numberWithInteger:[self.txtAge integerValue]];
        user.city=self.txtCity;
        user.country=self.txtCountry;
        user.language=self.txtLang;
        user.favoriteAuthor1=self.txtfavAuth1;
        user.favoriteAuthor2=self.txtFavAuth2;
        user.favoriteAuthor3=self.txtFavAuth3;
        user.nwAuthor1=self.txtNewAuth1;
        user.nwAuthor2=self.txtNewAuth2;
        user.status=@"active";
        user.firstName = self.txtFirstName;
        user.lastName = self.txtLastName;
        user.role = @"author";
        if (isFacebookLogin == YES) {
            user.facebookId = fbId;
        }
        if (self.profilePicImg.image != [UIImage imageNamed:@"ProfilePic.png"]) {
            UIImage *image = [self scaleAndRotateImage:self.profilePicImg.image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
            user.profilePic = [PFFile fileWithName:@"ProfilePic.jpg" data:imageData];
        }
        [user signUpBlock:^(id object, NSError *error) {
            [APP_DELEGATE stopActivityIndicator];
            if (!error) {
                [self logButtonPress:sender];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"Registered successfully!!! Want to login?"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag=11;
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"ERROR!!!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
      }
    }
}
-(void)logButtonPress:(UIButton *)button{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Registration Screen"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:@"registration"
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}


#pragma mark
#pragma mark ====================== Text Field Delegate =
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    selectedIndex = textField.tag;
    
     [textField setText:@""];
    
    [self animateTextField: textField up: YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    NSInteger nextTag = textField.tag;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
}

    
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    [self animateTextField: textField up: NO];
    if (selectedIndex == 5) {
        self.txtAge = textField.text;
        
    }
    else if (selectedIndex == 7){
        self.txtCity = textField.text;
    }
    else if(selectedIndex == 8){
        self.txtLang = textField.text;
    }
    else if (selectedIndex == 12){
        self.txtNewAuth1 = textField.text;
    }
    else if (selectedIndex == 13){
        self.txtNewAuth2 = textField.text;
    }
}
- (void)animateTextField:(UITextField*)textField up:(BOOL)up {
    
    if (textField.tag == 1) {
        
        movementDistance = 00;
    }
    else if (textField.tag == 2) {
        movementDistance = 00;
    }
    else if (textField.tag == 3) {
        movementDistance = 00;
    }
    else if (textField.tag == 4) {
        movementDistance = 00;
    }
    else if (textField.tag == 5) {
        movementDistance = 00;
    }
    else if (textField.tag == 6) {
        movementDistance = 40;
    }
    else if (textField.tag == 7) {
        movementDistance = 80;
    }
    else if (textField.tag == 8) {
        movementDistance = 120;
    }
    else if (textField.tag == 9) {
        movementDistance = 160;
    }
    else if (textField.tag == 10) {
        movementDistance = 200;
    }
    else if (textField.tag == 11) {
        movementDistance = 240;
    }
    else if (textField.tag == 12) {
        movementDistance = 250;
    }
    else if (textField.tag == 13) {
        movementDistance = 280;
    }
    else if (textField.tag == 14) {
        movementDistance = 300;
    }
    else {
        movementDistance = 00;
    }
    
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
-(void)getStaffCellValue{
    
    for (int i=0;i<14; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        
        UITableViewCell *cell = [self.registrationTableView cellForRowAtIndexPath:indexPath];
        
        for (UIView *view in  cell.contentView.subviews){
            
            if ([view isKindOfClass:[UITextField class]]){
                
                UITextField *txtField = (UITextField *)view;
                
                if (indexPath.row==0) {
                    
                    self.txtFirstName=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                }
                if (indexPath.row==1) {
                    
                    self.txtLastName=[[NSString alloc]initWithFormat:@"%@",txtField.text];

                    
                }if (indexPath.row==2) {
                    
                    self.txtEmailId=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    
                }if (indexPath.row==3) {
                    
                    // self.txtAge=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                }if (indexPath.row==4) {
                    
                    //self.txtCountry=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                }if (indexPath.row==5) {
                    
                    self.txtAge=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    
                    
                }if (indexPath.row==6) {
                    
                    self.txtCountry=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    
                    
                    
                }
                if (indexPath.row==7) {
                    
                    self.txtCity=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    
                    //self.txtfavAuth1=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                }
                if (indexPath.row==8) {
                    self.txtLang=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    // self.txtFavAuth2=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                }
                if (indexPath.row==9) {
                    
                    //self.txtFavAuth3=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                }
                if (indexPath.row==10) {
                    
                    //  self.txtNewAuth1=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }
                if (indexPath.row==11) {
                    
                    // self.txtNewAuth2=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }
                
                
                if (indexPath.row==12) {
                    self.txtNewAuth1=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    
                    
                    //self.txtPassword=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }
                if (indexPath.row==13) {
                    
                    self.txtNewAuth2=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                    //self.txtConfirmPass=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }
                // End of isKindofClass
                
            
        

        
                // End of isKindofClass
            } // End of Cell Sub View
        }
    }
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex == 0) {
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
            //self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
            //self.uniNavController = self.navigationController;
            //self.window.rootViewController = self.navigationController;
            //[self.window makeKeyAndVisible];
            
        }

    }
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
