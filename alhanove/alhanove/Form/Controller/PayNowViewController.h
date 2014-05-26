//
//  PayNowViewController.h
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKView.h"

@interface PayNowViewController : UIViewController<PKViewDelegate>

@property IBOutlet PKView* paymentView;
@property IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;


- (IBAction)backInvoked:(id)sender;
- (IBAction)homeInvoked:(id)sender;
- (IBAction)save:(id)sender;
@end
