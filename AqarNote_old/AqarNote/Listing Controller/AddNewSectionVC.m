//
//  AddNewSectionVC.m
//  AqarNote
//
//  Created by Noor on 4/27/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AddNewSectionVC.h"

@interface AddNewSectionVC ()

@end

@implementation AddNewSectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set custom font
    self.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    self.saveButton.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    self.cancelButton.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    self.aboutLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.sectionNameTxt.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons actions
- (IBAction)saveBtnPrss:(id)sender {
    if ([self.sectionNameTxt.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"عذراً" message:@"الرجاء إدخال اسم القسم" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        av.alertViewStyle = UIAlertViewStyleDefault;
        [av show];

    }
    else{
        if ([self checkConnection]) {
            [self.delegate addedSection:self.sectionNameTxt.text];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت"
                                        message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا"
                                       delegate:nil
                              cancelButtonTitle:@"موافق"
                              otherButtonTitles:nil] show];

        }
    }
}

- (IBAction)cancelBtnPrss:(id)sender {
    [self.delegate addedSection:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addSectionBtnPrss:(id)sender {
    if ([self.sectionNameTxt.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"عذراً" message:@"الرجاء إدخال اسم القسم" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        av.alertViewStyle = UIAlertViewStyleDefault;
        [av show];
        
    }
    else{
        [self.delegate addedSection:self.sectionNameTxt.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Check internet connection

- (bool) checkConnection{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return false;
    }
    else {
        return true;
    }
    
}
@end
