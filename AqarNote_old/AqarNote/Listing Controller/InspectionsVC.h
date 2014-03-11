//
//  InspectionsVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InspectionsVC : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *inspectionsTable;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addNewProperImg;
@property (weak, nonatomic) IBOutlet UIImageView *addNewInspectImage;
- (IBAction)logoutPressed:(id)sender;

@end
