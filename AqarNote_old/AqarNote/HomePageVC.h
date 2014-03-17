//
//  HomePageVC.h
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomePageVC : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UITableView *propertiesTable;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addNewImage;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;


// Welcome view
@property (strong, nonatomic) IBOutlet UIView *welcomeView;
@property (strong, nonatomic) IBOutlet UIImageView *welcomeBgImage;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

#pragma mark - Actions
- (IBAction)logoutPressed:(id)sender;
- (IBAction)signupBtnPrss:(id)sender;
- (IBAction)loginBtnPrss:(id)sender;
- (IBAction)searchBtnPrss:(id)sender;

@end
