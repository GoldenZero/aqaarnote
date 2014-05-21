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
    
    BOOL dateFromFlag;

    NSArray *flightClassesArray;
    
    int guestsNumber;
    
    int roomsNumber;
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
    
    guestsNumber=1;
    roomsNumber=1;
    
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
    if (self.guestStepper.value>guestsNumber) {
        guestsNumber++;
        self.guestsLabel.text=[NSString stringWithFormat:@"%i",guestsNumber];
    }
    
    else {
        if (guestsNumber!=1) {
            guestsNumber--;
            self.guestsLabel.text=[NSString stringWithFormat:@"%i",guestsNumber];
        }
    }
}

- (IBAction)roomStepPrss:(id)sender {
    
    if (self.roomStepper.value>roomsNumber) {
        roomsNumber++;
        self.roomsLabel.text=[NSString stringWithFormat:@"%i",roomsNumber];
    }
    
    else {
        if (roomsNumber!=1) {
            roomsNumber--;
            self.roomsLabel.text=[NSString stringWithFormat:@"%i",roomsNumber];
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
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if (dateFromFlag) {
        self.fromDateLabel.text = [dateFormat stringFromDate:date];

    }
    else{
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
