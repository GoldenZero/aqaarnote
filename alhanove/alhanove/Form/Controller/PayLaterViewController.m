//
//  PayLaterViewController.m
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "PayLaterViewController.h"

@interface PayLaterViewController ()

@end

@implementation PayLaterViewController

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
    
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    [self.thanksTitleLbl setFont:[UIFont mediumGeSSOfSize:15]];
    [self.contentText setFont:[UIFont lightGeSSOfSize:15]];
    [self.bookIDLbl setFont:[UIFont mediumGeSSOfSize:17]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
