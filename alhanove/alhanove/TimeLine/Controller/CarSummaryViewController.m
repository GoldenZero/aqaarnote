//
//  CarSummaryViewController.m
//  alhanove
//
//  Created by GALMarei on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarSummaryViewController.h"
#import "CarUserDataViewController.h"
#import "CarFormViewController.h"

@interface CarSummaryViewController ()

@end

@implementation CarSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) prepareView{
    
    // Set Custom font
    [self.titleLabel setFont:[UIFont mediumGeSSOfSize:18]];
    [self.carNameLabel setFont:[UIFont mediumGeSSOfSize:20]];
    [self.carTypeLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.carDoorsLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.passengersLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.autoLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.acLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.fromDateLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.toDateLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.fromPlaceLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.toPlaceLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.costLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.daysLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.label1 setFont:[UIFont mediumGeSSOfSize:11]];
    [self.label2 setFont:[UIFont mediumGeSSOfSize:11]];
    [self.label3 setFont:[UIFont mediumGeSSOfSize:11]];
    [self.label4 setFont:[UIFont mediumGeSSOfSize:11]];
    
    // Fill Data

    self.carNameLabel.text=self.formObj.CarData.title;
    self.carTypeLabel.text=self.formObj.carType;
    self.daysLabel.text=[NSString stringWithFormat:@"%li Days" ,(long)self.formObj.rentalDays];
    self.carImage.image=[UIImage imageNamed:self.formObj.CarData.image];
    self.carDoorsLabel.text=[NSString stringWithFormat:@"%@", self.formObj.CarData.doors];
    self.passengersLabel.text=[NSString stringWithFormat:@"%@", self.formObj.CarData.passengers];
    self.autoLabel.text=[NSString stringWithFormat:@"%@", [self.formObj.CarData.automatic boolValue] ? @"Yes" : @"No"];
    self.acLabel.text=[NSString stringWithFormat:@"%@",[self.formObj.CarData.airCond boolValue] ? @"Yes" : @"No"];
    self.costLabel.text=[NSString stringWithFormat:@"%@ SR",self.formObj.carCost];
    self.fromPlaceLabel.text=self.formObj.FromPlace;
    self.toPlaceLabel.text=self.formObj.ToPlace;
    self.fromDateLabel.text= [NSDateFormatter localizedStringFromDate:self.formObj.fromDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    self.toDateLabel.text=[NSDateFormatter localizedStringFromDate:self.formObj.toDate
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCarUserForm"])   //parameter to login page
    {
 
        CarUserDataViewController* vc = segue.destinationViewController;
        vc.formObj = self.formObj;
    }
    else  if ([[segue identifier] isEqualToString:@"showEditCarFormVC"])   //parameter to login page
    {
        
        CarFormViewController* vc = segue.destinationViewController;
        vc.form = self.formObj;
    }

}


- (IBAction)nextBtnPrss:(id)sender {
    [self performSegueWithIdentifier:@"showCarUserForm" sender:self];
}

- (IBAction)editBtnPrss:(id)sender {
    
    [self performSegueWithIdentifier:@"showEditCarFormVC" sender:self];

    
}
@end
