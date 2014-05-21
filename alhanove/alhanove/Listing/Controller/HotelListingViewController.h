//
//  HotelListingViewController.h
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelCell.h"
#import "SBPickerSelector.h"

typedef enum ListingType
{
    ListingTypeMadina = 0,
    ListingTypeMekka,
}ListingType;

@interface HotelListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SBPickerSelectorDelegate>

@property (nonatomic, strong) NSNumber* guestNumber;

@property (nonatomic, assign) ListingType listingType;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString* hotelType;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *sortBtn;
@property (strong, nonatomic) IBOutlet UIButton *priceBtn;

- (IBAction)backInvoked:(id)sender;
- (IBAction)nextInvoked:(id)sender;
- (IBAction)sortByInvoked:(id)sender;
- (IBAction)changePriceInvoked:(id)sender;


@end
