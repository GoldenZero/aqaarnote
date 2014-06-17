//
//  CarUserDataViewController.h
//  alhanove
//
//  Created by GALMarei on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerSelector.h"

@interface CarUserDataViewController : UIViewController<SBPickerSelectorDelegate,EnhancedKeyboardDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>


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
@property (strong, nonatomic) IBOutlet UILabel *TotalLbl;

@property (strong, nonatomic) NSString *tripCost;
@property (strong, nonatomic) FormObject* formObj;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UIButton *checkInsuranceBtn;
@property (strong, nonatomic) IBOutlet UIButton *checkGPSBtn;
@property (strong, nonatomic) IBOutlet UIButton *checkChildBtn;

- (IBAction)backInvoked:(id)sender;
- (IBAction)homeInvoked:(id)sender;
- (IBAction)showDateInvoked:(id)sender;
- (IBAction)passportAttachInvoked:(id)sender;
- (IBAction)personalImgInvoked:(id)sender;
- (IBAction)payNowInvoked:(id)sender;
- (IBAction)payLaterInvoked:(id)sender;

- (IBAction)InsuranceCheckPressed:(id)sender;
- (IBAction)GPSCheckPressed:(id)sender;
- (IBAction)ChildCheckPressed:(id)sender;

@end
