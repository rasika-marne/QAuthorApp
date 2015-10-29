//
//  HomeViewController.m
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//
@import GoogleMobileAds;
#import "HomeViewController.h"
#import "AppDelegate.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize pickerData;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.adUnitID = @"ca-app-pub-5468147316620707/4430610672";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    self.bookSegments.selectedSegmentIndex =0;
    myBooksClicked = NO;
    professionalClicked = NO;
   // [self setupMenuBarButtonItems];
    ageRange = [AgeRange createEmptyObject];
    pickerData = [[NSMutableArray alloc]init];
   // NSLog(@"user age:%d",[user.age intValue]);
    // NSArray *rangeArr;
    [ageRange fetchAgeRangeBlock:^(NSMutableArray *objects, NSError *error) {
        if (!error) {
            for (int i=0; i<[objects count]; i++) {
                ageRange = [objects objectAtIndex:i];
                NSString *str1 = [NSString stringWithFormat:@"%d",[ageRange.ageFrom intValue]];
                NSString *str2 = [NSString stringWithFormat:@"%d",[ageRange.ageTo intValue]];
                NSString *rangeStr = [NSString stringWithFormat:@"%@-%@",str1,str2];
                [pickerData addObject:rangeStr];
            }
            
        }
    
     
    }];
    self.ageRangeSelect = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    self.ageRangeSelect.showsSelectionIndicator = YES;
    // languageSelect.hidden = NO;
    self.ageRangeSelect.delegate = self;
    self.ageRangeTextField.inputView = self.ageRangeSelect;   // [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];
    
    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *leftRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = leftRevealButtonItem;

    // Do any additional setup after loading the view.
}
- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if ([SelectedSegmentvalue isEqualToString:@"Professional"]) {
        if (selectedSegment == 0) {
            [self fetchProfessionalBooks];
        }
        else{
            [self fetchMyFavorites];
        }

    }
    else{
        if (selectedSegment == 0) {
            [self fetchAllBooks];
        }
        else{
            [self fetchMyFeeds];
        }
    }
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return [pickerData count];
}

