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
@synthesize bookId,imageView1,textView1;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: RGB(114, 197, 213)]; 
    count = 1;
      self.navigationItem.title = [NSString stringWithFormat:@"Page %d",count];
    bookDetailsArr = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    //get book details
    BookDetails *bookDet = [BookDetails createEmptyObject];
    [bookDet fetchBookDetailBlockForBook:bookId block1:^(NSMutableArray *objects, NSError *error) {
        if (!error) {
            bookDetailsArr = objects;
            NSLog(@"book det arr:%@",bookDetailsArr);
            BookDetails *b1 = [BookDetails createEmptyObject];
            b1 = [bookDetailsArr objectAtIndex:0];
            PFFile *imageFile = b1.imageContent;
            if (imageFile && ![b1.imageContent isEqual:[NSNull null]]) {
                [b1.imageContent getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (data) {
                        [imageView1 setImage:[UIImage imageWithData:data]];
                    }
                    
                }];
            }

            textView1.text = b1.textContent;
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createPdftoShare:(UIView *)view{
    
    
    
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
    NSFileManager *fm = [NSFileManager defaultManager];
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
            if ([bookDetailsArr count]>count) {
                count++;
                BookDetails *b2 = [BookDetails createEmptyObject];
                b2 = [bookDetailsArr objectAtIndex:count];
                self.navigationItem.title = [NSString stringWithFormat:@"Page %d",count];
                PFFile *imageFile = b2.imageContent;
                if (imageFile && ![b2.imageContent isEqual:[NSNull null]]) {
                    [b2.imageContent getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (data) {
                            [imageView1 setImage:[UIImage imageWithData:data]];
                        }
                        
                    }];
                }
                
                textView1.text = b2.textContent;
            }

            
        }
    }
}

- (IBAction)onSaveButtonClicked:(id)sender {
}
@end
