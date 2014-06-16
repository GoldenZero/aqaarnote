//
//  CarFeatureCell.m
//  alhanove
//
//  Created by Noor on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarFeatureCell.h"

@implementation CarFeatureCell

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

    // Configure the view for the selected state
}

@end
