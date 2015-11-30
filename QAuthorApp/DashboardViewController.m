//
//  DashboardViewController.m
//  QAuthorApp
//
//  Created by Pooja on 10/13/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "DCTableViewCell.h"
@interface DashboardViewController ()
@end

@implementation DashboardViewController
@synthesize autorsArray;
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    fanObj = [FanFollowers createEmptyObject];
    [self navigationMethod];
    //self.navigationController.navigationBar.hidden = NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    UIImage *myImage = [UIImage imageNamed:@"menu-icon.png"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    

    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    self.authorsButton.selected = YES;
    if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
        //[self fetchAuthors];

    [self tempFetchFollowings];
    }
    if ([SelectedSegmentvalue isEqualToString:@"Followers"]){
        [self fetchFollowers];
        self.navigationItem.title = @"Followers";
        //self.segment.selectedSegmentIndex=1;
    }
    
    if ([SelectedSegmentvalue isEqualToString:@"Following"]){
        [self fetchFollowing];
        self.navigationItem.title = @"Following";
       // self.segment.selectedSegmentIndex=2;
    }
   // [self fetchAuthors];
  /*  if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
        [self fetchAuthors];

        self.segment.selectedSegmentIndex=0;
        self.navigationItem.title = @"Dashboard";

    }
    if ([SelectedSegmentvalue isEqualToString:@"Followers"]){
        [self fetchFollowers];
        self.navigationItem.title = @"Followers";
        self.segment.selectedSegmentIndex=1;
    }

    if ([SelectedSegmentvalue isEqualToString:@"Following"]){
        [self fetchFollowing];
        self.navigationItem.title = @"Following";
        self.segment.selectedSegmentIndex=2;
    }*/
}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
     self.title=@"Dashboard";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (IBAction)onclickAuthorBtn:(id)sender {
    
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Dashboard";
    self.navigationItem.title = @"Dashboard";
    [self fetchAuthors];}

- (IBAction)onClickFollowersBtn:(id)sender {
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Followers";
    self.navigationItem.title = @"Followers";
    [self fetchFollowers];
}

- (IBAction)onClickFollowingBtn:(id)sender {
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Following";
    [self fetchFollowing];
    self.navigationItem.title = @"Following";
}
-(void)tempFetchFollowings{
    
    tempFollowingArr=[[NSMutableArray alloc]init];
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    autorsArray=[[NSMutableArray alloc]init];
    PFQuery *query2 = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query2 whereKey:FOLLOWERS equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for(PFObject *obj in objects){
                
                [tempFollowingArr addObject:[obj objectForKey:FAN_USER_ID]];
            }
            NSLog(@"temp arr:%@",tempFollowingArr);
            [self fetchAuthors];
        }}];
    //NSLog(@"temp arr:%@",tempFollowingArr);

}
-(void)fetchAuthors{
   // [self tempFetchFollowings];
    tempFollowingArr=[[NSMutableArray alloc]init];
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    autorsArray=[[NSMutableArray alloc]init];
    PFQuery *query2 = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query2 whereKey:FOLLOWERS equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for(PFObject *obj in objects){
                
                [tempFollowingArr addObject:[obj objectForKey:FAN_USER_ID]];
            }
            NSLog(@"temp arr:%@",tempFollowingArr);
            SelectedSegmentvalue=nil;
            SelectedSegmentvalue=@"Dashboard";
            // [self tempFetchFollowings];
            [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
            autorsArray = [[NSMutableArray alloc]init];
            tempauthIdarr= [[NSMutableArray alloc]init];
            flagArray=[[NSMutableArray alloc]init];
            // PFUser *currentUser= [PFUser cu];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *userId = [def valueForKey:USER_ID];
            PFQuery *query=[PFUser query];
            [query whereKey:ROLE equalTo:@"author"];
            [query whereKey:USER_OBJECT_ID notEqualTo:userId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (!error) {
                    [APP_DELEGATE stopActivityIndicator];
                    NSLog(@"books arr cnt:%lu",(unsigned long)[objects count]);
                    if ([objects count]==0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"No Data available."
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    else{
                        
                        for (PFObject *obj in objects) {
                            // Use *fObj = [FanFollowers convertPFObjectToFans:obj];
                            if ([tempFollowingArr containsObject:obj.objectId]) {
                                [flagArray addObject:@"1"];
                            }else{
                                [flagArray addObject:@"0"];
                                
                            }
                            [tempauthIdarr addObject:obj.objectId];
                            [autorsArray addObject:obj];
                            
                        }
                        
                        [self.authorTableview reloadData];
                    }
                    NSLog(@"flagArr:%@",flagArray);
                    
                }
            }];

            //[self fetchAuthors];
        }}];
   }
