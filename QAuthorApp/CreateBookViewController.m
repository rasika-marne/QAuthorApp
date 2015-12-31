//
//  CreateBookViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "CreateBookViewController.h"

@interface CreateBookViewController ()

@end

@implementation CreateBookViewController
@synthesize imageView1,textView1,ViewToPDF,bookObj,bookDetailsObj,backImage,backImg1;
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    selectedTemplate = nil;
     isImageEdited = NO;
    isImageSelected = NO;
    isTextSelected = NO;
    self.textView1.hidden =YES;
    self.imageView1.hidden = YES;
    self.m_oImage.hidden = YES;
    self.chooseOwnLbl.hidden = YES;
       self.backImage.userInteractionEnabled = NO;
    if (selectedBorder != nil) {
         NSLog(@"border flag:%d",borderImageFlag);
        self.backImage.image = selectedBorder;
        bookObj.borderId = [NSString stringWithFormat:@"border%d",borderImageFlag];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start book"
                                                        message:@"Do you want to add Text or Image?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Text",@"Image",nil];
        alert.tag = 11;
        [alert show];
       
        
        

    }

    count = 1;
    //self.backImage.hidden = YES;
    [self navigationMethod];
   
    [self.view setBackgroundColor: RGB];
    NSLog(@"book obj title:%@",bookObj.title);
    //backImage.image = backImg1;

    
   
    
    /*SWRevealViewController *revealController = [self revealViewController];
    UIImage *myImage = [UIImage imageNamed:@"menu-icon.png"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    

    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;*/
    

    
    //bookObj = [Book createEmptyObject];
    bookDetailsObj = [BookDetails createEmptyObject];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textView1 isFirstResponder] && [touch view] != self.textView1) {
        [self.textView1 resignFirstResponder];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (selectedTemplate != nil && isImageEdited == NO) {
        //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self  selector:@selector(presentImageEditor) userInfo:nil repeats:NO];
        //[timer fire];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:  @selector(presentImageEditor) withObject:nil afterDelay:2.0];
        });

        }
    
    
    
}
-(void)presentImageEditor{
    self.imageView1.image = selectedTemplate;
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:self.imageView1.image];
    editor.delegate = self;
    
    [self presentViewController:editor animated:YES completion:nil];        //
    self.m_oImage.hidden = YES;
    self.chooseOwnLbl.hidden = YES;

}
-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = [NSString stringWithFormat:@"Page %d",count];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            self.textView1.hidden = NO;
            self.imageView1.hidden = YES;
            self.m_oImage.hidden = YES;
            self.chooseOwnLbl.hidden = YES;
            isTextSelected = YES;
            isImageSelected = NO;
            imageView1.image = [UIImage imageNamed:@"book-1"];
        }
        else if (buttonIndex == 2){
            self.textView1.hidden = YES;
            self.imageView1.hidden = NO;
            self.m_oImage.hidden = NO;
            self.chooseOwnLbl.hidden = NO;
            isImageSelected = YES;
            isTextSelected = NO;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*)createPdftoShare:(UIView *)view{
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *layOutPath=[NSString stringWithFormat:@"%@/Merged/PDF",[paths objectAtIndex:0]];
    
    //NSString *directroyPath = nil;
    //directroyPath = [APP_DELEGATE SharedPDFFilesFolderPath];
    
    NSString *filePath = [layOutPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/page%d.pdf",count]];
    NSLog(@"path:%@",filePath);
    // check for the "PDF" directory
    //NSError *error;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:layOutPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:layOutPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    
    CGContextRef pdfContext = [self createPDFContext:CGRectMake(20, 40, view.frame.size.width, view.frame.size.height) path:(__bridge CFStringRef)(filePath)];
    CGContextBeginPage (pdfContext,nil);
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeTranslation(0,view.frame.size.height
                                                 );
    transform = CGAffineTransformScale(transform, 0.8, -0.8);
    CGContextConcatCTM(pdfContext, transform);
    //Draw view into PDF
    [view.layer renderInContext:pdfContext];
    CGContextEndPage (pdfContext);
    CGContextRelease (pdfContext);
    return filePath;
}
- (CGContextRef) createPDFContext:(CGRect)inMediaBox path:(CFStringRef) path{
    CGContextRef myOutContext = NULL;
    CFURLRef url;
    url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle,false);
    if (url != NULL) {
        myOutContext = CGPDFContextCreateWithURL (url,&inMediaBox,NULL);
        CFRelease(url);
    }
    return myOutContext;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView = textView;
    if (textView == activeTextView)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 60), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    //textView.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == activeTextView)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 60), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
