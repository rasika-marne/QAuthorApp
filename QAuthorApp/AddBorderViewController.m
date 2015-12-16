//
//  AddBorderViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 12/7/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "AddBorderViewController.h"

@interface AddBorderViewController ()

@end

@implementation AddBorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMethod];
    [self.view setBackgroundColor: RGB];
    // Do any additional setup after loading the view.
}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Choose Border";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBorder1Click:(id)sender{
    borderImageFlag = 1;
    
    [self selectBorder];
    
}
- (IBAction)onBorder2Click:(id)sender{
    borderImageFlag = 2;
    
    [self selectBorder];
    
}
- (IBAction)onBorder3Click:(id)sender{
    borderImageFlag = 3;
    
    [self selectBorder];

    
}
- (IBAction)onBorder4Click:(id)sender{
    borderImageFlag = 4;
    
    [self selectBorder];

    
}
- (IBAction)onBorder5Click:(id)sender{
    borderImageFlag = 5;
    
    [self selectBorder];

    
}
- (IBAction)onBorder6Click:(id)sender{
    borderImageFlag = 6;
    
    [self selectBorder];

    
}
- (IBAction)onBorder7Click:(id)sender{
    borderImageFlag = 7;
    
    [self selectBorder];

    
}
- (IBAction)onBorder8Click:(id)sender{
    borderImageFlag = 8;
    
    [self selectBorder];

    
}
- (IBAction)onBorder9Click:(id)sender{
    borderImageFlag = 9;
    
    [self selectBorder];

    
}
- (IBAction)onBorder10Click:(id)sender{
    borderImageFlag = 10;
    
    [self selectBorder];

    
}
-(void)selectBorder{
    
    selectedBorder = [[UIImage alloc]init];
    selectedBorder = [UIImage imageNamed:[NSString stringWithFormat:@"border%d.jpg",borderImageFlag]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
