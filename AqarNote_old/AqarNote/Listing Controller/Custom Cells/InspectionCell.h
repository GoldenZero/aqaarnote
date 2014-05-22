//
//  InspectionCell.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *propertyImage;
@property (strong, nonatomic) IBOutlet UILabel *propertyTitle;
@property (strong, nonatomic) IBOutlet UILabel *propertyLocation;
@property (strong, nonatomic) IBOutlet UILabel *propertyDate;
@property (strong, nonatomic) IBOutlet UITextView *detailTxtView;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *progressImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@end