- (IBAction)onClickExportBtn:(id)sender {
    count++;
    [self createPdftoShare:ViewToPDF];
}

- (IBAction)viewBookBtnClick:(id)sender
{
   
}

- (IBAction)onClickAddPagesBtn:(id)sender{
    NSString *path = [self createPdftoShare:ViewToPDF];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    NSLog(@"book id:%@",bookObj.objectId);
    bookDetailsObj.pagePDF = [PFFile fileWithName:[NSString stringWithFormat:@"Page%d.pdf",count] data:myData];
    bookDetailsObj.bookId = bookObj.objectId;
    bookDetailsObj.pageNumber = [NSNumber numberWithInteger:count];
    if (isTextSelected == YES) {
        bookDetailsObj.textContent = textView1.text;
          bookDetailsObj.imageContent = nil;
        bookDetailsObj.method = @"Only_Text";
        
    }
    else if (isImageSelected == YES){
        if (imageView1.image != [UIImage imageNamed:@"book-1"]) {
            UIImage *image = [self scaleAndRotateImage:imageView1.image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
            bookDetailsObj.imageContent = [PFFile fileWithName:[NSString stringWithFormat:@"page%d.jpg",count] data:imageData];
            bookDetailsObj.textContent = nil;
            bookDetailsObj.method = @"Only_Image";
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir;
    docsDir = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],ROOTFILENAME];
    

   // NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"audio%d.caf",count]];
    //NSString* audioFilePath = ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:soundFilePath]) {
        NSURL *url = [NSURL fileURLWithPath:soundFilePath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        bookDetailsObj.audioContent = [PFFile fileWithName:[NSString stringWithFormat:@"audio%d.caf",count] data:data];
    }
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    [bookDetailsObj saveBookDetailsBlock:^(id object, NSError *error) {
        if (!error) {
            [APP_DELEGATE stopActivityIndicator];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Book details inserted Successfully!!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
           
            
            count++;
            self.navigationItem.title = [NSString stringWithFormat:@"Page %d",count];
            selectedTemplate = nil;
            self.textView1.hidden =YES;
            self.imageView1.hidden = YES;
            self.m_oImage.hidden = YES;
            
            if (selectedBorder != nil) {
                self.backImage.image = selectedBorder;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start book"
                                                                message:@"Do you want to add Text or Image?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Text",@"Image",nil];
                alert.tag = 11;
                [alert show];
                
            }
            

            textView1.text = @"Type story....";
        
            [self.m_oImage setBackgroundImage:[UIImage imageNamed:@"won-img"] forState:UIControlStateNormal];
            [imageView1 setImage:[UIImage imageNamed:@"book-1"]];
            
        }

    }];
    
   // imageView1.image = [UIImage imageNamed:@"BookCover.jpg"];
    
}

