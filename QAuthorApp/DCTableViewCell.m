//
//  DCTableViewCell.m
//  QAuthorApp
//
//  Created by Pooja on 10/13/15.
//  Copyright (c) 2015 Rasika . All rights reserved.
//

#import "DCTableViewCell.h"

@implementation DCTableViewCell
@synthesize followBtn,authornameLbl,ageLabel,cityLabel,countryLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