-(void)fetchFollowers{
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Followers";
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    autorsArray=[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query whereKey:FAN_USER_ID equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                
                for(PFObject *obj in objects){
                    //FanFollowers *fObj = [FanFollowers createEmptyObject];
                    //fObj = [FanFollowers convertPFObjectToFans:obj];
                    NSString *idstr=[obj objectForKey:FOLLOWERS];
                    if ([idstr isEqualToString:@"<null>"] || [idstr isEqualToString:@""] || [idstr isEqualToString:@"(null)"]||[idstr  isKindOfClass:[NSNull class]]  || idstr == nil) {
                    }else{
                    [autorsArray addObject:obj];
                    
                }
                }
            
                if (self.autorsArray.count==0) {
                    
                    [[[UIAlertView alloc]initWithTitle:@"alert" message:@"No data is available" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"alert_ok_title", nil), nil]show];
                    //[self.authorTableview reloadData];
                    
                    
                } else {
                    
                    [self.authorTableview reloadData];
                    
                }
                [APP_DELEGATE stopActivityIndicator];
                //[self displayTable:objects];
                
            } else {
                
                // Log details of the failure
                /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT
                 message:[error.userInfo objectForKey:NSLocalizedString(@"common_error_str", nil)]
                 delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_ok_title", nil) otherButtonTitles:nil];
                 [alertView show];*/
                
            }
        }];
}
-(void)fetchFollowing{
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Following";
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    autorsArray=[[NSMutableArray alloc]init];
    flagArray=[[NSMutableArray alloc]init];

    PFQuery *query = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query whereKey:FOLLOWERS equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for(PFObject *obj in objects){
                NSString *idstr=[obj objectForKey:FAN_USER_ID];
                if ([idstr isEqualToString:@"<null>"] || [idstr isEqualToString:@""] || [idstr isEqualToString:@"(null)"]||[idstr  isKindOfClass:[NSNull class]]  || idstr == nil) {
                }else{
                    
                    [flagArray addObject:@"1"];
                    [autorsArray addObject:obj];
                    
                }
            }
        
            if (self.autorsArray.count==0) {
                
                [[[UIAlertView alloc]initWithTitle:@"alert" message:@"No data is available" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"alert_ok_title", nil), nil]show];
                //[self.authorTableview reloadData];
                
                
            } else {
                NSLog(@"followings arr:%@",autorsArray);
                 NSLog(@"flag arr:%@",flagArray);
                [self.authorTableview reloadData];
                
            }
            
            [APP_DELEGATE stopActivityIndicator];
            //[self displayTable:objects];
            
        } else {
             [flagArray addObject:@"0"];
            // Log details of the failure
            /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT
             message:[error.userInfo objectForKey:NSLocalizedString(@"common_error_str", nil)]
             delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_ok_title", nil) otherButtonTitles:nil];
             [alertView show];*/
            
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return autorsArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // fanObj = [autorsArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"DCTableViewCell";
    
    DCTableViewCell *cell = (DCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DCTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.backgroundColor = RGB;
    cell.profilePic.layer.cornerRadius = 20;
    cell.profilePic.clipsToBounds = YES;
    [cell.followBtn addTarget:self action:@selector(FollowbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.followBtn.tag=indexPath.row;
     [tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]]];
    if (autorsArray.count!=0) {
        if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
        
            cell.followBtn.hidden=NO;

        if ([[[autorsArray objectAtIndex:indexPath.row]valueForKey:@"first_name"]  isKindOfClass:[NSNull class]] && [[[autorsArray objectAtIndex:indexPath.row]valueForKey:@"last_name"]  isKindOfClass:[NSNull class]]) {
            
            
        }else{
            
             cell.authornameLbl.text=[NSString stringWithFormat:@"%@ %@",[[autorsArray objectAtIndex:indexPath.row]valueForKey:@"first_name"],[[autorsArray objectAtIndex:indexPath.row]valueForKey:@"last_name"]];
        }
                    PFFile * imageFile = [[autorsArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"]; // note the modern Obj-C syntax
    
        if (imageFile && ![[[autorsArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"] isEqual:[NSNull null]]) {
        
        [[[autorsArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data) {
                [cell.profilePic setImage:[UIImage imageWithData:data]];
               

                }
            }];
          }
            NSString *cityStr = [NSString stringWithFormat:@"%@, %@",[[autorsArray objectAtIndex:indexPath.row] valueForKey:CITY],[[autorsArray objectAtIndex:indexPath.row] valueForKey:COUNTRY]];
            cell.cityLabel.text = cityStr;
            //cell.countryLabel.text = [[autorsArray objectAtIndex:indexPath.row] valueForKey:COUNTRY];
            //NSString *tempAge = [NSString stringWithFormat:<#(NSString *), ...#>];
            NSNumber *age = [[autorsArray objectAtIndex:indexPath.row] valueForKey:AGE];
            cell.ageLabel.text = [age stringValue];
            if ([[flagArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                
                [cell.followBtn setTitle:@"-Unfollow" forState:UIControlStateNormal];
                // [cell.followBtn addTarget:self action:@selector(UnFollow:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                [cell.followBtn setTitle:@"+Follow" forState:UIControlStateNormal];
              //  [cell.followBtn addTarget:self action:@selector(Follow:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.followBtn.tag = indexPath.row;
    }
        if ([SelectedSegmentvalue isEqualToString:@"Followers"]) {
            PFQuery *query1 = [PFQuery queryWithClassName:FAN_FOLLOWERS];
            [query1 whereKey:FOLLOWERS  equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
            [query1 whereKey:FAN_USER_ID equalTo:[[autorsArray objectAtIndex:indexPath.row] valueForKey:@"followers"]];
            [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object) {
                    cell.followBtn.hidden=YES;
                }
                else{
                    cell.followBtn.hidden=NO;
                }
            }];
            
            
            NSString *idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:FOLLOWERS];
            if ([idstr isEqualToString:@"<null>"] || [idstr isEqualToString:@""] || [idstr isEqualToString:@"(null)"]||[idstr  isKindOfClass:[NSNull class]]  || idstr == nil) {}else{
            PFQuery *query=[PFUser query];
                [query whereKey:ROLE equalTo:@"author"];
            [query getObjectInBackgroundWithId:idstr block:^(PFObject *object, NSError *error) {
                
                if (!error) {
                    
                    cell.authornameLbl.text=[NSString stringWithFormat:@"%@ %@",[object objectForKey:@"first_name"],[object objectForKey:@"last_name"]];
                    
                    PFFile * imageFile = [object objectForKey:PROFILE_PIC]; // note the modern Obj-C syntax
                    NSString *cityStr = [NSString stringWithFormat:@"%@, %@",[object objectForKey:CITY ],[object objectForKey:COUNTRY]];
                    cell.cityLabel.text = cityStr;
                   
                    NSNumber *age =[object objectForKey:AGE];
                    cell.ageLabel.text = [age stringValue];
                    
                    if (imageFile && ![[object objectForKey:@"profilePic"] isEqual:[NSNull null]]) {
                        
                        [[object objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (data) {
                                [cell.profilePic setImage:[UIImage imageWithData:data]];
                                                            }
                        }];
                    }
                }
            }];
            
            }
        }
        if ([SelectedSegmentvalue isEqualToString:@"Following"]) {
            
            
            cell.followBtn.hidden=NO;
            NSString *idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:FAN_USER_ID];
            if ([idstr isEqualToString:@"<null>"] || [idstr isEqualToString:@""] || [idstr isEqualToString:@"(null)"]||[idstr  isKindOfClass:[NSNull class]]  || idstr == nil) {}else{
              
                PFQuery *query=[PFUser query];
                [query whereKey:ROLE equalTo:@"author"];
                [query getObjectInBackgroundWithId:idstr block:^(PFObject *object, NSError *error) {
                
                if (!error) {
                    NSLog(@"object:%@",object);
                    cell.authornameLbl.text=[NSString stringWithFormat:@"%@ %@",[object objectForKey:@"first_name"],[object objectForKey:@"last_name"]];
                    
                    PFFile * imageFile = [object objectForKey:@"profilePic"]; // note the modern Obj-C syntax
                    NSString *cityStr = [NSString stringWithFormat:@"%@, %@",[object objectForKey:CITY ],[object objectForKey:COUNTRY]];
                    cell.cityLabel.text = cityStr;
                    
                    NSNumber *age =[object objectForKey:AGE];
                    cell.ageLabel.text = [age stringValue];
                    if (imageFile && ![[object objectForKey:@"profilePic"] isEqual:[NSNull null]]) {
                        
                        [[object objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (data) {
                                [cell.profilePic setImage:[UIImage imageWithData:data]];
                                cell.profilePic.layer.cornerRadius = 0.5f;
                                cell.profilePic.clipsToBounds = YES;
                            }
                        }];
                    }
                    
                    if ([[flagArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                        
                        [cell.followBtn setTitle:@"-Unfollow" forState:UIControlStateNormal];
                    }else{
                        [cell.followBtn setTitle:@"+Follow" forState:UIControlStateNormal];
                    }
                }
            }];
            
        }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idstr;
    UIStoryboard *storyboard;
    if (IPAD) {
        storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
    }
    else
        storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    //UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewProfileVC = (ViewProfileViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"ViewProfileViewController"];
    if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
         idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:OBJECT_ID];
       
    }
    else if ([SelectedSegmentvalue isEqualToString:@"Followers"]){
         idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:FOLLOWERS];
        
    }
    else if ([SelectedSegmentvalue isEqualToString:@"Following"]){
        idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:FAN_USER_ID];
        
    }
    self.viewProfileVC.userId = idstr;
     [self.navigationController pushViewController:self.viewProfileVC animated:YES];
    /*
    
    bookObj = [booksArray objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.bookDetailVC = (BookDetailsViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"BookDetailsViewController"];
    self.bookDetailVC.bookObj1 = [Book createEmptyObject];
    self.bookDetailVC.bookObj1 = bookObj;
    self.bookDetailVC.authorName = [authorNamesArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.bookDetailVC animated:YES];
    */
}
-(void)Follow:(NSString *)followingId{
    
    NSLog(@"Start Following");
  //  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
   // PFObject *obj = [autorsArray objectAtIndex:indexPath.row];
   // NSLog(@"object:%@",obj);
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    
    PFObject *userObject = [PFObject objectWithClassName:FAN_FOLLOWERS];
    [userObject setValue:followingId forKey:FAN_USER_ID];
    [userObject setValue:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID] forKey:FOLLOWERS];
    
    //1.Followers: add entry for user with its following_id
    [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
                
                [self fetchAuthors];
            }
            if ([SelectedSegmentvalue isEqualToString:@"Following"]){
                [self fetchFollowing];
            }
            [APP_DELEGATE stopActivityIndicator];
        }
        else{
            [APP_DELEGATE stopActivityIndicator];

            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"%@",[error description]] delegate:nil
                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        }
    }];
}


