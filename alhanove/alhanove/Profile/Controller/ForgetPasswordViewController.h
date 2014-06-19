//
//  ForgetPasswordViewController.h
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListDataSource.h"
#import "Country.h"
#import "SBPickerSelector.h"

@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate,SBPickerSelectorDelegate>

#pragma mark - Properties

@property (strong, nonatomic) CountryListDataSource* countryListDataSource;
@property (strong, nonatomic) Country* selectedCountry;

@property (strong, nonatomic) NSString* mobNumber;
@property (strong, nonatomic) NSString* countryCode;
@property (nonatomic) NSInteger countryIndex;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *flagImeg;
@property (strong, nonatomic) IBOutlet UITextField *phoneTxtField;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *countriesButton;

#pragma mark - Actions
- (IBAction)confirmBtnPrss:(id)sender;

- (IBAction)cancelBtnPrss:(id)sender;

- (IBAction)countriesBtnPrss:(id)sender;

- (IBAction)backBtnPrss:(id)sender;
@end
