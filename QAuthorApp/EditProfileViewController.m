//
//  EditProfileViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 9/30/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize pickerData,authorSelect,countrySelect;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    dictionary = [[NSMutableDictionary alloc]init];
    [self navigationMethod];
     [self.view setBackgroundColor: RGB];
    
    authorNameArr = [[NSMutableArray alloc]init];
    [authorNameArr addObject:@"Other"];
    SWRevealViewController *revealController = [self revealViewController];
    UIImage *myImage = [UIImage imageNamed:@"menu-icon.png"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];

    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;

    user =[User createEmptyUser];
    user = APP_DELEGATE.loggedInUser;
  /*  if (user != nil) {
        self.emailTextField.text = user.email;
        self.ageTextField.text = [user.age stringValue];
        self.countryTextField.text = user.country;
        self.cityTextField.text = user.city;
        self.langTextField.text = user.language;
        self.favAuth1TextField.text = user.favoriteAuthor1;
        self.favAuth2TextField.text =user.favoriteAuthor2;
        self.favAuth3TextField.text = user.favoriteAuthor3;
        self.nwAuth1TextField.text = user.nwAuthor1;
        self.nwAuth2TextField.text = user.nwAuthor2;
       // self.passwordTextfield.text = user.password;
        [user.profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            [self.editProfilePic setImage:[UIImage imageWithData:data]];
        }];
    }*/
    [user.profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self.editProfilePic setImage:[UIImage imageWithData:data]];
    }];
    userData = [[NSMutableDictionary alloc]init];
    [userData setValue:user.firstName forKey:@"0"];
    [userData setValue:user.lastName forKey:@"1"];
    [userData setValue:user.email forKey:@"2"];
    [userData setValue:@"Password*" forKey:@"3"];
    [userData setValue:@"Confirm Password*" forKey:@"4"];
    [userData setValue:[NSString stringWithFormat:@"%d",[user.age intValue]] forKey:@"5"];
    [userData setValue:user.country forKey:@"6"];
    [userData setValue:user.city forKey:@"7"];
    [userData setValue:user.language forKey:@"8"];
    [userData setValue:user.favoriteAuthor1 forKey:@"9"];
    [userData setValue:user.favoriteAuthor2 forKey:@"10"];
    [userData setValue:user.favoriteAuthor3 forKey:@"11"];
    [userData setValue:user.nwAuthor1 forKey:@"12"];
    [userData setValue:user.nwAuthor2 forKey:@"13"];
    //[userData setObject:user.lastName forKey:[NSNumber numberWithInt:1]];
    NSLog(@"user Dict:%@",userData);
    NSMutableArray * countriesArray = [[NSMutableArray alloc] init];
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
   self.navigationItem.title = @"Edit Profile";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