- (IBAction)onFinishBookBtn:(id)sender{
    NSString *path = [self createPdftoShare:ViewToPDF];
    NSData *myData1 = [NSData dataWithContentsOfFile:path];
    NSLog(@"book id:%@",bookObj.objectId);
    bookDetailsObj.pagePDF = [PFFile fileWithName:[NSString stringWithFormat:@"Page%d.pdf",count] data:myData1];
    NSMutableArray *pathsArr = [[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *layOutPath=[NSString stringWithFormat:@"%@/Merged/PDF",[paths objectAtIndex:0]];
    
    
    for (int i=1; i<=count; i++) {
        NSString *filePath = [layOutPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/page%d.pdf",i]];
        [pathsArr addObject:filePath];
    }
    NSLog(@"path arr:%@",pathsArr);
    NSString *mergePdf = [self joinPDF:pathsArr];
    NSLog(@"merged path :%@",mergePdf);
    NSData *myData = [NSData dataWithContentsOfFile:mergePdf];
    [APP_DELEGATE startActivityIndicator:self.view];
    PFQuery *query = [PFQuery queryWithClassName:BOOK];
    [query getObjectInBackgroundWithId:bookObj.objectId block:^(PFObject *gObj, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        gObj[PDF_FILE] = [PFFile fileWithName:[NSString stringWithFormat:@"%@.pdf",gObj[TITLE]] data:myData];
        gObj[BORDER_ID] = [NSString stringWithFormat:@"border%d",borderImageFlag];
        [gObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                NSLog(@"book updated!!");
                
                bookDetailsObj.bookId = bookObj.objectId;
                bookDetailsObj.pageNumber = [NSNumber numberWithInteger:count];
                if (isTextSelected == YES) {
                    bookDetailsObj.textContent = textView1.text;
                    bookDetailsObj.imageContent = nil;
                    bookDetailsObj.method = @"Only_Text";

                }
                else if (isImageSelected == YES){
                                if (imageView1.image != [UIImage imageNamed:@"book-1"]) {
                    UIImage *image = [self scaleAndRotateImage:imageView1.image];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                    bookDetailsObj.imageContent = [PFFile fileWithName:[NSString stringWithFormat:@"page%d.jpg",count] data:imageData];
                                    bookDetailsObj.textContent = nil;
                                    bookDetailsObj.method = @"Only_Image";
                }
                }
                NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *docsDir;
                docsDir = [NSString stringWithFormat:@"%@/%@", [paths1 objectAtIndex:0],ROOTFILENAME];
                
                
                // NSString *documentsDirectoryPath = [paths objectAtIndex:0];
                NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"audio%d.caf",count]];
                NSLog(@"audio urls:%@",soundFilePath);
                //NSString* audioFilePath = ;
                if ([[NSFileManager defaultManager] fileExistsAtPath:soundFilePath]) {
                    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    bookDetailsObj.audioContent = [PFFile fileWithName:[NSString stringWithFormat:@"audio%d.caf",count] data:data];
                }
                [bookDetailsObj saveBookDetailsBlock:^(id object, NSError *error) {
                    if (!error) {
                        [APP_DELEGATE stopActivityIndicator];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"Book created Successfully!!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        NSMutableArray *followersArr = [[NSMutableArray alloc]init];
                        PFQuery *query = [PFQuery queryWithClassName:FAN_FOLLOWERS];
                        [query whereKey:FAN_USER_ID equalTo:[PFUser currentUser].objectId];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (!error) {
                                NSLog(@"objects:%@",objects);
                                
                                for (PFObject *obj in objects) {
                                    [followersArr addObject:[obj objectForKey:@"followers"]];
                                    
                                }
                                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                                NSString *userName = [def objectForKey:@"UserName"];
                                for (int i =0; i<[followersArr count]; i++) {
                                  //  User *userObj=[User convertPFObjectToUser:[followersArr objectAtIndex:i] forNote:NO];
                                    PFQuery *pushQuery = [PFInstallation query];
                                    [pushQuery whereKey:@"userId" equalTo:[followersArr objectAtIndex:i]];
                                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSString stringWithFormat:@"%@ uploaded new book just now!!",userName], @"alert",
                                                          @"Increment", @"badge",
                                                          @"", @"sound",
                                                          nil];
                                    PFPush *push = [[PFPush alloc] init];
                                    [push setQuery:pushQuery];
                                    
                                    [push setChannels:[NSArray arrayWithObjects:@"Messages", nil]];
                                    [push setData:data];
                                    [push sendPushInBackground];
                                }
                                UIStoryboard *storyboard;
                                if (IPAD) {
                                    storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
                                }
                                else
                                    storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
                                // UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                HomeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                                
                                 [self.navigationController pushViewController:vc animated:YES];

                            }
                        }];
                         
                        
                    }
                    
                }];
                

                // [APP_DELEGATE stopActivityIndicator];
                // [self onBack:nil];
                
                //[self fetchAllBooks];
            }
            
        }];
        
    }];

    //bookDetailsObj.pdfFile = [PFFile fileWithData:myData];
    

       //add book to parse table
    NSLog(@"book obj:%@",bookObj);
    NSLog(@"Book created!!!");
    NSLog(@"book title obj:%@",bookObj.title);
   }
