//
//  ActivationCodeViewController.h
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationCodeViewController : UIViewController

#pragma mark - Properties
@property (strong, nonatomic) NSString *mobNum;
@property (strong, nonatomic) NSString *passwd;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *header1Label;
@property (strong, nonatomic) IBOutlet UILabel *header2Label;
@property (strong, nonatomic) IBOutlet UILabel *header3Label;
@property (strong, nonatomic) IBOutlet UITextField *code;

#pragma mark - Actions
- (IBAction)skipBtnPrss:(id)sender;
- (IBAction)confirmBtnPrss:(id)sender;
- (IBAction)resendBtnPrss:(id)sender;

@end
