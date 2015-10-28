//
//  DCTableViewCell.h
//  QAuthorApp
//
//  Created by Pooja on 10/13/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *authornameLbl;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end
