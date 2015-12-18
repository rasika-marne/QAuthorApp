//
//  ViewProfileViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 11/18/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "ViewProfileViewController.h"

@interface ViewProfileViewController ()

@end

@implementation ViewProfileViewController
@synthesize userId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMethod];
    
    NSLog(@"userId:%@",userId);
    PFQuery *query=[PFUser query];
    [query whereKey:ROLE equalTo:@"author"];
    [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
        if (object) {
            PFFile *imageFile = [object objectForKey:PROFILE_PIC];
            if (imageFile && ![[object objectForKey:PROFILE_PIC] isEqual:[NSNull null]]) {
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (data) {
                        [self.profilePic setImage:[UIImage imageWithData:data]];
                         self.nameLbl.text=[NSString stringWithFormat:@"%@ %@",[object valueForKey:@"first_name"],[object valueForKey:@"last_name"]];
                        self.cityLbl.text = [object objectForKey:CITY];
                         NSNumber *age = [object valueForKey:AGE];
                        self.ageLbl.text = [age stringValue];
                    }
                    
                }];
            }
        }
    }];
    

    // Do any additional setup after loading the view.
}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
     self.title=@"View Profile";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    UIImage *myImage = [UIImage imageNamed:@"back"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    
    
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (void)backButtonClicked :(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
