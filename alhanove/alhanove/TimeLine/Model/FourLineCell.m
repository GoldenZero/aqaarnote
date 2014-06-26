//
//  FourLineCell.m
//  alhanove
//
//  Created by Noor on 5/26/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "FourLineCell.h"

@implementation FourLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.detailsLabel.font = [UIFont mediumGeSSOfSize:12];
    self.dateLabel.font = [UIFont mediumGeSSOfSize:12];

    self.guestsNumLabel.font = [UIFont mediumGeSSOfSize:12];
    self.roomsNumLabel.font = [UIFont mediumGeSSOfSize:12];

    self.dateTitleLabel.font = [UIFont lightGeSSOfSize:13];
    self.guestsTitleLabel.font = [UIFont lightGeSSOfSize:13];
    self.roomsTitleLabel.font = [UIFont lightGeSSOfSize:13];

}

@end
