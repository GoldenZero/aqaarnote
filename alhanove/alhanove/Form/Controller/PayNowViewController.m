//
//  PayNowViewController.m
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "PayNowViewController.h"

@interface PayNowViewController ()

@end

@implementation PayNowViewController

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
    
    self.paymentView.delegate = self;
	[self.paymentView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PaymentKit
- (void)paymentView:(PKView *)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

- (void)paymentView:(PKView *)paymentView didChangeState:(PKViewState)state
{
	switch (state) {
		case PKViewStateCardNumber:
			self.helpLabel.text = @"Enter card number";
			break;
			
		case PKViewStateExpiry:
			self.helpLabel.text = @"Enter expiry date";
			break;
			
		case PKViewStateCVC:
			self.helpLabel.text = @"Enter security code";
			break;
	}
}


#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)homeInvoked:(id)sender
{
    [self performSegueWithIdentifier:@"BackToHome" sender:self];
}

- (IBAction)save:(id)sender
{
    
    
    PKCard *card = self.paymentView.card;
    
    NSLog(@"Card last4: %@", card.last4);
    NSLog(@"Card expiry: %lu/%lu", (unsigned long)card.expMonth, (unsigned long)card.expYear);
    NSLog(@"Card cvc: %@", card.cvc);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"شكرا" message:@"شكرا لك ، لقد اتتمت عمليه الدفع بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag = 0;
    [alert show];
    return;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        [self performSegueWithIdentifier:@"BackToHome" sender:self];

    }
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
