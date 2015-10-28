//
//  BookTitleViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 10/1/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "BookTitleViewController.h"

@interface BookTitleViewController ()

@end

@implementation BookTitleViewController
@synthesize genreSelect,BackImage,backImg1;
- (void)viewDidLoad {
    [super viewDidLoad];
    ownPhotoTap = NO;
    self.navigationItem.title = @"Create Book";
    BackImage.image = backImg1;
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    self.pickerData = [[NSMutableArray alloc]init];
    book = [Book createEmptyObject];
    user =[User createEmptyUser];
    user = APP_DELEGATE.loggedInUser;
    [user.profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self.authorImg setImage:[UIImage imageWithData:data]];
        self.authorImg.contentMode =UIViewContentModeScaleAspectFit;
        
    }];
    //book.authorId = user;
    
    self.authorNameLbl.text = user.firstName;
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
    
       // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    if (selectedTemplate == nil && ownPhotoTap == NO) {
        self.bookCoverImg.hidden = YES;
        self.templateButton.hidden = NO;
        self.ownPhoto.hidden = NO;
        self.orLabel.hidden = NO;
    }
    else{
        
        self.bookCoverImg.hidden = NO;
        self.bookCoverImg.image = selectedTemplate;
        self.templateButton.hidden = YES;
        self.ownPhoto.hidden = YES;
        self.orLabel.hidden = YES;

    }
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        
        return YES;
    }
    
    [textView resignFirstResponder];
    return NO;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
   // activeTextView = textView;
    
    textView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onNextButtonClick:(id)sender{
    user =[User createEmptyUser];
   // NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //user = [def objectForKey:@"loggedInUser"];
    
    user = APP_DELEGATE.loggedInUser;

     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ageRange = [AgeRange createEmptyObject];
    NSLog(@"user age:%d",[user.age intValue]);
    // NSArray *rangeArr;
    [ageRange fetchAgeRangeBlock:^(NSMutableArray *objects, NSError *error) {
        if (!error) {
            //rangeArr = objects;
            for (int i=0; i<[objects count]; i++) {
                ageRange = [objects objectAtIndex:i];
                if (([user.age intValue] > [ageRange.ageFrom intValue]) && ([user.age intValue] < [ageRange.ageTo intValue])) {
                    book.ageFrom = ageRange.ageFrom;
                    book.ageTo = ageRange.ageTo;
                    break;
                }
            }
            book.title = self.bookTitleTextField.text;
            if (self.bookCoverImg.image != [UIImage imageNamed:@"BookCover.jpg"]) {
                UIImage *image = [self scaleAndRotateImage:self.bookCoverImg.image];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                book.coverPic = [PFFile fileWithName:@"CoverPage.jpg" data:imageData];
                
                
            }
            // PFUser *user1=[PFUser objectWithoutDataWithObjectId:[NSString stringWithFormat:@"%@",user.objectId]];
            
            //laundryObj[@"liaisonId"] = user; // shows up as Pointer
            book.authorId = [PFUser currentUser];
            // book.ageFrom = ageRange.ageFrom;
            // book.ageTo = ageRange.ageTo;
            book.genre =self.genreTextField.text;
            book.shortDesc = self.shortDescTextView.text;
            book.status = @"active";
            book.type = @"Normal";
            NSLog(@"Book obj:%@",book);
            [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
            [book saveBooksBlock:^(Book *object, NSError *error) {
                if (!error) {
                    [APP_DELEGATE stopActivityIndicator];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                    message:@"Book created Successfully!!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    NSLog(@"Book obj id:%@",object.objectId);
                    book = object;
                    self.createBookVC = (CreateBookViewController *)
                    [storyboard instantiateViewControllerWithIdentifier:@"CreateBookViewController"];
                    NSLog(@"book obj:%@",book);
                    NSLog(@"book title obj:%@",book.title);
                    self.createBookVC.backImg1 = [[UIImage alloc]init];
                    self.createBookVC.backImg1 = backImg1;
                    self.createBookVC.bookObj = [Book createEmptyObject];
                    self.createBookVC.bookObj = book;
                    [self.navigationController pushViewController:self.createBookVC animated:YES];
                    
                }
            }];
            

        }
    }];

    
   
}

- (IBAction)onPhotoTap:(id)sender
{
    
   

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    [sheet showInView:self.view.window];
    
}
#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
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
#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ownPhotoTap = YES;
    UIImage * pImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation orient = pImage.imageOrientation;
    if (orient != UIImageOrientationUp) {
        UIGraphicsBeginImageContextWithOptions(pImage.size, NO, pImage.scale);
        [pImage drawInRect:(CGRect){0, 0, pImage.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pImage = normalizedImage;
    }
    selectedTemplate = pImage;
        [self.bookCoverImg setImage:pImage];
    self.bookCoverImg.contentMode = UIViewContentModeScaleAspectFit;
        [picker dismissViewControllerAnimated:YES completion:nil];
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     book.title = self.bookTitleTextField.text;
    [textField resignFirstResponder];
    return YES;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickChooseTemplate:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.chooseTemplateVC = (ChooseTemplateViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ChooseTemplateViewController"];
    [self  presentViewController:self.chooseTemplateVC animated:YES completion:nil];
}
@end