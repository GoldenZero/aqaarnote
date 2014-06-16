//
//  CarFormViewController.m
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarFormViewController.h"

@interface CarFormViewController (){
    
    SBPickerSelector *FromDatePicker;
    SBPickerSelector *ToDatePicker;
    SBPickerSelector *carTypePicker;

    FormObject * form;
    
    BOOL dateFromFlag;
    BOOL dateFromChoosed;

    BOOL dateToFlag;
    BOOL dateToChoosed;

    BOOL placeFromFlag;
    BOOL placeFromChoosed;

    BOOL placeToFlag;
    BOOL placeToChoosed;

    BOOL carTypeChoosed;
    NSArray *carTypesArray;
    
}


@end

@implementation CarFormViewController

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
    [self setViewDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setViewDetails{
    
    
    carTypesArray=[[NSArray alloc] initWithObjects:@"سيارة اقتصادية",@"سيارة متوسطة الحجم",@"سيارة عائلية",@"سيارة فخمة", nil];
    
    form=[[FormObject alloc] init];
    form.guestsNumber=1;
    form.roomsNumber=1;
    
    // Set picker view
    FromDatePicker = [SBPickerSelector picker];
    FromDatePicker.delegate = self;
    FromDatePicker.pickerType=SBPickerSelectorTypeDate;
    FromDatePicker.datePickerType=SBPickerSelectorDateTypeOnlyDayTime;
    FromDatePicker.doneButtonTitle = @"تم";
    FromDatePicker.cancelButtonTitle = @"إغلاق";
    
    // Set picker view
    ToDatePicker = [SBPickerSelector picker];
    ToDatePicker.delegate = self;
    ToDatePicker.pickerType=SBPickerSelectorTypeDate;
    ToDatePicker.datePickerType=SBPickerSelectorDateTypeOnlyDayTime;
    ToDatePicker.doneButtonTitle = @"تم";
    ToDatePicker.cancelButtonTitle = @"إغلاق";
    
    // Set picker view
    carTypePicker = [SBPickerSelector picker];
    carTypePicker.delegate = self;
    carTypePicker.pickerData = [[NSMutableArray alloc] initWithArray:carTypesArray]; //picker content

    carTypePicker.pickerType=SBPickerSelectorTypeText;
    carTypePicker.doneButtonTitle = @"تم";
    carTypePicker.cancelButtonTitle = @"إغلاق";
    
    // Set Custom font
    [self.pickupTitleLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.dropofTitleLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.carTypeTitleLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.nextButton.titleLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.fromDateLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.fromPlaceLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.toDateLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.toPlaceLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.carTypeLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.screenLabel setFont:[UIFont mediumGeSSOfSize:18]];
    
    
    //NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.fromDateLabel.text = @"حدد التاريخ";
    self.toDateLabel.text = @"حدد التاريخ";
    self.fromPlaceLabel.text = @"حدد المكان";
    self.toPlaceLabel.text = @"حدد المكان";
    self.carTypeLabel.text = @"حدد الفئة";
    
    
}

#pragma mark - Buttons Actions


- (IBAction)backBtnPrss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnPrss:(id)sender {
    
    if (!dateFromChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد تاريخ الإنطلاق" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!placeFromChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد مكان الإنطلاق" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if (!dateToChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد تاريخ العودة" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (!placeToChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد مكان العودة" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!carTypeChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد فئة السيارة" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    form.rentalDays = [self daysBetweenDate:form.fromDate andDate:form.toDate];
    
    [self performSegueWithIdentifier:@"showCarsList" sender:self];
}

- (IBAction)fromDateBtnPrss:(id)sender {
    
    dateFromFlag = YES;
    dateToFlag = NO;
    [FromDatePicker showPickerOver:self];

}

- (IBAction)fromPlaceBtnPrss:(id)sender
{
    placeFromFlag=YES;
    placeToFlag = NO;
    
    [self performSegueWithIdentifier:@"showSearchDetails" sender:self];


}

- (IBAction)toDateBtnPrss:(id)sender {
    
    dateToFlag = YES;
    dateFromFlag = NO;
    [ToDatePicker showPickerOver:self];

}

- (IBAction)toPlaceBtnPrss:(id)sender
{
    placeToFlag = YES;
    placeFromFlag=NO;
    [self performSegueWithIdentifier:@"showSearchDetails" sender:self];

}

- (IBAction)carTypeBtnPrss:(id)sender
{
    [carTypePicker showPickerOver:self];
}

#pragma mark - SBPickerSelectorDelegate
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    form.carType = value;
    self.carTypeLabel.text = value;
    carTypeChoosed = YES;
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if (dateFromFlag) {
        form.fromDate=date;
        self.fromDateLabel.text = [dateFormat stringFromDate:date];
        dateFromChoosed = YES;

    }
    else if (dateToFlag) {
        form.toDate=date;
        self.toDateLabel.text=[dateFormat stringFromDate:date];
        dateToChoosed = YES;

    }
}

-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    
}

-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
    if ([value isMemberOfClass:[NSDate class]]) {
        
        [self SBPickerSelector:selector dateSelected:value];
    }
    else{
        [self SBPickerSelector:selector selectedValue:value index:idx];
    }
}

#pragma mark - search details delegate
-(void)chosenPlace:(NSString *)place
{
    if (placeFromFlag) {
        self.fromPlaceLabel.text = place;
        placeFromChoosed = YES;
    }else if (placeToFlag)
    {
        self.toPlaceLabel.text = place;
        placeToChoosed = YES;
    }
}

#pragma mark - storyBoard delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showCarsList"])   //parameter to login page
    {
        CarListingViewController* vc = segue.destinationViewController;
        //vc.listingType = ListingTypeMekka;
        vc.formObj = form;
    }
    else if ([segue.identifier isEqualToString:@"showSearchDetails"]) {
        
        SearchDetailsVC *vc=segue.destinationViewController;
        vc.delegate=self;
    }
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end