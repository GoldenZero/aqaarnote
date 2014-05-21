//
//  HotelListingViewController.h
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelCell.h"

typedef enum ListingType
{
    ListingTypeMadina = 0,
    ListingTypeMekka,
}ListingType;

@interface HotelListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) ListingType listingType;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString* hotelType;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backInvoked:(id)sender;
- (IBAction)nextInvoked:(id)sender;


@end
