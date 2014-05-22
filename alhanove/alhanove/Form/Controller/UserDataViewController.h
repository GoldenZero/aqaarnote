//
//  UserDataViewController.h
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerSelector.h"

@interface UserDataViewController : UIViewController<SBPickerSelectorDelegate,EnhancedKeyboardDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *pageTitle;
@property (nonatomic, strong) IBOutlet UITextField* NameText;
@property (nonatomic, strong) IBOutlet UITextField* AddressText;
@property (nonatomic, strong) IBOutlet UITextField* EmailText;
@property (nonatomic, strong) IBOutlet UITextField* MobileText;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (nonatomic, strong) IBOutlet UIButton* dateBtn;
@property (nonatomic, strong) IBOutlet UIButton* passportAttachBtn;
@property (nonatomic, strong) IBOutlet UIButton* personalImgAttachBtn;
@property (nonatomic, strong) IBOutlet UIButton* payNowBtn;
@property (nonatomic, strong) IBOutlet UIButton* payLaterBtn;
@property (nonatomic, strong) IBOutlet UILabel* PriceLbl;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) NSString *tripCost;
@property (strong, nonatomic) FormObject* formObj;

- (IBAction)backInvoked:(id)sender;
- (IBAction)homeInvoked:(id)sender;
- (IBAction)showDateInvoked:(id)sender;
- (IBAction)passportAttachInvoked:(id)sender;
- (IBAction)personalImgInvoked:(id)sender;
- (IBAction)payNowInvoked:(id)sender;
- (IBAction)payLaterInvoked:(id)sender;

@end
