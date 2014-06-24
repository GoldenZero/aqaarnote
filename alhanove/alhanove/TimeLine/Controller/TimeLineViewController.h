//
//  TimeLineViewController.h
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataViewController.h"
#import "MenuCell.h"
#import "BookingEntity.h"

@interface TimeLineViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) FormObject* formObj;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backInvoked:(id)sender;
- (IBAction)nextInvoked:(id)sender;

@end
