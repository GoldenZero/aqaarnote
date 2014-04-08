//
//  NotesVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnhancedKeyboard.h"
#import "BaseViewController.h"
@interface NotesVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,EnhancedKeyboardDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *countryTxtField;
@property (strong, nonatomic) IBOutlet UITextView *aboutTxtView;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTxtField;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) IBOutlet UIButton *countryButton;

#pragma mark - Actions
- (IBAction)logoutBtnPrss:(id)sender;
- (IBAction)editBtnPrss:(id)sender;
- (IBAction)backBtnPrss:(id)sender;
- (IBAction)chooseCountryBtnPrss:(id)sender;
- (IBAction)countryBtnPrss:(id)sender;

@end