-(void)UnFollow:(NSString *)followingId{
    
    NSLog(@"Stop unFollowing");
   // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
   // PFObject *obj = [autorsArray objectAtIndex:indexPath.row];
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [userQuery whereKey:FOLLOWERS equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    [userQuery whereKey:FAN_USER_ID equalTo:followingId];
    
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        // results contains users records.
        if (!error) {
            
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        if (!error) {
            if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
                
                [self fetchAuthors];
            }
            if ([SelectedSegmentvalue isEqualToString:@"Following"]){
                [self fetchFollowing];
            }

            
                    }
        }];
        
        }else{
        
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[NSString stringWithFormat:@"%@",[error description]] delegate:nil
                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

-(void)FollowbtnAction:(UIButton *)sender{

    if ([[flagArray objectAtIndex:[sender tag]]isEqualToString:@"0"]) {
        
        [flagArray replaceObjectAtIndex:[sender tag] withObject:@"1"];
        [self Follow:[tempauthIdarr objectAtIndex:[sender tag]]];

    }else{
        
        [flagArray replaceObjectAtIndex:[sender tag] withObject:@"0"];
        [self UnFollow:[tempauthIdarr objectAtIndex:[sender tag]]];

    }
}



- (IBAction)segmentSwitch:(UISegmentedControl *)sender{
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;

    switch (selectedSegment) {
        case 0:
            SelectedSegmentvalue=nil;
            SelectedSegmentvalue=@"Dashboard";
            self.navigationItem.title = @"Dashboard";
            [self fetchAuthors];
            break;
        case 1:
            SelectedSegmentvalue=nil;
            SelectedSegmentvalue=@"Followers";
            self.navigationItem.title = @"Followers";
            [self fetchFollowers];

            break;
        case 2:
            SelectedSegmentvalue=nil;
            SelectedSegmentvalue=@"Following";
            [self fetchFollowing];
            self.navigationItem.title = @"Following";


            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end