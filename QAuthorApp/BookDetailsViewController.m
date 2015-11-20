//
//  BookDetailsViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 10/8/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "BookDetailsViewController.h"

@interface BookDetailsViewController ()
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation BookDetailsViewController
@synthesize bookObj1,authorName;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor: RGB];
    [self navigationMethod];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;
    [bookObj1.coverPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self.bookCoverImg setImage:[UIImage imageWithData:data]];
        self.bookCoverImg.contentMode =UIViewContentModeScaleAspectFit;
        
    }];
    self.bookDescLbl.text = bookObj1.shortDesc;
    self.bookGenreLbl.text = bookObj1.genre;
    self.authorNameLbl.text = authorName;
    self.bookTitleLbl.text = bookObj1.title;
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
   
    
    //if ([self.interstitial isReady]) {
      //  [self.interstitial presentFromRootViewController:self];
   // }
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [self.interstitial presentFromRootViewController:self];

}

/*- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:AD_Full_Screen_Unit_id];
    
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [interstitial loadRequest:request];
    //request.testDevices = @[@"2077ef9a63d2b398840261c8221a0c9b"];
    
    return interstitial;
}*/
- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.readBookVC = (ReadBookViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"ReadBookViewController"];
    self.readBookVC.bookObj2 = bookObj1;
    [self.navigationController pushViewController:self.readBookVC animated:YES];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    // [self.interstitial delete:interstitial];
}

-(void)navigationMethod{
    [self.view setBackgroundColor: RGB]; //will give a UIColor
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    //self.title=@"Home";
    self.navigationItem.title = @"Book Details";
    self.navigationController.navigationBar.barTintColor =NAVIGATIONRGB;
    
    
    //  UIImage *image = [UIImage imageNamed:@"nav-bar"];
    //self.navigationController.navigationBar.barTintColor =[UIColor colorWithPatternImage:image];
    
    self.navigationController.navigationBar.barStyle =UIBarStyleBlack;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onReadBookButtonClick:(id)sender{
    // self.interstitial = [self createAndLoadInterstitial];
   self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:AD_Full_Screen_Unit_id];
    
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];

    //if ([self.interstitial isReady]) {
                 // }
  /*  UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.readBookVC = (ReadBookViewController *)
    [storyboard instantiateViewControllerWithIdentifier:@"ReadBookViewController"];
    self.readBookVC.bookObj2 = bookObj1;
    [self.navigationController pushViewController:self.readBookVC animated:YES];*/

}
- (IBAction)onDownloadBookButtonClick:(id)sender{
   NSString *fileName = @"SampleBook.pdf";
    [self showEmail:fileName];
}
- (void)showEmail:(NSString*)file {
    
    NSString *emailTitle = bookObj1.title;
    NSString *messageBody = bookObj1.shortDesc;
    NSArray *toRecipents = [NSArray arrayWithObject:@"rasikabs1@gmail.com"];
    
   
   
    
    
    if([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate=self;
       // [mail setSubject:@"Email with attached pdf"];
        [APP_DELEGATE startActivityIndicator:self.view];
        PFFile * imageFile = bookObj1.pdfFile; // note the modern Obj-C syntax
        if (imageFile && ![bookObj1.pdfFile isEqual:[NSNull null]]) {
            [bookObj1.pdfFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data) {
                    [APP_DELEGATE stopActivityIndicator];
                    [mail addAttachmentData:data mimeType:@"application/pdf" fileName:file];
                    [mail setSubject:emailTitle];
                    [mail setMessageBody:messageBody isHTML:NO];
                    [mail setToRecipients:toRecipents];
                    [self presentViewController:mail animated:YES completion:nil];
                }
               

                
            }];
        }
       /* PFFile * imageFile = bookObj1.pdfFile; // note the modern Obj-C syntax
        if (imageFile && ![bookObj1.pdfFile isEqual:[NSNull null]]) {
            NSURL *pdfUrl = [NSURL URLWithString:imageFile.url];
            NSData *data = [NSData dataWithContentsOfURL:pdfUrl];
            [mail addAttachmentData:data mimeType:@"application/pdf" fileName:file];
            [mail setSubject:emailTitle];
            [mail setMessageBody:messageBody isHTML:NO];
            [mail setToRecipients:toRecipents];
            [self presentViewController:mail animated:YES completion:nil];
            
        }*/
       
        //NSData * pdfData = [NSData dataWithContentsOfFile:pdfPathOutput];
      //  NSString * body = @"";
        //[mail setMessageBody:body isHTML:NO];
                //[mail release];
    }
    else
    {
        //NSLog(@"Message cannot be sent");
    }
    // Determine the MIME type
       // Present mail view controller on screen
   // [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
