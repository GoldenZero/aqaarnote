//
//  FormViewController.m
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController (){
    
    SBPickerSelector *DatePicker;
    
    SBPickerSelector *FlightClassPicker;
    
    FormObject * form;
    
    BOOL dateFromFlag;
    BOOL dateChoosed;
    BOOL flightChoosed;
    
    NSArray *flightClassesArray;
    
}

@end

@implementation FormViewController

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
    
    
    flightClassesArray=[[NSArray alloc] initWithObjects:@"درجة أولى",@"درجة رجال الأعمال",@"درجة اقتصادية", nil];
    
    form=[[FormObject alloc] init];
    form.guestsNumber=1;
    form.roomsNumber=1;
    
    // Set picker view
    DatePicker = [SBPickerSelector picker];
    DatePicker.delegate = self;
    DatePicker.pickerType=SBPickerSelectorTypeDate;
    DatePicker.datePickerType=SBPickerSelectorDateTypeOnlyDay;
    DatePicker.doneButtonTitle = @"تم";
    DatePicker.cancelButtonTitle = @"إغلاق";
    
    FlightClassPicker = [SBPickerSelector picker];
    FlightClassPicker.delegate = self;
    FlightClassPicker.pickerType = SBPickerSelectorTypeText;
    FlightClassPicker.pickerData=[[NSMutableArray alloc] initWithArray:flightClassesArray];
    FlightClassPicker.doneButtonTitle = @"تم";
    FlightClassPicker.cancelButtonTitle = @"إغلاق";
    
    // Set Custom font
    [self.guestsLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.nextButton.titleLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.roomsLabel setFont:[UIFont mediumGeSSOfSize:14]];
    [self.fromDateLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.flightClassLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.roomsTitleLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.guestTitleLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.fromDateTitleLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.flightClassTitleLabel setFont:[UIFont lightGeSSOfSize:12]];
    [self.screenLabel setFont:[UIFont mediumGeSSOfSize:18]];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.fromDateLabel.text = [dateFormat stringFromDate:today];


}

#pragma mark - Buttons Actions 

- (IBAction)moreGuestsBtnPrss:(id)sender {
    form.guestsNumber++;
    self.guestsLabel.text=[NSString stringWithFormat:@"%i",form.guestsNumber];

}

- (IBAction)lessGuestsBtnPrss:(id)sender {
    if (form.guestsNumber!=1) {
        form.guestsNumber--;
        self.guestsLabel.text=[NSString stringWithFormat:@"%i",form.guestsNumber];
    }
}

- (IBAction)moreRoomsBtnPrss:(id)sender {
    form.roomsNumber++;
    self.roomsLabel.text=[NSString stringWithFormat:@"%i",form.roomsNumber];

}

- (IBAction)lessRoomsBtnPrss:(id)sender {
    if (form.roomsNumber!=1) {
        form.roomsNumber--;
        self.roomsLabel.text=[NSString stringWithFormat:@"%i",form.roomsNumber];

    }
   
}

- (IBAction)backBtnPrss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnPrss:(id)sender {
    
    if (!dateChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد تاريخ الإنطلاق" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!flightChoosed) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء تحديد درجة الطيران" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self performSegueWithIdentifier:@"showHotelList" sender:self];
}

- (IBAction)fromDateBtnPrss:(id)sender {
   
    dateFromFlag=true;
    
    [self showPicker:nil];
}

- (IBAction)toDateBtnPrss:(id)sender {
  
    dateFromFlag=false;

    [self showPicker:nil];
}

- (IBAction)flightClassBtnPrss:(id)sender {
    
    [self showPicker:sender];

}

#pragma mark - SBPickerSelectorDelegate

- (void) showPicker:(id)sender{
    
    CGPoint point = [self.view convertPoint:[sender frame].origin fromView:[sender superview]];
    CGRect frame = [sender frame];
    frame.origin = point;
    if (sender) {
        [FlightClassPicker showPickerOver:self];

    }
    else{
        [DatePicker showPickerOver:self];

    }
}

-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
   
    flightChoosed = YES;
    self.flightClassLabel.text=value;
    form.FlightClass=value;
    
    switch (idx) {
        case 0:
            form.FlightCost = @"4000";
            break;
        case 1:
            form.FlightCost = @"2500";
            break;
        case 2:
            form.FlightCost = @"1000";
            break;
        default:
            break;
    }
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if (dateFromFlag) {
        form.fromDate=date;
        self.fromDateLabel.text = [dateFormat stringFromDate:date];

    }
    else{
        form.toDate=date;
     //   self.toDateLabel.text=[dateFormat stringFromDate:date];

    }
    
    dateChoosed = YES;
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

#pragma mark - storyBoard delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showHotelList"])   //parameter to login page
    {
        HotelListingViewController* vc = segue.destinationViewController;
        vc.listingType = ListingTypeMekka;
        vc.formObj = form;
    }
}


@end
