//
//  FormViewController.h
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerSelector.h"
#import "HotelListingViewController.h"

@interface FormViewController : UIViewController<SBPickerSelectorDelegate>

#pragma mark - Properties 
@property (strong, nonatomic) IBOutlet UILabel *guestTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *guestsLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsLabel;

@property (strong, nonatomic) IBOutlet UILabel *fromDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *fromDateTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *flightClassTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *flightClassLabel;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UILabel *screenLabel;
#pragma mark - Buttons Actions
- (IBAction)moreGuestsBtnPrss:(id)sender;

- (IBAction)lessGuestsBtnPrss:(id)sender;

- (IBAction)moreRoomsBtnPrss:(id)sender;

- (IBAction)lessRoomsBtnPrss:(id)sender;

- (IBAction)backBtnPrss:(id)sender;

- (IBAction)nextBtnPrss:(id)sender;

- (IBAction)fromDateBtnPrss:(id)sender;

- (IBAction)flightClassBtnPrss:(id)sender;

@end
