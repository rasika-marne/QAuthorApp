
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "RearViewController.h"
#import "HomeVIewController.h"
#import "EditProfileViewController.h"
#import "BookTitleViewController.h"
#import "DashboardViewController.h"
#import "CellRearTableView.h"
#import "ChooseTemplateViewController.h"
@interface RearViewController()

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
    //[self refreshCallForCount];
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *cnt = [def valueForKey:KMessageCount];
    messageCnt = cnt.intValue;
	self.title = NSLocalizedString(@"Menu", nil);
    self.navigationController.navigationBar.barTintColor = NAVBARCOLOR;
    
    /*if ([APP_DELEGATE.menuTableString isEqualToString:@"Club"]) {
        self.rearTableView.frame = CGRectMake(35, 0, 285, 460); //changed on 19 Jan 15
    }
    else if ([APP_DELEGATE.menuTableString isEqualToString:@"Coach"]||[APP_DELEGATE.menuTableString isEqualToString:@"Manager"]) {
        self.rearTableView.frame = CGRectMake(35, 0, 285, 372);
    }
    else
    {
        self.rearTableView.frame = CGRectMake(35, 0, 285, 284);
    }*/
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.rearTableView reloadData];
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 9;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//static NSString *cellIdentifier = @"Cell";
    
    int row = (int)indexPath.row;
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    /*CellRearTableView *cell = (CellRearTableView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"CellRearTableView" owner:self options:nil];
        cell = [cellArray lastObject];
    }*/

	[self setrows:row cl:cell];
	
	return cell;
}
-(void)setrows:(int)row cl:(UITableViewCell*)cell
{
    //if ([APP_DELEGATE.menuTableString isEqualToString:@"Parent"]) {
        if (row == 0)
        {
            cell.textLabel.text = @"Create Book";
           // cell.image.image = [UIImage imageNamed:@"menu_my_profile.png"];
        }
        else if (row == 1)
        {
            cell.textLabel.text = @"Edit Profile";
           // cell.image.image = [UIImage imageNamed:@"menu_team_list.png"];
        }
        else if (row == 2)
        {
            cell.textLabel.text = @"Followers";

            //cell.image.image = [UIImage imageNamed:@"menu_inbox.png"];
        }
        else if (row == 3)
        {
            cell.textLabel.text = @"Followings";

           // cell.image.image = [UIImage imageNamed:@"menu_log_out.png"];
        }
        else if (row == 4)
        {
            cell.textLabel.text = @"Dashboard";
            
            // cell.image.image = [UIImage imageNamed:@"menu_log_out.png"];
        }
        else if (row == 5)
        {
            cell.textLabel.text = @"My Books";
            
            // cell.image.image = [UIImage imageNamed:@"menu_log_out.png"];
        }
        else if (row == 6)
        {
            cell.textLabel.text = @"Professional";
            
            // cell.image.image = [UIImage imageNamed:@"menu_log_out.png"];
        }
        else if (row == 7)
        {
            cell.textLabel.text = @"Help";
            
            // cell.image.image = [UIImage imageNamed:@"menu_log_out.png"];
        }
        else if (row == 8)
        {
            cell.textLabel.text = @"Logout";
            
            // cell.image.image = [UIImage imageNamed:@"menu_log_out.png"];
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self didselectCell:row];
}

-(void)didselectCell:(int)row
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if (row == 0)
    {
        if ( ![frontNavigationController.topViewController isKindOfClass:[BookTitleViewController class]] )
        {
            BookTitleViewController *demoController1 =
            (BookTitleViewController *)
            [storyboard instantiateViewControllerWithIdentifier:@"BookTitleViewController"];
            
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController1];
            
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else
        {
            [revealController revealToggle:self];
        }
    }
    else if (row == 1)
    {
        EditProfileViewController *demoController2 =
        (EditProfileViewController *)
        [storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController2];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    else if (row == 2)
    {
        SelectedSegmentvalue=nil;
        SelectedSegmentvalue=@"Followers";
        DashboardViewController *demoController2 =
        (DashboardViewController *)
        [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController2];
        [revealController pushFrontViewController:navigationController animated:YES];
        
    }
    else if (row == 3)
    {
        SelectedSegmentvalue=nil;
        SelectedSegmentvalue=@"Following";
        DashboardViewController *demoController2 =
        (DashboardViewController *)
        [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController2];
        [revealController pushFrontViewController:navigationController animated:YES];
        
    }
    else if (row == 4)
    {
        SelectedSegmentvalue=nil;
        SelectedSegmentvalue=@"Dashboard";
        DashboardViewController *demoController2 =
        (DashboardViewController *)
        [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController2];
        [revealController pushFrontViewController:navigationController animated:YES];
        
    }
    else if (row == 5)
    {
        SelectedSegmentvalue=nil;
        SelectedSegmentvalue=@"My Books";
        HomeViewController *demoController2 =
        (HomeViewController *)
        [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController2];
        [revealController pushFrontViewController:navigationController animated:YES];
        

    }
    else if (row == 6)
    {
        SelectedSegmentvalue=nil;
        SelectedSegmentvalue=@"Professional";
        HomeViewController *demoController2 =
        (HomeViewController *)
        [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoController2];
        [revealController pushFrontViewController:navigationController animated:YES];
        

        
    }
    else if (row == 7)
    {
        SelectedSegmentvalue=nil;
        SelectedSegmentvalue=@"Help";

    }
    else if (row == 8)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        alert.tag = 8000;
        [alert show];
        //[APP_DELEGATE logout];
    }
    
    
}
/*-(void)refreshCallForCount
{
    PFQuery *query = [PFQuery queryWithClassName:INBOX];
    [query whereKey:@"receiverId" equalTo:APP_DELEGATE.loggedInUser.objectId];
    [query whereKey:@"flag" equalTo:[NSNumber numberWithInt:0]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"cnt:%d",[objects count]);
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:[NSNumber numberWithInt:(int)[objects count]] forKey:KMessageCount];
            [def synchronize];
              messageCnt = (int)[objects count];
            [self.rearTableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:KAlertError delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }
        
        
    }];

   
}*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            [APP_DELEGATE logout];
        }
    }
}
@end