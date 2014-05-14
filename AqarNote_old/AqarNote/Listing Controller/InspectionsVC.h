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
#import "ChoosePropertyVC.h"
#import "AddNewInspectionVC.h"
@interface InspectionsVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,ChoosePropertyDelegate,InspectPropertyDelegate>


@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *inspectionsTable;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addNewProperImg;
@property (weak, nonatomic) IBOutlet UIImageView *addNewInspectImage;
@property (strong, nonatomic) IBOutlet UIImageView *noInspecImage;
@property (strong, nonatomic) IBOutlet UITextField *titleSearchTxtField;

@property (strong, nonatomic) IBOutlet UIView *searchView;

- (IBAction)addInspectionBtnPrss:(id)sender;

- (IBAction)searchBtnPrss:(id)sender;
- (IBAction)searchPanlBtnPrss:(id)sender;
- (IBAction)cancelSearchBtnPrss:(id)sender;


@end
