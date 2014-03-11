//
//  StartVC.h
//  AqarNote
//
//  Created by Noor on 3/10/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartVC : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>



#pragma mark - Properties 
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

#pragma mark - Actions
- (IBAction)signupBtnPrss:(id)sender;
- (IBAction)loginBtnPrss:(id)sender;

@end
