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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtnPrss:(id)sender {
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end
