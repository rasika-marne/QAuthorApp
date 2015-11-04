//
//  DashboardViewController.h
//  QAuthorApp
//
//  Created by Pooja on 10/13/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "FanFollowers.h"
#import <QuartzCore/QuartzCore.h>
@interface DashboardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tempFollowingArr,*tempauthIdarr,*flagArray;
    bool btnFollowClick;
    FanFollowers *fanObj;
}
@property (strong,nonatomic)NSMutableArray *autorsArray;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIButton *authorsButton;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *followingsButton;

@property (weak, nonatomic) IBOutlet UITableView *authorTableview;
- (IBAction)onclickAuthorBtn:(id)sender;
- (IBAction)onClickFollowersBtn:(id)sender;
- (IBAction)onClickFollowingBtn:(id)sender;
-(void)UnFollow:(UIButton *)sender;
-(void)Follow:(UIButton *)sender;
- (IBAction)segmentSwitch:(UISegmentedControl *)sender;
@end
