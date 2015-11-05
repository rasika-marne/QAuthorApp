//
//  BookListTableViewCell.h
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *bookDesc;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *bokkNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *likesCntLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentsCntLbl;
@property (weak, nonatomic) IBOutlet UILabel *genreNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageRangeLbl;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLbl;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end
