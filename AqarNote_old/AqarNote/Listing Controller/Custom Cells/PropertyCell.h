//
//  PropertyCell.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *propertyImage;
@property (strong, nonatomic) IBOutlet UILabel *propertyTitle;
@property (strong, nonatomic) IBOutlet UILabel *propertyLocation;
@property (strong, nonatomic) IBOutlet UILabel *propertyDate;
@property (strong, nonatomic) IBOutlet UITextView *detailsTxtView;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
