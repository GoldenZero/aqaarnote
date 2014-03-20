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
    [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_field"]]];
    [self.signUpView insertSubview:fieldsBackground atIndex:1];

    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    
    [self.signUpView.usernameField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.signUpView.passwordField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.signUpView.emailField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.signUpView.additionalField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    // Change "Additional" to match our use
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
    
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    
    [self.signUpView.dismissButton setFrame:CGRectMake(15.0f, 15.0f, 12.0f, 21.0f)];
    [self.signUpView.logo setFrame:CGRectMake(145.0f, 15.0f, 25.0f, 28.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.fieldsBackground setFrame:CGRectMake(15.0f, fieldFrame.origin.y + yOffset, 282.0f, 37.0f * 5)];
    
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
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
    
    else{
        [self.signUpView.additionalField resignFirstResponder];
    }
    
}

@end
