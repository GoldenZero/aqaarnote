//
//  LoginViewController.h
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "CountryListDataSource.h"
#import "SBPickerSelector.h"
@protocol LoginProtocolDelegate <NSObject>

- (void)loginFinished:(BOOL)withAccessToken;
- (void)loginFailed:(NSError*)error;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate,SBPickerSelectorDelegate>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UITextField *mobileTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *countriesButton;
@property (strong, nonatomic) IBOutlet UIImageView *countryImgView;
@property (unsafe_unretained, nonatomic) id<LoginProtocolDelegate> delegate;
@property (strong, nonatomic) CountryListDataSource* countryListDataSource;
@property (strong, nonatomic) Country* selectedCountry;

#pragma mark - Actions

- (IBAction)loginBtnPrss:(id)sender;
- (IBAction)registerBtnPrss:(id)sender;
- (IBAction)forgetpassBtnPrss:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
- (IBAction)countriesBtnPrss:(id)sender;

@end