- (NSString *)joinPDF:(NSArray *)listOfPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *layOutPath=[NSString stringWithFormat:@"%@/Merged/PDF",[paths objectAtIndex:0]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:layOutPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:layOutPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // File paths
    NSString *fileName = @"SampleBook.pdf";
    NSString *pdfPathOutput = [layOutPath stringByAppendingPathComponent:fileName];
    CFURLRef pdfURLOutput = (__bridge CFURLRef)[NSURL fileURLWithPath:pdfPathOutput];
    NSInteger numberOfPages = 0;
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    for (NSString *source in listOfPath) {
        //        CFURLRef pdfURL = (__bridge CFURLRef)[NSURL fileURLWithPath:source];
        
        CFURLRef pdfURL =  CFURLCreateFromFileSystemRepresentation(NULL, [source UTF8String],[source length], NO);
        
        //file ref
        CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(pdfURL);
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfRef);
        
        // Loop variables
        CGPDFPageRef page;
        CGRect mediaBox;
        
        // Read the first PDF and generate the output pages
        for (int i=1; i<=numberOfPages; i++) {
            page = CGPDFDocumentGetPage(pdfRef, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        CGPDFDocumentRelease(pdfRef);
        CFRelease(pdfURL);
    }
    // CFRelease(pdfURLOutput);
    //
    //    // Finalize the output file
    CGPDFContextClose(writeContext);
    CGContextRelease(writeContext);
   // NSFileManager *fm = [NSFileManager defaultManager];
    //NSString *directory = [[self documentsDirectory] stringByAppendingPathComponent:@"Photos/"];
   /* NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:layOutPath error:&error]) {
        NSRange range = [file rangeOfString:@"page"];
        if (range.location != NSNotFound)
        {
            BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", layOutPath, file] error:&error];
            if (!success || error) {
                // it failed.
            }
            //range.location is start of substring
            //range.length is length of substring
        }
        
        
        
    }*/
    return pdfPathOutput;
}
- (IBAction)recordAudio:(id)sender
{
    [self resignKeyboard];
    UIButton *button=(UIButton*)sender;
    if (button.tag == RECORD_BUTTON_TAG) {
        [self startRecording];
        button.tag = STOP_RECORDING_BUTTON_TAG;
    }
    else{
        [self stop];
        self.recordAudioButton.hidden = NO;
        button.tag = RECORD_BUTTON_TAG;
    }
    
}

-(void)resignKeyboard
{
    if (activeTextView) {
        [activeTextView resignFirstResponder];
        activeTextView = nil;
    }
}

- (IBAction)onPhotoTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Add image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Gallary",@"Choose Template", nil];
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
/*-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (buttonIndex == 1) {
 UIImagePickerController * pImagePickerController = [[UIImagePickerController alloc] init];
 pImagePickerController.delegate = (id)self;
 pImagePickerController.sourceType=  UIImagePickerControllerSourceTypePhotoLibrary;
 [self presentViewController:pImagePickerController animated:YES completion:nil];
 } else if (buttonIndex == 2) {
 UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
 [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
 }
 //   [imagePickerController setShowsCameraControls:YES];
 //[imagePickerController setAllowsEditing:YES];
 // image picker needs a delegate,
 [imagePickerController setDelegate:(id)self];
 // Place image picker on the screen
 [self presentViewController:imagePickerController animated:YES completion:nil];
 }
 }*/


#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage * pImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation orient = pImage.imageOrientation;
    if (orient != UIImageOrientationUp) {
        UIGraphicsBeginImageContextWithOptions(pImage.size, NO, pImage.scale);
        [pImage drawInRect:(CGRect){0, 0, pImage.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        pImage = normalizedImage;
    }
    
    // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor=[[CLImageEditor alloc] initWithImage:pImage delegate:self];
    //[self.navigationController pushViewController:editor animated:YES];
    //[picker presentViewController:editor animated:YES completion:nil];
    [picker pushViewController:editor animated:YES];
    
    
    
}

#pragma mark - CLImageEditor Delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    
    isImageEdited = YES;
    if (image) {
        self.m_oImage.hidden = YES;
        self.chooseOwnLbl.hidden = YES;
    }
    else
    {
        self.m_oImage.hidden = NO;
        self.chooseOwnLbl.hidden = NO;
    }
   // self.backImage.hidden = NO;
    
    //[self.m_oImage setImage:image forState:UIControlStateNormal];
    UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.02)];
    
    
    [imageView1 setImage:lowResImage];
  //  CGRect myImageRect = CGRectMake(imageView1.frame.origin.x-10, imageView1.frame.origin.y-10, imageView1.frame.size.width+10,imageView1.frame.size.height+10);
   // self.backImage.frame = myImageRect;
  //  [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    isImageEdited = NO;
    [self refreshImageView];
}
- (void)refreshImageView
{
    [self resetImageViewFrame];
    //[self resetZoomScaleWithAnimate:NO];
}

