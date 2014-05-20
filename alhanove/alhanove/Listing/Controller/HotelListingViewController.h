//
//  HotelListingViewController.h
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelCell.h"

@interface HotelListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
