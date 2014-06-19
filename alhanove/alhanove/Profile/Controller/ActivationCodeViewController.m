//
//  ActivationCodeViewController.m
//  alhanove
//
//  Created by Noor on 6/17/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "ActivationCodeViewController.h"

@interface ActivationCodeViewController ()

@end

@implementation ActivationCodeViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)skipBtnPrss:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:NSLocalizedString(@"activate_later_dialog", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
    [alert show];
    
    [self performSegueWithIdentifier:@"BackToHome" sender:self];

}

- (IBAction)confirmBtnPrss:(id)sender {
    
    NSString* title = NSLocalizedString(@"dialog_error_title", @"");
    
    
    if (_code.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"register_form_dialog_error_active_code", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [[NetworkEngine getInstance] activateConfirmationCode:self.code.text mobileNumber:self.mobNum completionBlock:^(NSObject* o)
     {
         
         NSDictionary* result = (NSDictionary*)o;
         NSNumber* status = result[@"status"];
         
         if (status.integerValue == 202)
         {
             
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:result[@"message"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             [alert show];
             return;
             
         }
         else{
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:result[@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
             alert.tag = 1;
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

- (IBAction)resendBtnPrss:(id)sender {
    [[NetworkEngine getInstance] sendConfirmationCode:self.mobNum completionBlock:^(NSObject* o)
     {
         NSDictionary* result = (NSDictionary*)o;
         //NSNumber* status = result[@"status"];
         
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thanks_title", @"") message:result[@"message"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
         [alert show];
         return;
         
     }failureBlock:^(NSError* error)
     {
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
         [alert show];
         return;
     }];
    
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {
        
    }
}

#pragma mark -UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            
            [[NetworkEngine getInstance] getRefreshToken:@"200" withUser:self.mobNum password:self.passwd completionBlock:^(NSObject* response)
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

@end
