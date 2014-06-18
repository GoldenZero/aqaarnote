//
//  RegisterViewController.m
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkEngine.h"
#import "ActivationCodeViewController.h"
#import "ForgetPasswordViewController.h"

@interface RegisterViewController (){
    
    BOOL isTermsAccepted;
    NSArray* countryList;
    NSArray* genderList;
    
    UITextField* _activeField;

    NSMutableArray *countriesName;

    NSString* selectedGender;
    NSDate* selectedDate;
    NSString* allphoneNumber;
    NSString* phoneKey;
    NSString *tzName;

    SBPickerSelector *countriesPicker;
    SBPickerSelector *genderPicker;
    SBPickerSelector *birthdayPicker;

    
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareView{
    //initialize the country list
    _countryListDataSource = [[CountryListDataSource alloc] init];
    countryList = [_countryListDataSource countries];
    countriesName=[[NSMutableArray alloc] init];
    for (int i=0; i<countryList.count; i++) {
        Country* dict=[countryList objectAtIndex:i];
        NSString *temp=[NSString stringWithFormat:@"%@ : %@",dict.name, dict.dialCode];
        [countriesName addObject:temp];
    }
    // Set picker view
    countriesPicker = [SBPickerSelector picker];
    countriesPicker.delegate = self;
    countriesPicker.pickerData = [[NSMutableArray alloc] initWithArray:countriesName]; //picker content
    countriesPicker.pickerType=SBPickerSelectorTypeText;
    countriesPicker.doneButtonTitle = @"تم";
    countriesPicker.cancelButtonTitle = @"إغلاق";

    genderPicker = [SBPickerSelector picker];
    genderPicker.delegate = self;
    genderList = [[NSArray alloc] initWithObjects:@"أنثى",@"ذكر", @"", nil];
    selectedGender = @"أنثى";
    genderPicker.pickerData = [[NSMutableArray alloc] initWithArray:genderList]; //picker content
    genderPicker.pickerType=SBPickerSelectorTypeText;
    genderPicker.doneButtonTitle = @"تم";
    genderPicker.cancelButtonTitle = @"إغلاق";
    
    birthdayPicker = [SBPickerSelector picker];
    birthdayPicker.delegate = self;
    birthdayPicker.pickerType=SBPickerSelectorTypeDate;
    birthdayPicker.doneButtonTitle = @"تم";
    birthdayPicker.cancelButtonTitle = @"إغلاق";
    // Set font
    [self.titleLAbel setFont:[UIFont mediumGeSSOfSize:18]];
    
    // Set intial code
    NSMutableDictionary* dict= [NSMutableDictionary new];
    dict[@"name"] = @"Saudi Arabia";
    dict[@"dial_code"] = @"+962";
    dict[@"code"] = @"SA";
    _selectedCountry = [[Country alloc] initWithDictionary:dict];
    [self.countryKeyBtn setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
    [self.genderBtn setTitle:selectedGender forState:UIControlStateNormal];
    
    

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWebBrowser"])   //parameter to track page
    {
//        WebBrowserViewController *vc = segue.destinationViewController;
//        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Default_Language"] isEqualToString:@"ar"])
//            vc.externalLink = [NSURL URLWithString:@"http://jaziil.com/ar/tosHtml"];
//        else
//            vc.externalLink = [NSURL URLWithString:@"http://jaziil.com/en/tosHtml"];
//        
//        vc.currLabel = NSLocalizedString(@"setting_terms_conditions", @"");
        
    }else if ([[segue identifier] isEqualToString:@"showCodeActivation"])   //parameter to track page
    {
        ActivationCodeViewController *vc = segue.destinationViewController;
//        vc.mobNum = allphoneNumber;
//        vc.passwd = self.passwordTextField.text;
        
    }
    else if ([[segue identifier] isEqualToString:@"showForgetPasswordVC"])   //parameter to track page
    {
        ForgetPasswordViewController *vc = segue.destinationViewController;
//        vc.mobNumber = self.phoneNumberTextField.text;
//        vc.countryCode = _selectedCountry.dialCode;
//        
    }
}

#pragma mark - Buttons Actions

- (IBAction)backBtnPrss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)showCountriesButtonPressed:(id)sender{
    [_activeField resignFirstResponder];
    [countriesPicker showPickerOver:self];

}

- (IBAction)showGenderPressed:(id)sender{
    [_activeField resignFirstResponder];
    [genderPicker showPickerOver:self];

}
- (IBAction)showBirthdayPressed:(id)sender{
    [_activeField resignFirstResponder];
    [birthdayPicker showPickerOver:self];
    
}

- (IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)createAccountButtonPressed:(id)sender{
    
    NSString* title = NSLocalizedString(@"dialog_error_title", @"");
    
    if (_firstNameTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_first_name", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (_lastNameTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_last_name", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (_phoneNumberTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_phone", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (_emailTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_email", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (_passwordTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_password", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (_passwordTextField.text.length < 5)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_password_validation", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_password_verification", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!_selectedCountry) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_country_key", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }

    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [df setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
    
   
    [[NetworkEngine getInstance] createAccount:_firstNameTextField.text
                                      lastName:_lastNameTextField.text
                                         email:_emailTextField.text
                                         phone:allphoneNumber
                                   countryCode:phoneKey
                                      timeZone:tzName
                                      password:_passwordTextField.text
                                     dateBirth:[df stringFromDate:selectedDate]
                                        gender:selectedGender
                               completionBlock:^(NSObject *o) {
                                   //[_delegate loginFinished:YES];
                                   
                                   // Issue 45 : Auto Login After Register
                                   NSDictionary* result = (NSDictionary*)o;
                                   NSNumber* status = result[@"status"];
                                   if (status.integerValue == 302) // user exist and confirmed
                                   {
                                       
                                       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:[NSString stringWithFormat:@"%@, %@",result[@"message"],NSLocalizedString(@"register_reset_dialog", @"")] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_reset", @"") otherButtonTitles:NSLocalizedString(@"dialog_button_no", @""), nil];
                                       alert.tag = 1;
                                       [alert show];
                                       return;
                                       
                                   }
                                   else if (status.integerValue == 401) // user exist and not confirmed
                                   {
                                       
                                       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:result[@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_confirmation_activate", @"") otherButtonTitles:NSLocalizedString(@"dialog_button_cancel", @""), nil];
                                       alert.tag = 3;
                                       [alert show];
                                       return;
                                       
                                   }
                                   else if (status.integerValue == 202) // error
                                   {
                                       
                                       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:result[@"message"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                                       [alert show];
                                       return;
                                       
                                   }
                                   else if (status.integerValue == 402){
                                       
                                       [self performSegueWithIdentifier:@"showCodeActivation" sender:self];
                                       
                                   }else
                                   {
                                       [self loginInvoked];
                                   }
                               }
                                  failureBlock:^(NSError *e) {
                                      
                                      if (e.code == 400) {
                                          UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:NSLocalizedString(@"login_error_credential", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                                          [alert show];
                                          return;
                                      }else
                                      {
                                          UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:e.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                                          [alert show];
                                          return;
                                      }
                                  }];
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {
        
    }
    
}

-(void)loginInvoked
{
        [[NetworkEngine getInstance] getRefreshToken:@"200" withUser:allphoneNumber password:self.passwordTextField.text completionBlock:^(NSObject* response)
         {
             
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:NSLocalizedString(@"login_success", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             
             [self performSegueWithIdentifier:@"BackToHome" sender:self];
         }failureBlock:^(NSError* error){
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
             
         }];
        
        if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {
            
        }

}
- (IBAction)termsCheckPressed:(id)sender {
    
    if (!isTermsAccepted) {
        self.checkTermsBtn.selected = YES;
        [self.checkTermsBtn setImage:[UIImage imageNamed:@"btn_check_on_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isTermsAccepted = YES;
        [self.createAccountButton setEnabled:YES];
    }else
    {
        self.checkTermsBtn.selected = NO;
        [self.checkTermsBtn setImage:[UIImage imageNamed:@"btn_check_off_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isTermsAccepted = NO;
        [self.createAccountButton setEnabled:NO];
        
    }

}

#pragma mark - UITextFieldDelegate protocol

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _activeField=textField;
}

#pragma mark - SBPickerSelectorDelegate
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    
    if (selector==countriesPicker) {
        _selectedCountry = [_countryListDataSource.countries objectAtIndex:idx];
        
        [self.countryKeyBtn setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
        [self.flagImage setImage:[UIImage imageNamed:[_selectedCountry.code lowercaseString]]];
    }
    
    else if( selector==genderPicker){
        selectedGender = [genderList objectAtIndex:idx];
        
        [self.genderBtn setTitle:selectedGender forState:UIControlStateNormal];
    }

    
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date
{
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    selectedDate = date;
    [_birthdayBtn setTitle:[df stringFromDate:date] forState:UIControlStateNormal];

    
}

-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    
}

-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
    if ([value isMemberOfClass:[NSDate class]]) {
        
        [self SBPickerSelector:selector dateSelected:value];
    }
    else{
        [self SBPickerSelector:selector selectedValue:value index:idx];
    }
}

#pragma mark -UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (alertView.tag == 1) {
            if (buttonIndex == 0) {
                [self performSegueWithIdentifier:@"showForgetPasswordVC" sender:self];
            }
            else if (buttonIndex == 1)
            {
                alertView.hidden = YES;
            }
        }else if (alertView.tag == 2) {
            if (buttonIndex == 1) {
                
           //     [self CreateAccWithcountryCode];
            }
            else if (buttonIndex == 0)
            {
                alertView.hidden = YES;
            }
        }
        else if (alertView.tag == 3) {
            if (buttonIndex == 0) {

                [[NetworkEngine getInstance] sendConfirmationCode:allphoneNumber completionBlock:^(NSObject* o)
                 {
                     NSDictionary* result = (NSDictionary*)o;
                     NSNumber* status = result[@"status"];
                     if ([status integerValue] == 401) {
                         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_confirmation_activate", @"") message:[NSString stringWithFormat:NSLocalizedString(@"register_form_dialog_confirmation", @""),allphoneNumber] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_confirmation_edit", @"") otherButtonTitles:NSLocalizedString(@"dialog_button_yes", @""), nil];
                         alert.tag = 2;
                         [alert show];
                         return;
                     }else{
                         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:result[@"message"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                         [alert show];
                         
                         [self performSegueWithIdentifier:@"showCodeActivation" sender:self];
                     }
                     
                     
                 }failureBlock:^(NSError* error)
                 {
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                     [alert show];
                     return;
                 }];
                
                if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {
                    
                }
            }
            else if (buttonIndex == 1)
            {
                alertView.hidden = YES;
            }
        }
        else if (alertView.tag == 4)
        {
            
        }
}


@end
