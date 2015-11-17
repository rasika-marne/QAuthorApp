//
//  ChooseTemplateViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTitleViewController.h"
#import "Constant.h"
@class BookTitleViewController;
@interface ChooseTemplateViewController : UIViewController{
    int flag;
}
@property (weak, nonatomic) IBOutlet UIImageView *template1;
@property (weak, nonatomic) IBOutlet UIImageView *template2;
@property (nonatomic, strong) BookTitleViewController *bookTitleVC;

@property (weak, nonatomic) IBOutlet UIImageView *template3;
- (IBAction)onTemplate2Click:(id)sender;
- (IBAction)onTemplate3Click:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *template4;
- (IBAction)onTemplate1Click:(id)sender;
- (IBAction)onTemplate4Click:(id)sender;
- (IBAction)onClickCancel:(id)sender;
-(void)createBook;
@end
