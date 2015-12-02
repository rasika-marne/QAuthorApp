//
//  EditBookTitleViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "EditBookTitleViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface EditBookTitleViewController ()

@end

@implementation EditBookTitleViewController
@synthesize coverPic,titleTextField,genreTextField,descTextView,bookObj,genreSelect;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMethod];
    [self.view setBackgroundColor: RGB]; 
    /*SWRevealViewController *revealController = [self revealViewController];
    UIImage *myImage = [UIImage imageNamed:@"menu-icon.png"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;*/
    
    self.pickerData = [[NSMutableArray alloc]init];
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
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
   // if ([sender isEqual:mailTf])
   // {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
   // }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   // book.title = self.bookTitleTextField.text;
    [textField resignFirstResponder];
    return YES;
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Edit Book";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    UIImage *myImage = [UIImage imageNamed:@"back"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    
    
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (void)backButtonClicked :(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    if (selectedTemplate != nil) {
        self.coverPic.image = selectedTemplate;
    }
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Gallary",@"Choose Template", nil];
    [sheet showInView:self.view.window];
    

}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    else if (buttonIndex == 2){
        UIStoryboard *storyboard;
        if (IPAD) {
            storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
        }
        else
            storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

       // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.chooseTemplateVC = (ChooseTemplateViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ChooseTemplateViewController"];
        [self  presentViewController:self.chooseTemplateVC animated:YES completion:nil];
    }
    else{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type]){
        if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            type = UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    }
    
}
#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //ownPhotoTap = YES;
    
    UIImage * pImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation orient = pImage.imageOrientation;
    if (orient != UIImageOrientationUp) {
        UIGraphicsBeginImageContextWithOptions(pImage.size, NO, pImage.scale);
        [pImage drawInRect:(CGRect){0, 0, pImage.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pImage = normalizedImage;
    }
    
    
    // [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor=[[CLImageEditor alloc] initWithImage:pImage delegate:self];
    //[self.navigationController pushViewController:editor animated:YES];
    //[picker presentViewController:editor animated:YES completion:nil];
    [picker pushViewController:editor animated:YES];
    
    
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
}
#pragma mark - CLImageEditor Delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    //[self.m_oImage setImage:image forState:UIControlStateNormal];
    UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.02)];
    [self.coverPic setImage:lowResImage];
    selectedTemplate = lowResImage;
    // [self.bookCoverImg setImage:pImage];
    
    
    self.coverPic.contentMode = UIViewContentModeScaleAspectFit;
    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [self refreshImageView];
}
- (void)refreshImageView
{
    [self resetImageViewFrame];
    //[self resetZoomScaleWithAnimate:NO];
}

- (void)resetImageViewFrame
{
    CGSize size = (self.coverPic.image) ? self.coverPic.image.size : self.coverPic.frame.size;
    CGFloat ratio = MIN(self.view.frame.size.width / size.width, self.view.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    self.coverPic.frame = CGRectMake(0, 0, W, H);
    self.coverPic.superview.bounds = self.coverPic.bounds;
}


- (IBAction)onSaveButtonClicked:(id)sender {
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    PFQuery *query = [PFQuery queryWithClassName:BOOK];
    [query getObjectInBackgroundWithId:bookObj.objectId block:^(PFObject *object, NSError *error) {
        if (!error) {
           // [APP_DELEGATE stopActivityIndicator];
            [object setObject:titleTextField.text forKey:TITLE];
            [object setObject:genreTextField.text forKey:GENRE];
            [object setObject:descTextView.text forKey:SHORT_DESC];
            
            UIImage *image = [self scaleAndRotateImage:self.coverPic.image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
            
            PFFile *imgFile = [PFFile fileWithName:@"CoverPage.jpg" data:imageData];
            if (self.coverPic !=nil) {
                [object setObject:imgFile forKey:COVER_PAGE];
            }
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [APP_DELEGATE stopActivityIndicator];
                if (!error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                    message:@"Book Title Edited successfully!!!Do you want to edit Book details"
                                                                   delegate:self
                                                          cancelButtonTitle:@"No"
                                                          otherButtonTitles:@"Yes",nil];
                    [alert show];
                    alert.tag = 11;
                    
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                    message:@"ERROR!!!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
            }];
            
        }
     
    }];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            UIStoryboard *storyboard;
            if (IPAD) {
                storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
            }
            else
                storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

            //UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.editBookVC = (EditBookViewController*)
            [storyboard instantiateViewControllerWithIdentifier:@"EditBookViewController"];
            self.editBookVC.bookId = bookObj.objectId;
            [self.navigationController pushViewController:self.editBookVC animated:YES];
            
        }
    }
    
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (IBAction)onClickCancel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do you want to edit book details?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
    alert.tag = 11;

}
@end
