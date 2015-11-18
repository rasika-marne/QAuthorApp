//
//  ViewProfileViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 11/18/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface ViewProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageLbl;
@property (nonatomic, strong) NSString *userId;
@end