- (void)resetImageViewFrame
{
    CGSize size = (imageView1.image) ? imageView1.image.size : imageView1.frame.size;
    CGFloat ratio = MIN(backImage.frame.size.width / size.width, backImage.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    imageView1.frame = CGRectMake(0, 0, W, H);
    imageView1.superview.bounds = imageView1.bounds;
}



#pragma mark - Start Audio Recording

-(void)startRecording
{
    if (self.storySoundFilePath.length>0) {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Already recorded file is available, Are you sure you want record new file?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = AUDIO_RECORD_BUTTON_INDEX;
        [alert show];
        
    }
    else{
        //self.isForRecordAudio = NO;
        [self.recordAudioButton setBackgroundImage:[UIImage imageNamed:RECORD_AUDIO_START_BUTTON] forState:UIControlStateNormal];
        if (!self.audioPlayerObject) {
            self.audioPlayerObject = [[StoryAudioPlayer alloc]init];
        }
        [self.audioPlayerObject recordAudio:[self saveSoundFile]];
        
    }
    
}
#pragma mark - Listen Audio

/*-(void)listenAudio
{
    if (!self.audioPlayerObject) {
        self.audioPlayerObject = [[StoryAudioPlayer alloc]init];
    }
    
       //UInt32 audioEffect;
    NSString* audioUrlString = [kUserDefaults getAudioFilePathName];
    NSURL* soundURL;
    
    if (self.storySoundFilePath.length>0) {
        soundURL  = [NSURL fileURLWithPath:self.storySoundFilePath];
    }
    else if(audioUrlString.length>0)
    {
        soundURL  = [NSURL fileURLWithPath:audioUrlString];
    }
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    AudioServicesDisposeSystemSoundID(audioEffect);
    [self.audioPlayerObject playAudio:soundURL];
    //self.isForRecordAudio = NO;
}*/

#pragma mark - Stop Audio Recording / Playing

-(void)stop
{
    
    [self.recordAudioButton setBackgroundImage:[UIImage imageNamed:RECORD_AUDIO_BUTTON] forState:UIControlStateNormal];
    self.listenRecorAudioButton.hidden = NO;
    if (!self.audioPlayerObject) {
        self.audioPlayerObject = [[StoryAudioPlayer alloc]init];
    }
    [self.audioPlayerObject stopRecording];
    //self.isForRecordAudio = YES;
}
#pragma mark - Save Audio File

-(NSURL*) saveSoundFile
{
    SaveFile* saveFileObject = [[SaveFile alloc]init];
    self.storyId = [NSString stringWithFormat:@"%d",count];
    NSURL* soundFileURL = [saveFileObject saveSoundFile:self.storyId];
    return soundFileURL;
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

@end