-(void)viewWillAppear:(BOOL)animated{
    PFQuery *query1 = [PFQuery queryWithClassName:@"FavoriteAuthor"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                if ([authorNameArr containsObject:[obj objectForKey:@"authorName"]]) {
                     continue;                            }
                     else{
                    [authorNameArr addObject:[obj objectForKey:@"authorName"]];
                    }
                
            }
            NSLog(@"authornames:%@",authorNameArr);
        }
    }];
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
        editProfileCustomeCell *cell = (editProfileCustomeCell*)[self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        cell.editTxtFld.text=self.txtCountry;
    }
    else if (pickerView.tag == 12){
        
        NSString *selectedOption = [authorNameArr objectAtIndex:row];
        
        if (selectedIndex == 9 ) {
            self.txtfavAuth1=@"";
            
            self.cell = (editProfileCustomeCell*)[self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
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
            self.cell = (editProfileCustomeCell*)[self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
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
            self.cell = (editProfileCustomeCell*)[self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
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
    NSLog(@"USER DATA:%@",userData);
    
    static NSString *simpleTableIdentifier = @"editProfileCustomeCell";
    
    editProfileCustomeCell *cell = (editProfileCustomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.editTxtFld = nil;
    if(cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"editProfileCustomeCell" owner:self options:nil];
        cell = [cellArray lastObject];
    }
   // editProfileCustomeCell *cell = (editProfileCustomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   // if (cell == nil) {
        
       // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"editProfileCustomeCell" owner:self options:nil];
        //cell = [nib objectAtIndex:0];
        
  //  }
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor clearColor];
    [tableView setBackgroundView:bview];
    cell.backgroundColor=[UIColor clearColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.editTxtFld.delegate = self;
    if(indexPath.row == 0)
    {
        cell.editTxtFld.tag=indexPath.row;
        //cell.editTxtFld.text = user.firstName;
        cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
         cell.editTxtFld.placeholder=@"First name*";
        cell.iconImage.image=[UIImage imageNamed:@"user-icon"];
       // [dictionary setObject:user.firstName forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
    } else if (indexPath.row ==1) {
        
        cell.editTxtFld.tag=indexPath.row;
        //cell.editTxtFld.text = user.lastName;
        cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        cell.editTxtFld.placeholder=@"Last Name*";
       cell.iconImage.image=[UIImage imageNamed:@"user-icon"];
        //[dictionary setObject:user.lastName forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    } else if (indexPath.row == 2) {
        
        cell.editTxtFld.tag=indexPath.row;
       // cell.editTxtFld.text = user.email;
         cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        
        cell.editTxtFld.placeholder=@"Email (Username)*";
        cell.iconImage.image=[UIImage imageNamed:@"email"];
       // [dictionary setObject:user.email forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.row == 3) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.text=[userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.editTxtFld.textColor = [UIColor grayColor];
       /// cell.editTxtFld.secureTextEntry = YES;
        //cell.editTxtFld.enabled = NO;
      //  cell.editTxtFld.placeholder=@"Password*";
        cell.iconImage.image=[UIImage imageNamed:@"locl"];
    }else if (indexPath.row == 4) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.text=[userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        //cell.editTxtFld.text=[userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.editTxtFld.textColor = [UIColor grayColor];
       // cell.editTxtFld.secureTextEntry = YES;
       // cell.editTxtFld.enabled = NO;
       // cell.editTxtFld.placeholder=@"Confirm Password*";

        cell.iconImage.image=[UIImage imageNamed:@"locl"];
        
    }
   else if (indexPath.row == 5) {
        
       cell.editTxtFld.tag=indexPath.row;
      // cell.editTxtFld.placeholder=@"Child Age*";
       NSString *str = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
       NSLog(@"%@",str);
       cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.editTxtFld.placeholder=@"Child Age*";
       cell.iconImage.image=[UIImage imageNamed:@"user-icon"];
       
        //[dictionary setObject:user.age forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.row == 6) {
        
        cell.editTxtFld.tag=indexPath.row;
       // cell.editTxtFld.placeholder=@"Country*";
        cell.editTxtFld.inputView = countrySelect;
        cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
         cell.editTxtFld.placeholder=@"Country*";
        cell.iconImage.image=[UIImage imageNamed:@"location"];
      //  [dictionary setObject:user.country forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

        
    }else if (indexPath.row == 7) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"City*";
       cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.iconImage.image=[UIImage imageNamed:@"city"];
       // [dictionary setObject:user.city forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

        
    }else if (indexPath.row == 8) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Language";
       cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.iconImage.image=[UIImage imageNamed:@"language"];
       //  [dictionary setObject:user.language forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.row == 9) {
        
        cell.editTxtFld.tag=indexPath.row;
     cell.editTxtFld.placeholder=@"Favorite Author 1";
       cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
        

       // [dictionary setObject:user.favoriteAuthor1 forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.row == 10) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Favorite Author 2";
       cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];

       // [dictionary setObject:user.favoriteAuthor2 forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.row == 11) {
        
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"Favorite Author 3";
        cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
        //[dictionary setObject:user.favoriteAuthor3 forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (indexPath.row == 12) {
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"New Author 1";
        cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        //  self.cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
       // [dictionary setObject:user.nwAuthor1 forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

        
    }else if (indexPath.row == 13) {
        cell.editTxtFld.tag=indexPath.row;
        cell.editTxtFld.placeholder=@"New Author 2";
       cell.editTxtFld.text = [userData valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        //  self.cell.editTxtFld.inputView = authorSelect;
        cell.iconImage.image=[UIImage imageNamed:@"author"];
      //  [dictionary setObject:user.nwAuthor2 forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }
    
    
    return cell;
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
    [self.editProfilePic setImage:pImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
}

- (IBAction)onSaveButtonClick:(id)sender
{
    NSLog(@"dict:%@",dictionary);
    [self getStaffCellValue];
    if ([self.txtEmailId isEqualToString:@""]&&[self.txtAge isEqualToString:@""]&&[self.txtCountry isEqualToString:@""]&&[self.txtCity isEqualToString:@""]&& [self.txtPassword isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Fields with * sign are compulsory fields."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    /*else if(![self.txtPassword isEqualToString:self.txtConfirmPass]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Passwords are not matching."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }*/
    else{
        [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
        
       // //User *user1=[User createEmptyUser];
        //User *user1 = [User createEmptyUser];
        PFUser *user1 = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        [query getObjectInBackgroundWithId:user1.objectId block:^(PFObject *object, NSError *error) {
            if (!error) {
                UIImage *image = [self scaleAndRotateImage:self.editProfilePic.image];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                PFFile *file = [PFFile fileWithName:@"ProfilePic.jpg" data:imageData];
                [object setObject:file forKey:PROFILE_PIC];
               // [picker dismissViewControllerAnimated:YES completion:nil];
                [object setObject:self.txtEmailId forKey:EMAIL_ID];
                [object setObject:self.txtEmailId forKey:USERNAME];
                [object setObject:[NSNumber numberWithInt:[self.txtAge intValue]] forKey:AGE];
                [object setObject:self.txtCity forKey:CITY];
                [object setObject:self.txtCountry forKey:COUNTRY];
                [object setObject:self.txtLang forKey:LANGUAGE];
                 if (self.txtfavAuth1 != nil){
                    //[object setObject:self.txtfavAuth1 forKey:FAVORITE_AUTHOR1];
                }
                else {
                    self.txtfavAuth1 = user.favoriteAuthor1;
                    
                }
                if (self.txtFavAuth2 != nil) {
                    
                }
                else {
                    self.txtFavAuth2 = user.favoriteAuthor2;
                    
                }
                if (self.txtFavAuth3 != nil) {
                   
                }
                else{
                    self.txtFavAuth3 = user.favoriteAuthor3;
                    
                }
                [object setObject:self.txtfavAuth1 forKey:FAVORITE_AUTHOR1];
                [object setObject:self.txtFavAuth2 forKey:FAVORITE_AUTHOR2];
                [object setObject:self.txtFavAuth3 forKey:FAVORITE_AUTHOR3];
                if (self.txtNewAuth1 != nil) {
                    
                }
                else{
                    self.txtNewAuth1 = user.nwAuthor1;
                    
                }
                if (self.txtNewAuth2 != nil) {
                    
                }
                else{
                    self.txtNewAuth2 = user.nwAuthor2;
                    
                }

                [object setObject:self.txtNewAuth1 forKey:NEW_AUTHOR1];
                [object setObject:self.txtFirstName forKey:FIRST_NAME];

                [object setObject:self.txtNewAuth2 forKey:NEW_AUTHOR2];

                [object setObject:self.txtLastName forKey:LAST_NAME];


                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [APP_DELEGATE stopActivityIndicator];
                    if (!error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"Profile Edited!!!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
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
        }];
        
                    
        
    }
}

#pragma mark
#pragma mark ====================== Text Field Delegate =
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    selectedIndex = textField.tag;
   
    // [textField setText:@""];
    
    [self animateTextField: textField up: YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [userData removeObjectForKey:[NSString stringWithFormat:@"%d",textField.tag]];
    [userData setValue:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
    

    /*if (selectedIndex==10) {
        self.txtNewAuth1 = [[NSString alloc]initWithFormat:@"%@",textField.text];
    }
    if (selectedIndex==11) {
        self.txtNewAuth2 = [[NSString alloc]initWithFormat:@"%@",textField.text];
    }*/
   // NSInteger nextTag = textField.tag;
    // Try to find next responder
   // UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
   // if (nextResponder) {
        // Found next responder, so set it.
      //  [nextResponder becomeFirstResponder];
  //  } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
   // }
    return YES;
}
/*-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    switch (textField.tag)
    {
        case 1:
            self.txtEmailId=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 2:
            self.txtAge=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 3:
            self.txtCountry=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 4:
            self.txtCity=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 5:
            self.txtLang=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 6:
            self.txtfavAuth1=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
        case 7:
            self.txtFavAuth2=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 8:
            self.txtFavAuth3=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 9:
            self.txtNewAuth1=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
        case 10:
            self.txtNewAuth2=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
        case 11:
            self.txtPassword=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
        case 12:
            self.txtConfirmPass=[[NSString alloc]initWithFormat:@"%@",textField.text];
            break;
            
    }
    return YES;
}*/
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;


}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [userData removeObjectForKey:[NSString stringWithFormat:@"%d",textField.tag]];
    [userData setValue:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
    
           [self animateTextField: textField up: NO];
    
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
        movementDistance = 90;
    }
    else if (textField.tag == 8) {
        movementDistance = 140;
    }
    else if (textField.tag == 9) {
        movementDistance = 190;
    }
    else if (textField.tag == 10) {
        movementDistance = 240;
    }
    else if (textField.tag == 11) {
        movementDistance = 290;
    }
    else if (textField.tag == 12) {
        movementDistance = 340;
    }
    else if (textField.tag == 13) {
        movementDistance = 390;
    }
    else if (textField.tag == 14) {
        movementDistance = 440;
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
-(void)getStaffCellValue{
    
    for (int i=0;i<14; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        NSLog(@"indexpath:%d",indexPath.row);
       // UITableViewCell *cell = [self.editProfileTableView cellForRowAtIndexPath:indexPath];
       // NSLog(@"cell:%@",cell);
        //for (UIView *view in  cell.contentView.subviews){
            
            //if ([view isKindOfClass:[UITextField class]]){
                
               // UITextField *txtField = (UITextField *)view;
                
                if (indexPath.row==0) {
                    
                    self.txtFirstName=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }if (indexPath.row==1) {
                    
                    self.txtLastName=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                }if (indexPath.row==2) {
                    
                    self.txtEmailId=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                }if (indexPath.row==3) {
                    
                   // self.txtAge=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                }if (indexPath.row==4) {
                    
                    //self.txtCountry=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                }if (indexPath.row==5) {
                    
                    self.txtAge=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    
                    
                }if (indexPath.row==6) {
                    
                    self.txtCountry=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    

                    
                   
                }
                if (indexPath.row==7) {
                    
                    self.txtCity=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    

                    //self.txtfavAuth1=[[NSString alloc]initWithFormat:@"%@",txtField.text];
                    
                }
                if (indexPath.row==8) {
                    self.txtLang=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
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
                    self.txtNewAuth1=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    

                    
                    //self.txtPassword=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }
                if (indexPath.row==13) {
                    
                    self.txtNewAuth2=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                    //self.txtConfirmPass=[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
                    
                }
                // End of isKindofClass
        
    }
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
