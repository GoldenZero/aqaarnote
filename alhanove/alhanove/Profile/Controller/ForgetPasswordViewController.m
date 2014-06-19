//
//  ForgetPasswordViewController.m
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController (){

    SBPickerSelector *countriesPicker;
    
    NSArray* countryList;
    NSMutableArray *countriesName;

}

@end

@implementation ForgetPasswordViewController

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
    self.phoneTxtField.text=self.mobNumber;
    [_countriesButton setTitle:self.countryCode forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmBtnPrss:(id)sender {
    
    [self.phoneTxtField resignFirstResponder];
    
    NSString* title = NSLocalizedString(@"dialog_error_title", @"");
    
    if (self.phoneTxtField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_phone", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!_selectedCountry && !self.countryCode) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_country_key", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }

    NSString* phoneKey = _selectedCountry.dialCode;
    if ([self.countryCode length] != 0) {
        phoneKey = self.countryCode;
    }
    NSString* phoneNum = self.phoneTxtField.text;
    phoneKey = [phoneKey stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* firstNum = [phoneNum substringWithRange:NSMakeRange(0, 1)];
    if ([firstNum isEqualToString:@"0"]) {
        phoneNum = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    NSString *allphoneNumber = [NSString stringWithFormat:@"%@%@",phoneKey,phoneNum];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    
    [[NetworkEngine getInstance] forgetPasswordForMobile:allphoneNumber completionBlock:^(NSObject* o)
     {
         [self.phoneTxtField resignFirstResponder];
         NSDictionary* response = (NSDictionary*)o;
         NSNumber* status = response[@"status"];
         if ([status integerValue] == 200) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:response[@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             alert.tag = 1;
             [alert show];
             return;
         }
         else
         {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:response[@"message"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
             
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

- (IBAction)cancelBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)countriesBtnPrss:(id)sender {
    [self.phoneTxtField resignFirstResponder];
    [countriesPicker showPickerOver:self];

}

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SBPickerSelectorDelegate
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    
    _selectedCountry = [_countryListDataSource.countries objectAtIndex:idx];
    
    [_countriesButton setTitle:_selectedCountry.dialCode forState:UIControlStateNormal];
    [self.flagImeg setImage:[UIImage imageNamed:[_selectedCountry.code lowercaseString]]];
    
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


#pragma mark -UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (alertView.tag == 1) {
            if (buttonIndex == 0) {
//                tokenCode* token = [tokenCode getInstace];
//                token.mobile = allphoneNumber;
                // go to home page
                [self performSegueWithIdentifier:@"BackToHome" sender:self];
            }
            else if (buttonIndex == 1)
            {
                alertView.hidden = YES;
            }
        }

    
}
@end
