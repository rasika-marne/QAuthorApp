//
//  ExcCommentViewController.h
//  LaundryAdminApp
//
//  Created by vCleen on 8/26/15.
//  Copyright (c) 2015 vCleen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constant.h"
#import "BookComment.h"
@class BookComment;
@interface ExcCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    int movementDistance;
    NSString *commentStr;
    BookComment *bComment;
    User *user;
}

@property (weak, nonatomic) IBOutlet UITableView *excCommentTableView;
@property (strong,nonatomic)NSString *currentDateNTimeSTR,*txtNameStr,*txtCommentStr;
@property (strong,nonatomic)NSMutableArray *commentListArray,*commentDetailArray,*datearray;
@end
