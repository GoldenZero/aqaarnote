//
//  CarSummaryViewController.h
//  alhanove
//
//  Created by GALMarei on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarSummaryViewController : UIViewController

#pragma mark - Properties
@property (strong, nonatomic) FormObject* formObj;
@property (strong, nonatomic) IBOutlet UILabel *carNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *carDoorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *passengersLabel;
@property (strong, nonatomic) IBOutlet UILabel *autoLabel;
@property (strong, nonatomic) IBOutlet UILabel *acLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *toDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *toPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UIImageView *carImage;

#pragma mark - Actions
- (IBAction)nextBtnPrss:(id)sender;
- (IBAction)editBtnPrss:(id)sender;

@end
