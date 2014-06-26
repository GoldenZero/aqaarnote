//
//  TwoLineCell.m
//  alhanove
//
//  Created by Noor on 5/26/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "TwoLineCell.h"

@implementation TwoLineCell

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

    self.titleLabel.font = [UIFont mediumGeSSOfSize:12];
    
    self.subtitleLabel.font = [UIFont lightGeSSOfSize:13];}

@end
