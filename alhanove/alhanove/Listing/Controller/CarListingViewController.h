//
//  CarListingViewController.h
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarCell.h"
#import "SBPickerSelector.h"
#import "TimeLineViewController.h"
#import "CarDetailsVC.h"

@interface CarListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SBPickerSelectorDelegate>

@property (strong, nonatomic) FormObject* formObj;

@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *sortBtn;
@property (strong, nonatomic) IBOutlet UIButton *priceBtn;
@property (strong, nonatomic) IBOutlet UILabel *orderByLbl;

- (IBAction)backInvoked:(id)sender;
- (IBAction)nextInvoked:(id)sender;
- (IBAction)sortByInvoked:(id)sender;
- (IBAction)changePriceInvoked:(id)sender;


@end
