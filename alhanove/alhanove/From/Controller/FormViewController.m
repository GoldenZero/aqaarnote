//
//  FormViewController.m
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "FormViewController.h"
#import "FormObject.h"

@interface FormViewController (){
    
    SBPickerSelector *DatePicker;
    
    SBPickerSelector *FlightClassPicker;
    
    FormObject * form;
    
    BOOL dateFromFlag;

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

}

#pragma mark - Buttons Actions 

- (IBAction)backBtnPrss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnPrss:(id)sender {
    
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

- (IBAction)guestsStepPrss:(id)sender {
    if (self.guestStepper.value>form.guestsNumber) {
        form.guestsNumber++;
        self.guestsLabel.text=[NSString stringWithFormat:@"%i",form.guestsNumber];
    }
    
    else {
        if (form.guestsNumber!=1) {
            form.guestsNumber--;
            self.guestsLabel.text=[NSString stringWithFormat:@"%i",form.guestsNumber];
        }
    }
}

- (IBAction)roomStepPrss:(id)sender {
    
    if (self.roomStepper.value>form.roomsNumber) {
        form.roomsNumber++;
        self.roomsLabel.text=[NSString stringWithFormat:@"%i",form.roomsNumber];
    }
    
    else {
        if (form.roomsNumber!=1) {
            form.roomsNumber--;
            self.roomsLabel.text=[NSString stringWithFormat:@"%i",form.roomsNumber];
        }
    }
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
   
    self.flightClassLabel.text=value;
    form.FlightClass=value;
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if (dateFromFlag) {
        form.fromDate=date;
        self.fromDateLabel.text = [dateFormat stringFromDate:date];

    }
    else{
        form.toDate=date;
        self.toDateLabel.text=[dateFormat stringFromDate:date];

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

@end
