//
//  CarCell.h
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *menuImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *costLbl;
@property (strong, nonatomic) IBOutlet UIButton *imgButton;
@property (strong, nonatomic) IBOutlet UILabel *rentalDaysLbl;

@end
