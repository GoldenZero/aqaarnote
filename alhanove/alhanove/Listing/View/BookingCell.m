//
//  BookingCell.m
//  alhanove
//
//  Created by Noor on 6/19/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "BookingCell.h"

@implementation BookingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.pickupHead.font = [UIFont lightGeSSOfSize:14];
    self.dropoffHead.font = [UIFont lightGeSSOfSize:14];
    self.carTypeHead.font = [UIFont lightGeSSOfSize:14];
    self.carTypeLabel.font = [UIFont mediumGeSSOfSize:13];
    self.notesLabel.font = [UIFont mediumGeSSOfSize:13];
    self.priceHead.font = [UIFont lightGeSSOfSize:14];
    self.noteHead.font = [UIFont lightGeSSOfSize:14];
    self.bookNumHead.font = [UIFont lightGeSSOfSize:14];
    // Configure the view for the selected state
}


@end
