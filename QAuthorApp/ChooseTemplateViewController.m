//
//  ChooseTemplateViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "ChooseTemplateViewController.h"

@interface ChooseTemplateViewController ()

@end

@implementation ChooseTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onTemplate1Click:(id)sender {
    flag = 1;
    
    [self createBook];
}

- (IBAction)onTemplate4Click:(id)sender {
    flag = 4;
   
    [self createBook];
}
- (IBAction)onTemplate2Click:(id)sender {
    flag =2;
    
    [self createBook];
}

- (IBAction)onTemplate3Click:(id)sender {
    flag =3;
    
    [self createBook];
}

-(void)createBook{
    
    selectedTemplate = [[UIImage alloc]init];
    selectedTemplate = [UIImage imageNamed:[NSString stringWithFormat:@"template%d.jpg",flag]];
   
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
