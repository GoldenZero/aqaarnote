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

@interface HomePageVC : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UITableView *propertiesTable;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addNewImage;

// Welcome view
@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (weak, nonatomic) IBOutlet UIImageView *welcomeBgImage;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

#pragma mark - Actions
- (IBAction)logoutPressed:(id)sender;
- (IBAction)signupBtnPrss:(id)sender;
- (IBAction)loginBtnPrss:(id)sender;

@end
