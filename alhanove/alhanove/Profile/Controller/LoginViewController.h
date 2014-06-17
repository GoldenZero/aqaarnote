//
//  LoginViewController.h
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UITextField *mobileTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *countryImgView;

#pragma mark - Actions

- (IBAction)loginBtnPrss:(id)sender;
- (IBAction)registerBtnPrss:(id)sender;
- (IBAction)forgetpassBtnPrss:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
- (IBAction)countriesBtnPrss:(id)sender;

@end
