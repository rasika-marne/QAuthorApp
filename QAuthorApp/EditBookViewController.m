//
//  EditBookViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 10/21/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "EditBookViewController.h"

@interface EditBookViewController ()

@end

@implementation EditBookViewController
@synthesize bookId,imageView1,textView1,imageClickbutton,borderImage,bookObj1;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationMethod];
    [self.view setBackgroundColor: RGB];
    isImageEdited = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Tap on image or text to edit it."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
   /* SWRevealViewController *revealController = [self revealViewController];
    UIImage *myImage = [UIImage imageNamed:@"menu-icon.png"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;*/
    
    //remove files from merged/pdf directory
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *layOutPath=[NSString stringWithFormat:@"%@/Merged/PDF",[paths objectAtIndex:0]];
    
    
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:layOutPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", layOutPath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    if (![bookObj1.borderId isEqualToString:@""]||bookObj1.borderId != nil) {
        borderImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",bookObj1.borderId]];
    }
 
    pagePDFArr = [[NSMutableArray alloc]init];
       count = 1;
    pageNumber = 0;
    self.navigationItem.title = [NSString stringWithFormat:@"Page %d",count];
    bookDetailsArr = [[NSMutableArray alloc]init];
    //get book details
    BookDetails *bookDet = [BookDetails createEmptyObject];
    [bookDet fetchBookDetailBlockForBook:bookId block1:^(NSMutableArray *objects, NSError *error) {
        if (!error) {
            bookDetailsArr = objects;
            BookDetails *b1 = [BookDetails createEmptyObject];
            b1 = [bookDetailsArr objectAtIndex:0];
           
                PFFile *imageFile = b1.imageContent;
                if (imageFile && ![b1.imageContent isEqual:[NSNull null]]) {
                    [b1.imageContent getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (data) {
                            [imageView1 setImage:[UIImage imageWithData:data]];
                            textView1.hidden = YES;
                            imageView1.hidden = NO;
                            imageClickbutton.hidden = NO;
                        }
                        
                        
                    }];
                    
                }
                else if(![b1.textContent isEqualToString:@""]||b1.textContent != nil)
                {
                    imageView1.hidden = YES;
                    imageClickbutton.hidden = YES;
                    
                    textView1.hidden = NO;
                    textView1.text = b1.textContent;
                }
            
           

            NSLog(@"book det arr:%@",bookDetailsArr);
            for (int i=0; i<[bookDetailsArr count]; i++) {
                BookDetails *bDetObj = [BookDetails createEmptyObject];
                bDetObj = [bookDetailsArr objectAtIndex:i];
                PFFile *pagePDF = bDetObj.pagePDF;
                [pagePDFArr addObject:pagePDF];
               
            }
            
            //downloads files from parse to merged/pdf directory
            for (int i =0; i<[pagePDFArr count]; i++) {
                PFFile *pagePdf = [pagePDFArr objectAtIndex:i];
                [pagePdf getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if ( data )
                    {
                        
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *layOutPath=[NSString stringWithFormat:@"%@/Merged/PDF",[paths objectAtIndex:0]];
                        
                        //NSString *directroyPath = nil;
                        //directroyPath = [APP_DELEGATE SharedPDFFilesFolderPath];
                        
                        NSString *filePath = [layOutPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/page%d.pdf",i+1]];
                        [[NSFileManager defaultManager] createFileAtPath:filePath
                                                                contents:data
                                                              attributes:nil];
                        //if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                            //[data writeToFile:filePath atomically:YES];
                       // }
                        
                        
                    }
                    

                }];
                //NSURL  *url = [NSURL URLWithString:pagePdf.url];
               
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Do you want to edit border?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes",nil];
            [alert show];
            alert.tag = 12;
            
            
        }
        

    }];
    
    
    // Do any additional setup after loading the view.
}


-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
   // self.title=@"Home";
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
   
    if (selectedBorder != nil) {
        borderImage.image = selectedBorder;
    }
    if (selectedTemplate != nil && isImageEdited == NO) {
        self.imageView1.image = selectedTemplate;
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:self.imageView1.image];
        editor.delegate = self;
        
        [self presentViewController:editor animated:YES completion:nil];        //
       // self.m_oImage.hidden = YES;
        //self.chooseOwnLbl.hidden = YES;
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
    
    
    
    CGContextRef pdfContext = [self createPDFContext:CGRectMake(0, 40, view.frame.size.width, view.frame.size.height) path:(__bridge CFStringRef)(filePath)];
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
    //NSFileManager *fm = [NSFileManager defaultManager];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onPhotoTap:(id)sender
{
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
   

    //[self.m_oImage setImage:image forState:UIControlStateNormal];
    UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.02)];
    [imageView1 setImage:lowResImage];
    
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
    CGSize size = (imageView1.image) ? imageView1.image.size : imageView1.frame.size;
    CGFloat ratio = MIN(self.viewForPdf.frame.size.width / size.width, self.viewForPdf.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    imageView1.frame = CGRectMake(0, 0, W, H);
    imageView1.superview.bounds = imageView1.bounds;
}


