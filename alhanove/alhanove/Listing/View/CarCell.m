//
//  CarCell.m
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarCell.h"

@implementation CarCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self.titleLbl setFont:[UIFont lightGeSSOfSize:11]];
    [self.typeLbl setFont:[UIFont lightGeSSOfSize:15]];

    // Configure the view for the selected state
}

@end
