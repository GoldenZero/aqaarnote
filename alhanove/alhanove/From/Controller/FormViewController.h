//
//  FormViewController.h
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerSelector.h"

@interface FormViewController : UIViewController<SBPickerSelectorDelegate>

#pragma mark - Properties 

@property (strong, nonatomic) IBOutlet UILabel *guestsLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsLabel;

@property (strong, nonatomic) IBOutlet UILabel *fromDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *toDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *flightClassLabel;

@property (strong, nonatomic) IBOutlet UIStepper *guestStepper;

@property (strong, nonatomic) IBOutlet UIStepper *roomStepper;

#pragma mark - Buttons Actions

- (IBAction)backBtnPrss:(id)sender;

- (IBAction)nextBtnPrss:(id)sender;

- (IBAction)fromDateBtnPrss:(id)sender;

- (IBAction)toDateBtnPrss:(id)sender;

- (IBAction)flightClassBtnPrss:(id)sender;

- (IBAction)guestsStepPrss:(id)sender;

- (IBAction)roomStepPrss:(id)sender;
@end