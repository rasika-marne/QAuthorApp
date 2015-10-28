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
    self.navigationController.navigationBar.hidden = NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    if ([SelectedSegmentvalue isEqualToString:@"Dashboard"]) {
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
    }
}
-(void)tempFetchFollowings{
    
    tempFollowingArr=[[NSMutableArray alloc]init];
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    autorsArray=[[NSMutableArray alloc]init];
    PFQuery *query2 = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query2 whereKey:FAN_USER_ID equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for(PFObject *obj in objects){
                
                [tempFollowingArr addObject:[obj objectForKey:@"followings"]];
            }
            
        }}];

}
-(void)fetchAuthors{
    
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Dashboard";
    [self tempFetchFollowings];
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    autorsArray = [[NSMutableArray alloc]init];
    tempauthIdarr= [[NSMutableArray alloc]init];
    flagArray=[[NSMutableArray alloc]init];
    
    PFQuery *query=[PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
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
                    if ([[obj objectForKey:@"objectId"] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]]) {
                        
                    }else{
                        if ([tempFollowingArr containsObject:obj.objectId]) {
                            [flagArray addObject:@"1"];
                        }else{
                            [flagArray addObject:@"0"];

                        }
                        [tempauthIdarr addObject:obj.objectId];
                        [autorsArray addObject:obj];
                    }
                }
                
                [self.authorTableview reloadData];
            }
            
            [APP_DELEGATE stopActivityIndicator];
        }
    }];
}
-(void)fetchFollowers{
    SelectedSegmentvalue=nil;
    SelectedSegmentvalue=@"Followers";
        [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
        autorsArray=[[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"FanFollowers"];
    [query whereKey:@"userId" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                
                for(PFObject *obj in objects){
                    NSString *idstr=[obj objectForKey:@"followers"];
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

    PFQuery *query = [PFQuery queryWithClassName:@"FanFollowers"];
    [query whereKey:@"userId" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for(PFObject *obj in objects){
                NSString *idstr=[obj objectForKey:@"followings"];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return autorsArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"DCTableViewCell";
    
    DCTableViewCell *cell = (DCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DCTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell.followBtn addTarget:self action:@selector(FollowbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.followBtn.tag=indexPath.row;
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
            
            if ([[flagArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                
                [cell.followBtn setTitle:@"-Unfollow" forState:UIControlStateNormal];
            }else{
                [cell.followBtn setTitle:@"-Follow" forState:UIControlStateSelected];
            }
    }
        if ([SelectedSegmentvalue isEqualToString:@"Followers"]) {
            
            cell.followBtn.hidden=YES;
            NSString *idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:@"followers"];
            if ([idstr isEqualToString:@"<null>"] || [idstr isEqualToString:@""] || [idstr isEqualToString:@"(null)"]||[idstr  isKindOfClass:[NSNull class]]  || idstr == nil) {}else{
            PFQuery *query=[PFUser query];
            [query getObjectInBackgroundWithId:idstr block:^(PFObject *object, NSError *error) {
                
                if (!error) {
                    
                    cell.authornameLbl.text=[NSString stringWithFormat:@"%@ %@",[object objectForKey:@"first_name"],[object objectForKey:@"last_name"]];
                    
                    PFFile * imageFile = [object objectForKey:@"profilePic"]; // note the modern Obj-C syntax
                    
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
            NSString *idstr=[[autorsArray objectAtIndex:indexPath.row] valueForKey:@"followings"];
            if ([idstr isEqualToString:@"<null>"] || [idstr isEqualToString:@""] || [idstr isEqualToString:@"(null)"]||[idstr  isKindOfClass:[NSNull class]]  || idstr == nil) {}else{
              
                PFQuery *query=[PFUser query];
                [query getObjectInBackgroundWithId:idstr block:^(PFObject *object, NSError *error) {
                
                if (!error) {
                    
                    cell.authornameLbl.text=[NSString stringWithFormat:@"%@ %@",[object objectForKey:@"first_name"],[object objectForKey:@"last_name"]];
                    
                    PFFile * imageFile = [object objectForKey:@"profilePic"]; // note the modern Obj-C syntax
                    
                    if (imageFile && ![[object objectForKey:@"profilePic"] isEqual:[NSNull null]]) {
                        
                        [[object objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            if (data) {
                                [cell.profilePic setImage:[UIImage imageWithData:data]];
                            }
                        }];
                    }
                    
                    if ([[flagArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
                        
                        [cell.followBtn setTitle:@"-Unfollow" forState:UIControlStateNormal];
                    }else{
                        [cell.followBtn setTitle:@"-Follow" forState:UIControlStateSelected];
                    }
                }
            }];
            
        }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    
    PFObject *userObject = [PFObject objectWithClassName:@"FanFollowers"];
    [userObject setValue:followingId forKey:@"followings"];
    [userObject setValue:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID] forKey:@"userId"];
    
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
    
    NSLog(@"Stop Following");
    
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"FanFollowers"];
    [userQuery whereKey:@"userId" equalTo:[[NSUserDefaults standardUserDefaults]objectForKey:USER_ID]];
    [userQuery whereKey:@"followings" equalTo:followingId];
    
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