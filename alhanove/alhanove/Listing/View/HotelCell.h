//
//  HotelCell.h
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *menuImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UIImageView *rateStarImg;
@property (strong, nonatomic) IBOutlet UILabel *costLbl;
@property (strong, nonatomic) IBOutlet UIButton *imgButton;
@property (strong, nonatomic) IBOutlet UILabel *addressLbl;
@property (strong, nonatomic) IBOutlet UILabel *guestNumbLbl;
@end
