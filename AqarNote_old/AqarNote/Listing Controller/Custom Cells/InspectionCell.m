//
//  InspectionCell.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "InspectionCell.h"

@implementation InspectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.propertyImage=[[PFImageView alloc] init];
        self.propertyImage.image = [UIImage imageNamed:@"default_image_home.png"];
        self.propertyImage.contentMode  = UIViewContentModeScaleAspectFit;
        

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
