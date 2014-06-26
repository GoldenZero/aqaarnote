//
//  CarFormViewController.h
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerSelector.h"
#import "SearchDetailsVC.h"
#import "CarListingViewController.h"

@interface CarFormViewController : UIViewController<SBPickerSelectorDelegate,SearchDetailDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UILabel *pickupTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *dropofTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *carTypeTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *fromDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *fromPlaceLabel;

@property (strong, nonatomic) IBOutlet UILabel *toDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *toPlaceLabel;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UILabel *screenLabel;

@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (strong, nonatomic)  FormObject * form;

#pragma mark - Buttons Actions

- (IBAction)backBtnPrss:(id)sender;

- (IBAction)nextBtnPrss:(id)sender;

- (IBAction)fromDateBtnPrss:(id)sender;

- (IBAction)fromPlaceBtnPrss:(id)sender;

- (IBAction)toDateBtnPrss:(id)sender;

- (IBAction)toPlaceBtnPrss:(id)sender;

- (IBAction)carTypeBtnPrss:(id)sender;


@end
