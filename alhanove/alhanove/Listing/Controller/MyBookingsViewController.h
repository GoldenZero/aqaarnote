//
//  MyBookingsViewController.h
//  alhanove
//
//  Created by Noor on 6/19/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *bookingsTable;
@property (nonatomic, strong) NSMutableArray* bookings;


- (IBAction)backBtnPrss:(id)sender;

@end
