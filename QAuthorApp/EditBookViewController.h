//
//  EditBookViewController.h
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewForPdf;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
- (IBAction)onPhotoTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
- (IBAction)onNextPageClicked:(id)sender;
- (IBAction)onSaveButtonClicked:(id)sender;

@end
