//
//  DashboardViewController.h
//  QAuthorApp
//
//  Created by Pooja on 10/13/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
@interface DashboardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tempFollowingArr,*tempauthIdarr,*flagArray;
    bool btnFollowClick;
}
@property (strong,nonatomic)NSMutableArray *autorsArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *authorTableview;
- (IBAction)segmentSwitch:(UISegmentedControl *)sender;
@end
