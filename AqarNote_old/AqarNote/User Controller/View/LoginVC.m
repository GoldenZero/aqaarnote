//
//  LoginVC.m
//  AqarNote
//
//  Created by Noor on 3/10/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "LoginVC.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginVC (){
    EnhancedKeyboard *enhancedKeyboard;

}
@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation LoginVC
@synthesize fieldsBackground;

- (void)viewDidLoad
{
    [super viewDidLoad];
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"homebkg.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"header_white_arrow"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"header_white_arrow"] forState:UIControlStateHighlighted];
    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"sign_in_btn"] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"sign_in_btn"] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateHighlighted];

    [self.logInView.passwordForgottenButton setBackgroundColor:[UIColor clearColor]];
    [self.logInView.passwordForgottenButton setTitle:@"نسيت كلمة المرور؟" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];

    [self.logInView.passwordForgottenButton.titleLabel setFont:[UIFont fontWithName:@"" size:11.0f]];
    
        // Add login field background
    //fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bar"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    
    [self.logInView.usernameField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.logInView.passwordField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(15.0f, 15.0f, 12.0f, 21.0f)];
    [self.logInView.logo setFrame:CGRectMake(145.0f, 15.0f, 25.0f, 28.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(45.0f, 175.0f, 235.0f, 45.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(0.0f, 50.0f, 320.0f, 41.0f)];
    [self.logInView.usernameField setBackground:[UIImage imageNamed:@"list_bar"]];
    [self.logInView.usernameField setPlaceholder:@" اسم المستخدم "];
    [self.logInView.usernameField setTextAlignment:NSTextAlignmentRight];
    [self.logInView.passwordField setFrame:CGRectMake(0.0f, 91.0f, 320.0f, 41.0f)];
    [self.logInView.passwordField setPlaceholder:@" كلمة المرور "];
    [self.logInView.passwordField setBackground:[UIImage imageNamed:@"list_bar"]];
    [self.logInView.passwordField setTextAlignment:NSTextAlignmentRight];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(75.0f, 230.0f, 150.0f, 45.0f)];
    [self.fieldsBackground setFrame:CGRectMake(0.0f, 50.0f, 320.0f, 82.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)doneDidTouchDown
{
    if ([self.logInView.usernameField isEditing]) {
        [self.logInView.usernameField resignFirstResponder];
    }
    
    else if ([self.logInView.passwordField  isEditing]) {
        [self.logInView.passwordField  resignFirstResponder];
    }
   
    
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.rightView = paddingView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}


@end
