//
//  SectionCell.h
//  AqarNote
//
//  Created by Noor on 3/13/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCell : UITableViewCell

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UIImageView *sectionImage;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UIButton *sectionButtonPrssed;
@end
