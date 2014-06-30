//
//  SignUpVC.m
//  AqarNote
//
//  Created by Noor on 3/10/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "SignUpVC.h"
#import <QuartzCore/QuartzCore.h>

@interface SignUpVC (){
    
}
@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation SignUpVC

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];

   [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"homebkg.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo"]]];

    // Change button apperance
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"header_white_arrow"] forState:UIControlStateNormal];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"header_white_arrow"] forState:UIControlStateHighlighted];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"register_new_account_btn"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"register_new_account_btn"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add background for fields
    [self.signUpView insertSubview:fieldsBackground atIndex:1];

    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    self.signUpView.additionalField.hidden=NO;

    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
    
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    
    [self.signUpView.dismissButton setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    [self.signUpView.logo setFrame:CGRectMake(145.0f, 15.0f, 25.0f, 28.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(270.0f, 0.0f, 50.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(0.0f, 50.0f,320.0f,41*4)];
    

    [self.signUpView.usernameField setFrame:CGRectMake(0.0f,50.0f,320.0,41.0f)];
    [self.signUpView.usernameField setPlaceholder:@" البريد الإلكتروني"];
    [self.signUpView.usernameField setTextAlignment:NSTextAlignmentRight];
    self.signUpView.usernameField.font=[UIFont fontWithName:@"Tahoma" size:14];

    [self.signUpView.usernameField setBackground:[UIImage imageNamed:@"list_bar"]];
    yOffset += fieldFrame.size.height;
    

   
    [self.signUpView.passwordField setFrame:CGRectMake (0.0f,132.0f,320.0,41.0f)];
    [self.signUpView.passwordField setPlaceholder:@" كلمة المرور"];
    [self.signUpView.passwordField setTextAlignment:NSTextAlignmentRight];
    self.signUpView.passwordField.font=[UIFont fontWithName:@"Tahoma" size:14];

    [self.signUpView.passwordField setBackground:[UIImage imageNamed:@"list_bar"]];

    yOffset += fieldFrame.size.height;
    

    [self.signUpView.additionalField setFrame:CGRectMake(0.0f,91.0f,320.0,41.0f)];
    [self.signUpView.additionalField setPlaceholder:@" الاسم الكامل"];
    [self.signUpView.additionalField setTextAlignment:NSTextAlignmentRight];
    self.signUpView.additionalField.font=[UIFont fontWithName:@"Tahoma" size:14];

    [self.signUpView.additionalField setBackground:[UIImage imageNamed:@"list_bar"]];

    
    yOffset += fieldFrame.size.height;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField*)sender {
    [sender resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    aTextField.rightView = paddingView;
    aTextField.rightViewMode = UITextFieldViewModeAlways;


}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

@end
