//
//  UserDataViewController.m
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "UserDataViewController.h"

@interface UserDataViewController ()
{
    EnhancedKeyboard *enhancedKeyboard;

}
@end

@implementation UserDataViewController

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
    
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender
{
    
}

- (IBAction)showDateInvoked:(id)sender
{
    
}

- (IBAction)passportAttachInvoked:(id)sender
{
    
}

- (IBAction)personalImgInvoked:(id)sender
{
    
}

- (IBAction)payNowInvoked:(id)sender
{
    
}

- (IBAction)payLaterInvoked:(id)sender
{
    
}


#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)doneDidTouchDown
{
    if ([self.NameText isEditing]) {
        [self.NameText resignFirstResponder];
    }
    
    else if ([self.AddressText isEditing]) {
        [self.AddressText resignFirstResponder];
    }
    else if ([self.AddressText isEditing]) {
        [self.AddressText resignFirstResponder];
    }
    else if ([self.EmailText isEditing]) {
        [self.EmailText resignFirstResponder];
    }
    else if ([self.MobileText isEditing]) {
        [self.MobileText resignFirstResponder];
    }
    
    
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.rightView = paddingView;
    textField.rightViewMode = UITextFieldViewModeAlways;
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

@end
