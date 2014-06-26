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
    [self.rentalDaysLbl setFont:[UIFont lightGeSSOfSize:12]];
    [self.costLbl setFont:[UIFont lightGeSSOfSize:12]];
    [self.doorsLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.autoLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.acLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.passengersLabel setFont:[UIFont lightGeSSOfSize:12]];

}

@end
