//
//  EditBookTitleViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "EditBookTitleViewController.h"

@interface EditBookTitleViewController ()

@end

@implementation EditBookTitleViewController
@synthesize coverPic,titleTextField,genreTextField,descTextView,bookObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    PFFile *imageFile = bookObj.coverPic;
    if (imageFile && ![bookObj.coverPic isEqual:[NSNull null]]) {
        [bookObj.coverPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data) {
                [coverPic setImage:[UIImage imageWithData:data]];
            }
            
        }];
    }
    titleTextField.text = bookObj.title;
    genreTextField.text = bookObj.genre;
    descTextView.text = bookObj.shortDesc;
    

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

- (IBAction)onCoverPicTapped:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [sheet showInView:self.view.window];
    

}
- (IBAction)onSaveButtonClicked:(id)sender {
}
@end
