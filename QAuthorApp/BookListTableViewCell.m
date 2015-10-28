//
//  BookListTableViewCell.m
//  QAuthorApp
//
//  Created by Rasika  on 9/25/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "BookListTableViewCell.h"

@implementation BookListTableViewCell
@synthesize bookCoverImg,bookDesc,userNameLbl,likeButton,commentButton,shareButton,bokkNameLbl;
@synthesize likesCntLbl,commentsCntLbl,genreNameLbl,ageRangeLbl,editButton,buyButton,priceLbl;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
