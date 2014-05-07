//
//  ChoosePropertyVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddNewInspectionVC.h"
@interface ChoosePropertyVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UITableView *propertiesTable;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)cancelButtonPressed:(id)sender;

@end
