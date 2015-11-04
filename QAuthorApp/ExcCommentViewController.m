//
//  ExcCommentViewController.m
//  LaundryAdminApp
//
//  Created by vCleen on 8/26/15.
//  Copyright (c) 2015 vCleen. All rights reserved.
//

#import "ExcCommentViewController.h"
#import "ExcCommentTableViewCell.h"
#import "Constant.h"
#import <UIKit/UIKit.h>
@interface ExcCommentViewController ()

@end

@implementation ExcCommentViewController
@synthesize commentDetailArray,datearray;
#pragma mark -
#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    bComment = [BookComment createEmptyObject];
    [self navigationMethod];
    [self.view setBackgroundColor: RGB];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    self.currentDateNTimeSTR=[[NSString alloc]initWithFormat:@"%@ %@",theDate,theTime];
    
    // Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated
{
        [self fetchExceptionData];
    
}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.title=@"Comment View";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.commentListArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ExcCommentTableViewCell";
    
    ExcCommentTableViewCell *cell = (ExcCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExcCommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.row==self.commentListArray.count) {
        
        cell.commentTextView.editable=YES;
        cell.commentTextView.text=@"";
        cell.dateNTimeLabel.text=self.currentDateNTimeSTR;
        cell.nameLabel.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInFirstName"];

        cell.doneBtn.hidden=NO;
        [cell.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [cell.doneBtn addTarget:self action:@selector(commentDoneAction) forControlEvents:UIControlEventTouchUpInside];
        
        cell.postcommentBtn.hidden=NO;
        [cell.postcommentBtn setTitle:@"Post comment" forState:UIControlStateNormal];
        
        [cell.postcommentBtn addTarget:self action:@selector(postCommentAction) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
    
    if(self.commentListArray.count!=0) {
        
        cell.nameLabel.text=[[self.commentListArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE, MMM d, h:mm"];
        cell.dateNTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[datearray objectAtIndex:indexPath.row]]];
       // cell.dateNTimeLabel.text=[datearray objectAtIndex:indexPath.row];
        cell.commentTextView.editable=NO;
        cell.commentTextView.text=[[self.commentListArray objectAtIndex:indexPath.row]  objectForKey:@"comment"];
        cell.doneBtn.hidden=YES;
        cell.postcommentBtn.hidden=YES;
        
      }
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    return view;
}
#pragma mark -
#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark -
#pragma mark - Parse Methods
-(void)fetchExceptionData{
    
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    self.commentListArray=[[NSMutableArray alloc]init];
    datearray =[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Book_Comment"];
    
    [query whereKey:@"bookID" equalTo:SELECTEDBOOKID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            
            commentDetailArray=[[NSMutableArray alloc]init];
            for (PFObject *cobject in objects) {
                NSLog(@"date---%@",cobject.updatedAt);
                //if ([cobject.objectId isEqualToString:SELECTEDBOOKID]) {
                    [self.commentListArray addObject:cobject];
                [datearray addObject:cobject.updatedAt];
                //}
            }
            
            
            if (self.commentListArray.count==0) {
                
                [[[UIAlertView alloc]initWithTitle:@"alert" message:@"No data is available" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"alert_ok_title", nil), nil]show];
                [self.excCommentTableView reloadData];
                
                
            }else
            {
                [self.excCommentTableView reloadData];
                
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
-(void)postCommentAction{
    
    [self getCellValue];
    if ([self.txtCommentStr length]==0) {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter some comment" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
    } else {
        
         // NSString *tempStr=[[NSUserDefaults standardUserDefaults]stringForKey:@"SeletedException"];
         PFQuery *query = [PFQuery queryWithClassName:BOOK_COMMENT];
         [query whereKey:COMMENT_BOOK_ID equalTo:SELECTEDBOOKID];
        bComment.bookID = SELECTEDBOOKID;
        bComment.userId = [[PFUser currentUser] objectId];
        bComment.userName = [[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInFirstName"];
        bComment.comment = commentStr;
        [bComment saveBookCommentsBlock:^(id object, NSError *error) {
            if (!error) {
                [[[UIAlertView alloc]initWithTitle:@"alert" message:@"Comment Posted!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"alert_ok_title", nil), nil]show];
                PFQuery *query = [PFQuery queryWithClassName:BOOK];
                [query getObjectInBackgroundWithId:SELECTEDBOOKID block:^(PFObject *gObj, NSError *error) {
                    NSInteger count = [gObj[NUMBER_OF_COMMENTS] integerValue];
                    count++;
                    // Now let's update it with some new data. In this case, only cheatMode and score
                    // will get sent to the cloud. playerName hasn't changed.
                    gObj[NUMBER_OF_COMMENTS] = [NSNumber numberWithInteger:count];
                    [gObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(!error){
                            NSLog(@"book updated!!");
                            // [APP_DELEGATE stopActivityIndicator];
                            // [self onBack:nil];
                            
                            //[self fetchAllBooks];
                        }
                        
                    }];
                }];

                //APP_DELEGATE.CommentPosted = YES;

            }
        }];
        
    }
    
}

-(void)getCellValue{
    
    if(self.commentListArray.count==0){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
        
        UITableViewCell *cell = [self.excCommentTableView cellForRowAtIndexPath:indexPath];
            
            for (UIView *view in  cell.contentView.subviews){
                
                if ([view isKindOfClass:[UITextView class]]){
                    
                    UITextView* txtView = (UITextView *)view;
                    commentStr=txtView.text;
                    // End of isKindofClass
                } // End of Cell Sub View
           }
    }
    for (int i=0;i<self.commentListArray.count+1; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
        
        UITableViewCell *cell = [self.excCommentTableView cellForRowAtIndexPath:indexPath];
        if (i==self.commentListArray.count) {
        
        
        for (UIView *view in  cell.contentView.subviews){
            
            if ([view isKindOfClass:[UITextView class]]){
                
                UITextView* txtView = (UITextView *)view;
                commentStr=txtView.text;
            // End of isKindofClass
            } // End of Cell Sub View
        }
        }
    }
}
-(void)commentDoneAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
 }

#pragma mark -
#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
#pragma mark -
#pragma mark - UITextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    [textView setText:@""];
    
    [self animateTextView:textView up: YES];
}
- (BOOL)textViewShouldReturn:(UITextView *)textField {
    
    
    NSInteger nextTag = textField.tag + 1;
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
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    self.txtCommentStr=[[NSString alloc]initWithFormat:@"%@",textView.text];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    
    [self animateTextView:textView up:NO];
}
- (void)animateTextView:(UITextView*)textview up:(BOOL)up {
    if (self.commentListArray.count==0) {
    movementDistance=10;
    }else
    {
        movementDistance=200;
    }
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
// Restrict entry to format 123-456-7890

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.txtCommentStr=[[NSString alloc]initWithFormat:@"%@",textView.text];

    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        
        return YES;
    }
    
    [textView resignFirstResponder];
    return NO;
}
@end