//
//  LoginVC.m
//  AqarNote
//
//  Created by Noor on 3/10/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "LoginVC.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginVC ()
@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation LoginVC
@synthesize fieldsBackground;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"big_logo_white"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"header_white_arrow"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"header_white_arrow"] forState:UIControlStateHighlighted];
    
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"FacebookDown.png"] forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
//    
//    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
//    [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
//    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"TwitterDown.png"] forState:UIControlStateHighlighted];
//    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"register_new_account_btn"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"register_new_account_btn"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
//    // Add login field background
//    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginFieldBG.png"]];
//    [self.logInView addSubview:self.fieldsBackground];
//    [self.logInView sendSubviewToBack:self.fieldsBackground];
//    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    
//    // Set field text color
//    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(15.0f, 15.0f, 12.0f, 21.0f)];
    [self.logInView.logo setFrame:CGRectMake(145.0f, 15.0f, 25.0f, 28.0f)];
//    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
//    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
//    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
//    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
//    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
//    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
