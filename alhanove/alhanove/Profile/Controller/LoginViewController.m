//
//  LoginViewController.m
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController (){
    
    SBPickerSelector *countriesPicker;

    NSArray* countryList;
    NSMutableArray *countriesName;

}

@end

@implementation LoginViewController

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
    
    // Set font
    [self.titleLabel setFont:[UIFont mediumGeSSOfSize:18]];

    // Set intial code
    NSMutableDictionary* dict= [NSMutableDictionary new];
    dict[@"name"] = @"Saudi Arabia";
    dict[@"dial_code"] = @"+966";
    dict[@"code"] = @"sa";
    _selectedCountry = [[Country alloc] initWithDictionary:dict];
    [_countriesButton setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
    _countryImgView.image=[UIImage imageNamed:_selectedCountry.code];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


- (IBAction)loginBtnPrss:(id)sender {
    
    [self.mobileTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    
    NSString* title = NSLocalizedString(@"dialog_error_title", @"");

    if (self.mobileTxtField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_phone", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!_selectedCountry) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_country_key", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if (self.passwordTxtField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_password", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    

    NSString* phoneKey = _selectedCountry.dialCode;
    NSString* phoneNum = self.mobileTxtField.text;
    phoneKey = [phoneKey stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* firstNum = [phoneNum substringWithRange:NSMakeRange(0, 1)];
    if ([firstNum isEqualToString:@"0"]) {
        phoneNum = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    NSString *allphoneNumber = [NSString stringWithFormat:@"%@%@",phoneKey,phoneNum];
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:NSLocalizedString(@"login_success", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
    [alert show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
/*
    //TODO call api to login
    [[NetworkEngine getInstance] getRefreshToken:@"200" withUser:allphoneNumber password:self.passwordTxtField.text completionBlock:^(NSObject* response)
     {
         NSDictionary* result = (NSDictionary*)response;
         NSNumber* status = result[@"status"];
         
         if (status.integerValue == 401) // user exist and not confirmed
         {

             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:result[@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_cancel", @"") otherButtonTitles:NSLocalizedString(@"dialog_confirmation_activate", @""), nil];
             alert.tag = 3;
             [alert show];
             return;
             
         }else{

             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:NSLocalizedString(@"login_success", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }failureBlock:^(NSError* error){

         if (error.code == 400) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:NSLocalizedString(@"login_error_credential", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
         }else
         {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
         }
     }];
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {

    }
 
 */
    
}


- (IBAction)registerBtnPrss:(id)sender {
    
    [self.mobileTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    [self performSegueWithIdentifier:@"showRegisterView" sender:self];

}

- (IBAction)forgetpassBtnPrss:(id)sender {
    
    [self.mobileTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    [self performSegueWithIdentifier:@"ShowForgetPassView" sender:self];

}

- (IBAction)backBtnPrss:(id)sender {
    
    [self.mobileTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)countriesBtnPrss:(id)sender {
    
    [self.mobileTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    [countriesPicker showPickerOver:self];
}

#pragma mark - SBPickerSelectorDelegate
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{

    _selectedCountry = [_countryListDataSource.countries objectAtIndex:idx];
    
    [_countriesButton setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
    [self.countryImgView setImage:[UIImage imageNamed:[_selectedCountry.code lowercaseString]]];

}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date
{
    

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

#pragma mark - UITextFieldDelegate protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
