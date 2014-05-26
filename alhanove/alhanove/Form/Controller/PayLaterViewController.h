//
//  PayLaterViewController.h
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayLaterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *thanksTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) IBOutlet UILabel *bookIDLbl;

- (IBAction)backInvoked:(id)sender;
- (IBAction)homeInvoked:(id)sender;
@end
