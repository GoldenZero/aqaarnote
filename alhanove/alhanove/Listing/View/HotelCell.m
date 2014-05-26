//
//  HotelCell.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HotelCell.h"

@implementation HotelCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.titleLbl setFont:[UIFont lightGeSSOfSize:15]];
    [self.addressLbl setFont:[UIFont lightGeSSOfSize:11]];
    // Configure the view for the selected state
}

@end
