//
//  ExcCommentTableViewCell.h
//  LaundryAdminApp
//
//  Created by vCleen on 8/26/15.
//  Copyright (c) 2015 vCleen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateNTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *postcommentBtn;

@end
