//
//  RegisterViewController.h
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "CountryListDataSource.h"
#import "LoginViewController.h"
#import "SBPickerSelector.h"
@interface RegisterViewController : UIViewController<UITextFieldDelegate,SBPickerSelectorDelegate>

#pragma mark - Properties

@property (unsafe_unretained, nonatomic) id<LoginProtocolDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) CountryListDataSource* countryListDataSource;
@property (strong, nonatomic) Country* selectedCountry;
@property (strong, nonatomic) IBOutlet UILabel *titleLAbel;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryKeyBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *genderBtn;
@property (strong, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *checkTermsBtn;
@property (strong, nonatomic) IBOutlet UIImageView *flagImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

@property (strong, nonatomic) IBOutlet UILabel *termsLbl;
@property (strong, nonatomic) IBOutlet UIButton *termsButton;
@property (strong, nonatomic) IBOutlet UILabel *genderLbl;
@property (strong, nonatomic) IBOutlet UILabel *birthDateLbl;

#pragma mark - Actions

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)createAccountButtonPressed:(id)sender;
- (IBAction)showCountriesButtonPressed:(id)sender;
- (IBAction)showGenderPressed:(id)sender;
- (IBAction)showBirthdayPressed:(id)sender;
- (IBAction)termsCheckPressed:(id)sender;
- (IBAction)backBtnPrss:(id)sender;

@end
