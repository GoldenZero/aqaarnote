//
//  TwoLineCell.h
//  alhanove
//
//  Created by Noor on 5/26/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLineCell : UITableViewCell

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@end
