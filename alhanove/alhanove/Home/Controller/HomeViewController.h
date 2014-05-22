//
//  HomeViewController.h
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"
#import "HotelListingViewController.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Buttons Actions
- (IBAction)oumraBtnPrss:(id)sender;
- (IBAction)hajBtnPrss:(id)sender;
- (IBAction)carsBtnPrss:(id)sender;
- (IBAction)flightBtnPrss:(id)sender;
- (IBAction)hotelsBtnPrss:(id)sender;
- (IBAction)bookingsBtnPrss:(id)sender;
@end
