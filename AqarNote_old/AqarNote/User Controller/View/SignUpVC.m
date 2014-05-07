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
    EnhancedKeyboard *enhancedKeyboard;
    
}
@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

// Variables for moving UI up 
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;
CGFloat animatedDistance;

@implementation SignUpVC

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;

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
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    self.signUpView.additionalField.hidden=YES;

    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    
    [self.signUpView.usernameField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.signUpView.passwordField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.signUpView.emailField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];

    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
    
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    
    [self.signUpView.dismissButton setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    [self.signUpView.logo setFrame:CGRectMake(145.0f, 15.0f, 25.0f, 28.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(45.0f, 200.0f, 235.0f, 45.0f)];
    [self.fieldsBackground setFrame:CGRectMake(0.0f, 50.0f,320.0f,41*4)];
    

    [self.signUpView.usernameField setFrame:CGRectMake(0.0f,91.0f,320.0,41.0f)];
    [self.signUpView.usernameField setPlaceholder:@" الاسم الكامل"];
    [self.signUpView.usernameField setTextAlignment:NSTextAlignmentRight];
    self.signUpView.usernameField.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:14];

    [self.signUpView.usernameField setBackground:[UIImage imageNamed:@"list_bar"]];
    yOffset += fieldFrame.size.height;
    

   
    [self.signUpView.passwordField setFrame:CGRectMake (0.0f,132.0f,320.0,41.0f)];
    [self.signUpView.passwordField setPlaceholder:@" كلمة المرور"];
    [self.signUpView.passwordField setTextAlignment:NSTextAlignmentRight];
    self.signUpView.passwordField.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:14];

    [self.signUpView.passwordField setBackground:[UIImage imageNamed:@"list_bar"]];

    yOffset += fieldFrame.size.height;
    

    [self.signUpView.emailField setFrame:CGRectMake(0.0f,50.0f,320.0,41.0f)];
    [self.signUpView.emailField setPlaceholder:@" البريد الإلكتروني"];
    [self.signUpView.emailField setTextAlignment:NSTextAlignmentRight];
    self.signUpView.emailField.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:14];

    [self.signUpView.emailField setBackground:[UIImage imageNamed:@"list_bar"]];

    
    yOffset += fieldFrame.size.height;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)doneDidTouchDown
{
    if ([self.signUpView.usernameField isEditing]) {
        [self.signUpView.usernameField resignFirstResponder];
    }
    
    else if ([self.signUpView.passwordField isEditing]) {
        [self.signUpView.passwordField resignFirstResponder];
    }
   
    else if ([self.signUpView.emailField isEditing]) {
        [self.signUpView.emailField resignFirstResponder];
    }
    
//    else{
//        [self.signUpView.additionalField resignFirstResponder];
//    }
    
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