////-----------UIPickerViewDelegate
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
    self.ageRangeTextField.text = [pickerData objectAtIndex:row];
    [[self view]endEditing:YES];
    NSArray *arr = [self.ageRangeTextField.text componentsSeparatedByString:@"-"];
    NSString *ageFrom = [arr objectAtIndex:0];
    NSString *ageTo = [arr objectAtIndex:1];
    PFQuery *query2 = [PFQuery queryWithClassName:BOOK];
    [query2 whereKey:AGE_FROM equalTo:[NSNumber numberWithInt:[ageFrom intValue]]];
    [query2 whereKey:AGE_TO equalTo:[NSNumber numberWithInt:[ageTo intValue]]];
    [query2 includeKey:AUTHOR_ID];
    [query2 orderByDescending:NUMBER_OF_LIKES];

    //[query2 includeKey:AUTHOR_ID];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *results=[[NSMutableArray alloc] init];
        for (PFObject *obj in objects) {
            Book *events=[Book convertPFObjectToBooks:obj];
            //  User *author = [];
            [results addObject:events];
            NSLog(@"book obj:%@",events);
            NSLog(@"res cnt:%lu",(unsigned long)[results count]);
        }
        booksArray = results;
        if ([booksArray count]>0) {
            authorNamesArr = [[NSMutableArray alloc]init];
            for (Book *bObj in booksArray) {
                User *userObj=[User convertPFObjectToUser:bObj.authorId forNote:NO];
                authorName =[NSString stringWithFormat:@"%@ %@",userObj.firstName,userObj.lastName
                             ];
                // if ([authorNamesArr containsObject:authorName]) {
                // continue;                            }
                // else{
                [authorNamesArr addObject:authorName];
                //}
                
                
            }
            [self.bookListTableView reloadData];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"No books right now."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = 11;
            [alert show];

        }
        
        NSLog(@"my books cnt:%lu",(unsigned long)[booksArray count]);
    }];
    //    [languageSelect removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *userId = [def valueForKey:@"userId"];
    if([userId length] > 0){
        PFQuery *query = [PFUser query];
        [query whereKey:USER_OBJECT_ID equalTo:userId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                APP_DELEGATE.loggedInUser = [User convertPFObjectToUser:object forNote:YES];
                if ([SelectedSegmentvalue isEqualToString:@"My Books"]) {
                    [self fetchMyBooks];
                    // self.bookSegments.selectedSegmentIndex = 1;
                    self.navigationController.navigationBar.hidden = NO;
                    self.navigationItem.title = @"My Books";
                    self.bookSegments.hidden = YES;
                    
                }
                else if([SelectedSegmentvalue isEqualToString:@"Professional"]){
                    [self fetchProfessionalBooks];
                    self.navigationController.navigationBar.hidden = NO;
                    self.navigationItem.title = @"Professional";
                    self.bookSegments.hidden = NO;
                }
                else{
                    [self fetchAllBooks];
                    self.navigationController.navigationBar.hidden = NO;
                    self.navigationItem.title = @"Home";
                    self.bookSegments.hidden = NO;
                    
                }
                
            }
            
        }];

    }
    
   // [self fetchAuthors];
    
}
-(void)fetchMyFavorites{
   
    User *user = APP_DELEGATE.loggedInUser;
    NSMutableArray *favAuthors = [[NSMutableArray alloc]init];
    if ([user.favoriteAuthor1 length]>0) {
        [favAuthors addObject:user.favoriteAuthor1];
    }
    if ([user.favoriteAuthor2 length]>0) {
        [favAuthors addObject:user.favoriteAuthor2];
    }
    if ([user.favoriteAuthor3 length]>0) {
        [favAuthors addObject:user.favoriteAuthor3];
    }
    PFQuery *query2 = [PFQuery queryWithClassName:BOOK];
    [query2 whereKey:AUTHOR_NAME containedIn:favAuthors];
    [query2 includeKey:AUTHOR_ID];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *results=[[NSMutableArray alloc] init];
        for (PFObject *obj in objects) {
            Book *events=[Book convertPFObjectToBooks:obj];
            //  User *author = [];
            [results addObject:events];
            NSLog(@"book obj:%@",events);
            NSLog(@"res cnt:%lu",(unsigned long)[results count]);
        }
        booksArray = results;
        if ([booksArray count]>0) {
            
            authorNamesArr = [[NSMutableArray alloc]init];
            for (Book *bObj in booksArray) {
                User *userObj=[User convertPFObjectToUser:bObj.authorId forNote:NO];
                authorName =[NSString stringWithFormat:@"%@ %@",userObj.firstName,userObj.lastName
                             ];
                // if ([authorNamesArr containsObject:authorName]) {
                // continue;                            }
                // else{
                [authorNamesArr addObject:authorName];
                //}
                
                
            }
            [self.bookListTableView reloadData];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"No books right now."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            // alert.tag = 12;
            [alert show];
            
        }
        NSLog(@"professional books cnt:%lu",(unsigned long)[booksArray count]);
    }];

    
}
-(void)fetchProfessionalBooks{
    professionalClicked = YES;
    PFQuery *query2 = [PFQuery queryWithClassName:BOOK];
    [query2 whereKey:TYPE equalTo:@"Professional"];
     [query2 includeKey:AUTHOR_ID];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *results=[[NSMutableArray alloc] init];
        for (PFObject *obj in objects) {
            Book *events=[Book convertPFObjectToBooks:obj];
            //  User *author = [];
            [results addObject:events];
            NSLog(@"book obj:%@",events);
            NSLog(@"res cnt:%lu",(unsigned long)[results count]);
        }
        booksArray = results;
        if ([booksArray count]>0) {
            
            authorNamesArr = [[NSMutableArray alloc]init];
            for (Book *bObj in booksArray) {
                User *userObj=[User convertPFObjectToUser:bObj.authorId forNote:NO];
                authorName =[NSString stringWithFormat:@"%@ %@",userObj.firstName,userObj.lastName
                             ];
                // if ([authorNamesArr containsObject:authorName]) {
                // continue;                            }
                // else{
                [authorNamesArr addObject:authorName];
                //}
                
                
            }
            [self.bookListTableView reloadData];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"No books right now."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
           // alert.tag = 12;
            [alert show];
            
        }
        NSLog(@"professional books cnt:%lu",(unsigned long)[booksArray count]);
    }];

    //if (self.bookSegments.selectedSegmentIndex == 1) {
    [self.bookSegments setTitle:@"All" forSegmentAtIndex:0];
    [self.bookSegments setTitle:@"My Favorites" forSegmentAtIndex:1];

   // }
}
-(void)fetchMyBooks{
     
    
    myBooksClicked = YES;
   // PFQuery *query1 = [PFQuery queryWithClassName:USER];
    
    PFQuery *query2 = [PFQuery queryWithClassName:BOOK];
    [query2 whereKey:AUTHOR_ID equalTo:[PFUser currentUser]];
    [query2 includeKey:AUTHOR_ID];
    [query2 orderByDescending:NUMBER_OF_LIKES];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *results=[[NSMutableArray alloc] init];
        for (PFObject *obj in objects) {
            Book *events=[Book convertPFObjectToBooks:obj];
            //  User *author = [];
            [results addObject:events];
            NSLog(@"book obj:%@",events);
            NSLog(@"res cnt:%lu",(unsigned long)[results count]);
        }
        booksArray = results;
        if ([booksArray count]>0) {
            
            authorNamesArr = [[NSMutableArray alloc]init];
            for (Book *bObj in booksArray) {
                User *userObj=[User convertPFObjectToUser:bObj.authorId forNote:NO];
                authorName =[NSString stringWithFormat:@"%@ %@",userObj.firstName,userObj.lastName
                             ];
                // if ([authorNamesArr containsObject:authorName]) {
                // continue;                            }
                // else{
                [authorNamesArr addObject:authorName];
                //}
                
                
            }
            [self.bookListTableView reloadData];

        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"No books right now."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            alert.tag = 12;
            [alert show];
            
        }

               /* PFObject *firstObject = [((PFObject*)[objects firstObject]) objectForKey:AUTHOR_ID];
        
        [query1 whereKey:@"objectId" equalTo:firstObject.objectId];
        
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            //Getting the objects correctly from the class Object!
        }];*/
       // booksArray = [objects mutableCopy];
                NSLog(@"my books cnt:%lu",(unsigned long)[booksArray count]);
    }];

}
-(void)fetchMyFeeds{
    followingsArr = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:FAN_FOLLOWERS];
    [query whereKey:FOLLOWERS equalTo:[PFUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"objects:%@",objects);
            
            for (PFObject *obj in objects) {
                [followingsArr addObject:[obj objectForKey:@"userId"]];
            }
                PFQuery *query2 = [PFQuery queryWithClassName:BOOK];
                PFQuery *userQuery = [PFUser query];
                [userQuery whereKey:USER_OBJECT_ID containedIn:followingsArr];
                [query2 whereKey:AUTHOR_ID matchesQuery:userQuery];
                [query2 whereKey:TYPE equalTo:@"Normal"];
                       // PFQuery *query2 = [PFQuery queryWithClassName:BOOK];
                        //[query2 whereKey:AUTHOR_ID equalTo:userObj1];
                        [query2 includeKey:AUTHOR_ID];
                        [query2 orderByDescending:NUMBER_OF_LIKES];
                        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            NSMutableArray *results=[[NSMutableArray alloc] init];
                            for (PFObject *obj in objects) {
                                Book *events=[Book convertPFObjectToBooks:obj];
                                //  User *author = [];
                                [results addObject:events];
                                NSLog(@"book obj:%@",events);
                                NSLog(@"res cnt:%lu",(unsigned long)[results count]);
                            }
                            booksArray = results;
                            if ([booksArray count]>0) {
                                
                                authorNamesArr = [[NSMutableArray alloc]init];
                                for (Book *bObj in booksArray) {
                                    User *userObj=[User convertPFObjectToUser:bObj.authorId forNote:NO];
                                    authorName =[NSString stringWithFormat:@"%@ %@",userObj.firstName,userObj.lastName
                                                 ];
                                    // if ([authorNamesArr containsObject:authorName]) {
                                    // continue;                            }
                                    // else{
                                    [authorNamesArr addObject:authorName];
                                    //}
                                    
                                    
                                }
                                [self.bookListTableView reloadData];
                                
                            }
                            else{
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                message:@"No books right now."
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                alert.tag = 12;
                                [alert show];
                                
                            }
                            
                            /* PFObject *firstObject = [((PFObject*)[objects firstObject]) objectForKey:AUTHOR_ID];
                             
                             [query1 whereKey:@"objectId" equalTo:firstObject.objectId];
                             
                             [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                             //Getting the objects correctly from the class Object!
                             }];*/
                            // booksArray = [objects mutableCopy];
                            NSLog(@"my books cnt:%lu",(unsigned long)[booksArray count]);
                        }];
                        


                    }
        
                
           }];
}
-(void)fetchAllBooks{
    myBooksClicked = NO;
    professionalClicked = NO;
    [APP_DELEGATE startActivityIndicator:APP_DELEGATE.window];
    bObjectIdArr = [[NSMutableArray alloc]init];
    booksArray = [[NSMutableArray alloc]init];
    searchResults = [[NSMutableArray alloc]init];
    authorNamesArr = [[NSMutableArray alloc]init];
   // cityArr = [[NSMutableArray alloc]init];
    bookObj = [Book createEmptyObject];
    [bookObj fetchBookBlock:^(NSMutableArray *objects, NSError *error) {
        
        
        if (!error) {
            
            NSLog(@"books arr cnt:%lu",(unsigned long)[objects count]);
            if ([objects count]==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"No books right now.Please create and upload it."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag = 10;
                [alert show];
                
            }
            else{
                
                
                booksArray = objects;
                searchResults = objects;
               // __block int successcount;
               // __block int failurecount;
              //  successcount =0;
              //  failurecount =0;
                
                for (Book *bObj in booksArray) {
                    [bObjectIdArr addObject:bObj.objectId];
                    User *userObj=[User convertPFObjectToUser:bObj.authorId forNote:NO];
                       authorName =[NSString stringWithFormat:@"%@ %@",userObj.firstName,userObj.lastName
                                    ];
                    [authorNamesArr addObject:authorName];
                   
                           // if ([authorNamesArr containsObject:authorName]) {
                               // continue;                            }
                           // else{
                    
                            //}
                    
                    
                }
             //   NSLog(@"author arr cnt:%d",[authorNamesArr count]);
                //[searchResults addObjectsFromArray:cityArr];
                NSLog(@"search res :%lu",(unsigned long)[searchResults count]);
                [self.bookListTableView reloadData];
                
                
                
        }
            [APP_DELEGATE stopActivityIndicator];
            
        }
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.bookTitleVC = (BookTitleViewController *)
            [storyboard instantiateViewControllerWithIdentifier:@"BookTitleViewController"];
            
            [self.navigationController pushViewController:self.bookTitleVC animated:YES];
            //[PFUser requestPasswordResetForEmailInBackground: [alertView textFieldAtIndex:0].text];
            
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [booksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    bookObj = [booksArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"BookListTableViewCell";
    
    self.bookListCell = (BookListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (self.bookListCell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BookListTableViewCell" owner:self options:nil];
        self.bookListCell = [nib objectAtIndex:0];
        
    }
   // NSString *str2;
  //  NSLog(@"authorId:%@",bookObj.authorId);
    if (myBooksClicked == YES) {
        self.bookListCell.editButton.hidden = NO;
        [self.bookListCell.editButton addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.bookListCell.editButton.tag = indexPath.row;
    }
    else
    {
        self.bookListCell.editButton.hidden = YES;
    }
    if (professionalClicked == YES) {
        self.bookListCell.priceLbl.hidden = NO;
        self.bookListCell.priceLbl.text = [NSString stringWithFormat:@"Price %@",bookObj.price];
        self.bookListCell.buyButton.hidden = NO;
        [self.bookListCell.buyButton addTarget:self action:@selector(btnBuyClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.bookListCell.buyButton.tag = indexPath.row;

    }
    else
    {
        self.bookListCell.priceLbl.hidden = YES;
        self.bookListCell.buyButton.hidden = YES;
    }


    self.bookListCell.userNameLbl.text = [authorNamesArr objectAtIndex:indexPath.row];
    self.bookListCell.bokkNameLbl.text = bookObj.title;
    self.bookListCell.bookDesc.text = bookObj.shortDesc;
    self.bookListCell.genreNameLbl.text = bookObj.genre;
    
    NSString *str =  [NSString stringWithFormat:@"Age %d-%d",[bookObj.ageFrom intValue],[bookObj.ageTo intValue]];
    self.bookListCell.ageRangeLbl.text = str;
    self.bookListCell.likesCntLbl.text = [NSString stringWithFormat:@"%ld",(long)[bookObj.noOfLikes integerValue]];
;
    self.bookListCell.commentsCntLbl.text = [NSString stringWithFormat:@"%ld",(long)[bookObj.noOfComments integerValue]];
    
    PFFile * imageFile = bookObj.coverPic; // note the modern Obj-C syntax
    if (imageFile && ![bookObj.coverPic isEqual:[NSNull null]]) {
    [bookObj.coverPic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            [self.bookListCell.bookCoverImg setImage:[UIImage imageWithData:data]];
        }
        
    }];
    }
    [self.bookListCell.likeButton addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.bookListCell.likeButton.tag = indexPath.row;
    [self.bookListCell.commentButton addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.bookListCell.commentButton.tag = indexPath.row;
    [self.bookListCell.shareButton addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.bookListCell.shareButton.tag = indexPath.row;


    return self.bookListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     SELECTEDBOOKID=[[NSString alloc]initWithString:[bObjectIdArr objectAtIndex:indexPath.row]];
    bookObj = [booksArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.bookDetailVC = (BookDetailsViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"BookDetailsViewController"];
    self.bookDetailVC.bookObj1 = [Book createEmptyObject];
    self.bookDetailVC.bookObj1 = bookObj;
    self.bookDetailVC.authorName = [authorNamesArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.bookDetailVC animated:YES];
    
    //[PFUser requestPasswordResetForEmailInBackground: [alertView textFieldAtIndex:0].text];
    
    
}
-(void)btnEditClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    bookObj = [booksArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.editBookTitleVC = (EditBookTitleViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"EditBookTitleViewController"];
    self.editBookTitleVC.bookObj = [Book createEmptyObject];
    self.editBookTitleVC.bookObj = bookObj;
    [self.navigationController pushViewController:self.editBookTitleVC animated:YES];
}
-(void)btnBuyClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    bookObj = [booksArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:bookObj.eCommerceUrl];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)btnLikeClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    bookObj = [booksArray objectAtIndex:indexPath.row];
    likeCount = [bookObj.noOfLikes intValue];
    
    likeCount++;
    //send push notification to author if number of likes of his book crosses particular number
    if (likeCount == 5) {
        User *userObj=[User convertPFObjectToUser:bookObj.authorId forNote:NO];
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"userId" equalTo:userObj.objectId];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Cogratulations!!!Number of Likes for your Book crossed over 50!!", @"alert",
                              @"Increment", @"badge",
                              @"", @"sound",
                              nil];
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        
        [push setChannels:[NSArray arrayWithObjects:@"Messages", nil]];
        [push setData:data];
        [push sendPushInBackground];
    }
   // NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    BookListTableViewCell *cell = (BookListTableViewCell *) [self.bookListTableView cellForRowAtIndexPath:indexPath];
    cell.likesCntLbl.text = [NSString stringWithFormat:@"%ld",(long)likeCount];
    //[self.bookListTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
       // bookObj.noOfLikes = [NSNumber numberWithInt:likeCount];
    
   
    
    PFUser *user= [PFUser currentUser];
    BookLikes *likes  = [BookLikes createEmptyObject];
     PFQuery *query1 = [PFQuery queryWithClassName:BOOK_LIKES];
    [query1 whereKey:LIKE_USER_ID equalTo:user.objectId];
     [query1 whereKey:LIKE_BOOK_ID equalTo:bookObj.objectId];
    [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            cell.likeButton.hidden = YES;
        }
        else{
            likes.bookId = bookObj.objectId;
            likes.userId = user.objectId;
            [likes saveBookLikesBlock:^(id object, NSError *error) {
                if (!error) {
                    NSLog(@"likes row inserted");
                }
            }];
            PFQuery *query = [PFQuery queryWithClassName:BOOK];
            [query getObjectInBackgroundWithId:bookObj.objectId block:^(PFObject *gObj, NSError *error) {
                
                // Now let's update it with some new data. In this case, only cheatMode and score
                // will get sent to the cloud. playerName hasn't changed.
                gObj[NUMBER_OF_LIKES] = [NSNumber numberWithInteger:likeCount];
                [gObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(!error){
                        NSLog(@"book updated!!");
                        // [APP_DELEGATE stopActivityIndicator];
                        // [self onBack:nil];
                        
                        [self fetchAllBooks];
                    }
                    
                }];
                
            }];


        }
    }];
    
   // bookObj = [booksArray objectAtIndex:indexPath.row];
    }

-(void)btnCommentClicked:(UIButton *)sender{
   
    
    SELECTEDBOOKID=[[NSString alloc]initWithString:[bObjectIdArr objectAtIndex:[sender tag]]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExcCommentViewController *excCommentVc = (ExcCommentViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ExcCommentViewController"];
    [self  presentViewController:excCommentVc animated:YES completion:nil];
    
}
-(void)btnShareClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    bookObj = [booksArray objectAtIndex:indexPath.row];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter",@"Mail", nil];
    [sheet showInView:self.view.window];

}
#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    else if (buttonIndex == 0){
        [self shareOnFacebook];
    }
    else if (buttonIndex == 1){
        [self shareOnTwitter];
    }
    else if (buttonIndex == 2){
        [self shareByMail];
    }
}
-(void)shareOnFacebook{
    SLComposeViewController *fbVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [fbVC setInitialText:bookObj.title];
    //add app url of itunesConnect
    [fbVC addURL:[NSURL URLWithString:@"https://developers.facebook.com/ios"]];
    
    [fbVC addImage:[UIImage imageNamed:@"ReadbookImage.png"]];
    
    [self presentViewController:fbVC animated:YES completion:nil];
}



-(void)shareOnTwitter{
    
    SLComposeViewController *fbVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [fbVC setInitialText:bookObj.title];
    //add app url of itunesConnect
    //[fbVC addURL:[NSURL URLWithString:@"https://developers.facebook.com/ios"]];
    
    [fbVC addImage:[UIImage imageNamed:@"ReadbookImage.png"]];
    
    [self presentViewController:fbVC animated:YES completion:nil];
    
}
-(void)shareByMail{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:bookObj.title];
        [mail setMessageBody:bookObj.shortDesc isHTML:NO];
        [mail setToRecipients:@[@"rasikabs1@gmail.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
    
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
#pragma mark
#pragma mark ====================== Search Bar Delegate ============================

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
    
    if(searchText.length == 0) {
        booksArray=nil;
        booksArray=[[NSMutableArray alloc]initWithArray:searchResults];
        [self.bookListTableView reloadData];
        [self.searchBar1 resignFirstResponder];
    } else {
        NSMutableArray *predicatesArray = [NSMutableArray new];
        
        NSString *attributeName1 = @"title";
        NSString *attributeValue1 =searchText;
        
        NSString *attributeName2 = @"genre";
        NSString *attributeValue2 =searchText;
        
        
        
        if (attributeValue1.length > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", attributeName1, attributeValue1];
            [predicatesArray addObject:predicate];
        }
        if (attributeValue2.length > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", attributeName2, attributeValue2];
            [predicatesArray addObject:predicate];
        }
                
        
        
        NSPredicate *finalPredicate;
        if (predicatesArray.count > 1) {
            finalPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicatesArray];
        }
        else
        {
            finalPredicate = [predicatesArray objectAtIndex:0];
        }
        
        filterdArray =[[NSMutableArray alloc]init];
        filterdArray = [[searchResults filteredArrayUsingPredicate:finalPredicate] mutableCopy];
        
        booksArray=nil;
        booksArray=[[NSMutableArray alloc]initWithArray:filterdArray];
        
        
        if (booksArray.count > 0) {
            [self.bookListTableView reloadData];
            
            // self.navigationItem.rightBarButtonItem = nil;
            
        } else {
            
        }

    }
    

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)asearchBar {
    
    asearchBar.text=nil;
    booksArray=nil;
    booksArray=[[NSMutableArray alloc]initWithArray:searchResults];
    [self.bookListTableView reloadData];
    [asearchBar resignFirstResponder];// if you want the keyboard to go away
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