- (IBAction)onNextPageClicked:(id)sender {
    pageNumber++;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do you want to edit next page?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
    alert.tag = 11;
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11) {
        if (buttonIndex == 1) {
            if (count<[bookDetailsArr count]) {
                count++;
                if (![bookObj1.borderId isEqualToString:@""]||bookObj1.borderId != nil) {
                    borderImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",bookObj1.borderId]];
                }
                BookDetails *b2 = [BookDetails createEmptyObject];
                b2 = [bookDetailsArr objectAtIndex:pageNumber];
                
                NSLog(@"%@",b2.pageNumber);

                self.navigationItem.title = [NSString stringWithFormat:@"Page %d",count];
                PFFile *imageFile = b2.imageContent;
                if (imageFile && ![b2.imageContent isEqual:[NSNull null]]) {
                    [b2.imageContent getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (data) {
                            [imageView1 setImage:[UIImage imageWithData:data]];
                            textView1.hidden = YES;
                            imageView1.hidden = NO;
                            imageClickbutton.hidden = NO;
                            
                        }
                        
                    }];
                }
                else if(![b2.textContent isEqualToString:@""]||b2.textContent != nil)
                {
                    imageView1.hidden = YES;
                    imageClickbutton.hidden = YES;
                    
                    textView1.hidden = NO;
                    textView1.text = b2.textContent;
                }
                

                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"End of the Book"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }

            
        }
        else if (alertView.tag == 12){
            UIStoryboard *storyboard;
            if (IPAD) {
                storyboard=[UIStoryboard storyboardWithName:@"Main-ipad" bundle:nil];
            }
            else
                storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.addBorderVC = (AddBorderViewController *) [storyboard instantiateViewControllerWithIdentifier:@"AddBorderViewController"];
            [self  presentViewController:self.addBorderVC animated:YES completion:nil];
            

        }
    }
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
#pragma mark - Stop Audio Recording / Playing

-(void)stop
{
    
    [self.recordAudioButton setBackgroundImage:[UIImage imageNamed:RECORD_AUDIO_BUTTON] forState:UIControlStateNormal];
   // self.listenRecorAudioButton.hidden = NO;
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView = textView;
    
    textView.text = @"";
}

- (IBAction)onSaveButtonClicked:(id)sender {
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    PFQuery *query = [PFQuery queryWithClassName:BOOK_DETAILS];
    [query whereKey:BOOK_ID equalTo:bookId];
    [query whereKey:PAGE_NUMBER equalTo:[NSNumber numberWithInt:count]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [object setValue:textView1.text forKey:TEXT_CONTENT];
            UIImage *image = [self scaleAndRotateImage:imageView1.image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
            
            PFFile *imgFile = [PFFile fileWithName:[NSString stringWithFormat:@"page%d.jpg",count] data:imageData];
            if (imageView1 !=nil) {
                [object setObject:imgFile forKey:IMAGE_CONTENT];
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
                PFFile *audioFile = [PFFile fileWithName:[NSString stringWithFormat:@"audio%d.caf",count] data:data];
                [object setValue:audioFile forKey:AUDIO_CONTENT];
            }
            NSString *path= [self createPdftoShare:self.viewForPdf];
            NSData *myData1 = [NSData dataWithContentsOfFile:path];
            PFFile *pdf = [PFFile fileWithName:[NSString stringWithFormat:@"page%d.pdf",count] data:myData1];
            NSLog(@"book id:%@",bookId);
            [object setValue:pdf forKey:PAGE_PDF];

            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
                if (!error) {
                    [APP_DELEGATE stopActivityIndicator];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                    message:@"Page Edited successfully!!!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    BookDetails *b1 = [BookDetails convertPFObjectToBookDetails:object];
                    if (b1.pageNumber == [NSNumber numberWithInt:count]) {
                        [pagePDFArr replaceObjectAtIndex:count-1 withObject:pdf];
                    }
                    
                    
                       // break;
                    NSMutableArray *pathsArr = [[NSMutableArray alloc]init];
                    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *layOutPath1=[NSString stringWithFormat:@"%@/Merged/PDF",[paths1 objectAtIndex:0]];
                    

                    for (int i=1; i<=[bookDetailsArr count]; i++) {
                        NSString *filePath = [layOutPath1 stringByAppendingPathComponent:[NSString stringWithFormat:@"/page%d.pdf",i]];
                        [pathsArr addObject:filePath];
                    }
                    NSLog(@"path arr:%@",pathsArr);
                    NSString *mergePdf = [self joinPDF:pathsArr];
                    //NSString *pdfPath = [self joinPDF:pagePDFArr];
                    NSLog(@"path:%@",mergePdf);
                    NSData *myData = [NSData dataWithContentsOfFile:mergePdf];
                    [APP_DELEGATE startActivityIndicator:self.view];
                    PFQuery *query = [PFQuery queryWithClassName:BOOK];
                    [query getObjectInBackgroundWithId:bookId block:^(PFObject *gObj, NSError *error) {
                        
                        // Now let's update it with some new data. In this case, only cheatMode and score
                        // will get sent to the cloud. playerName hasn't changed.
                        gObj[PDF_FILE] = [PFFile fileWithName:@"Book.pdf" data:myData];
                        [gObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(!error){
                                [APP_DELEGATE stopActivityIndicator];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                message:@"Book Updated successfully!!!"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];

                            }
                        }];
                    }];
                    //alert.tag = 11;
                    
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

@end
