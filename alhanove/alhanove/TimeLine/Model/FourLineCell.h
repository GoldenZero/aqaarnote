//
//  FourLineCell.h
//  alhanove
//
//  Created by Noor on 5/26/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourLineCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;

@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@property (strong, nonatomic) IBOutlet UILabel *guestsTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *guestsNumLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsNumLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
