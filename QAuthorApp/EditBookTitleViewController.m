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
@synthesize coverPic,titleTextField,genreTextField,descTextView,bookObj,genreSelect;
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
-(void)viewWillAppear:(BOOL)animated{
    PFQuery *query = [PFQuery queryWithClassName:BOOK_GENRE];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (NSString *str in [objects valueForKey:@"genre"]) {
                [self.pickerData addObject:str];
            }
            NSLog(@"picker data: %@", self.pickerData);
            genreSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
            genreSelect.showsSelectionIndicator = YES;
            // languageSelect.hidden = NO;
            genreSelect.delegate = self;
            self.genreTextField.inputView = genreSelect;
            //self.pickerData = genreArr;
            // The find succeeded. The first 100 objects are available in objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return [self.pickerData count];
}

////-----------UIPickerViewDelegate
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
    self.genreTextField.text = [self.pickerData objectAtIndex:row];
    [[self view]endEditing:YES];
    
    //    [languageSelect removeFromSuperview];
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
